"""aquarelle.py -- skill atelier-graphiste, version 1.0 (16.11.2026). Peindre une feuille d'aquarelle par code.

Registre « illustration peinte » : primitives tirees du rendu A de l'essai du 16.11.2026, sans sa scene.
Tu composes ta propre image avec elles ; aucune scene toute faite n'est fournie, a dessein.

Dependances : Python 3.9+, numpy, Pillow. Aucune autre.
Essai : python3 aquarelle.py essai.png   -> un nuancier d'essai (trois lavis, une reserve, un trait de plume)

Usage :
    from aquarelle import Feuille
    f = Feuille(390, 844, echelle=2, papier='#F7F1E3')           # px CSS du cadre ; echelle = px par px CSS
    fond = f.bande(0, 300, adoucir_bas=60) * (1 - f.disque_doux(195, 180, 24, 27))   # 1 - disque = reserve
    f.lavis(f.deformer(fond, 5, 40, graine=1), '#A8957A', densite=.8, granulation=.3)  # couleur : celle de l'objet source
    f.plume([(40, 300), (120, 290), (200, 305)], largeur=1.1)
    f.sauver('img/fond.png')                                     # puis <img> ou background-image dans la planche
Toutes les coordonnees sont en px CSS du cadre ; masques = tableaux numpy (h, w) dans [0, 1].

Ce que font les primitives :
    lavis      couleur par la loi de Beer-Lambert (les lavis se superposent comme des glacis), granulation
               dans les creux du papier, pigment qui migre vers le bord qui seche (bord mouille), fleurs
    plume      trait reechantillonne, tremble, pression variable, encre qui accroche mal sur le grain
    deformer   bords irreguliers d'un masque (un lavis ne suit jamais le polygone)
    seche      masque de brosse seche : le pigment ne prend que sur les reliefs du grain
    reserve    un blanc de papier se reserve (1 - masque), il ne se peint pas en blanc
    formes     poly, ellipse, disque_doux, bande, trait_large ; bruit et flou en fonctions libres

Ce qu'il ne fait pas (limites constatees le 16.11.2026) :
    - aucun geste de pinceau : pas de coup de brosse directionnel ni de touche ; les formes restent celles
      des polygones donnes (un livre devient une boite) : dessiner les contours a la main, en points
      irreguliers, et varier les gestes, sinon le rendu reste geometrique ;
    - une seule qualite de lavis : pas de vrai mouille-sur-mouille qui diffuse, pas de reprise seche sur sec ;
    - repetitions mecaniques (sillons, hachures) visibles des qu'un motif se repete sans variation ;
    - rien d'anime : l'image se fige en PNG (environ 0,3 s par lavis plein cadre 390 x 844 a echelle 2,
      mesure le 16.11.2026 dans un conteneur Linux) ;
    - le texte ne se peint pas : il reste en HTML par-dessus, mesure sur le pire pixel (pixels.py).
"""
import sys
import numpy as np
from PIL import Image, ImageDraw


def bruit(h, w, echelle, octaves=4, graine=0, persistance=.5):
    """Bruit fractal lisse (valeur), dans [0, 1] ; echelle en px du tableau."""
    r = np.random.default_rng(graine); acc = np.zeros((h, w)); amp = 1; tot = 0
    for o in range(octaves):
        e = max(echelle / (2 ** o), 1.5)
        gh, gw = max(int(h / e) + 2, 2), max(int(w / e) + 2, 2)
        g = Image.fromarray((r.random((gh, gw)) * 255).astype(np.uint8)).resize((w, h), Image.BICUBIC)
        acc += amp * np.asarray(g, float) / 255; tot += amp; amp *= persistance
    acc /= tot
    return (acc - acc.min()) / (acc.max() - acc.min() + 1e-9)


def flou(a, r):
    """Flou presque gaussien : trois flous en boite separables, rayon r en px du tableau."""
    r = int(max(r, 1)); out = a.astype(float)
    for _ in range(3):
        for ax in (0, 1):
            c = np.cumsum(np.pad(out, [(r + 1, r) if i == ax else (0, 0) for i in range(2)], mode='edge'), axis=ax)
            out = (c[2 * r + 1:] - c[:-2 * r - 1]) / (2 * r + 1) if ax == 0 else (c[:, 2 * r + 1:] - c[:, :-2 * r - 1]) / (2 * r + 1)
    return out


def hexrgb(h):
    h = h.lstrip('#'); return np.array([int(h[i:i + 2], 16) for i in (0, 2, 4)]) / 255


class Feuille:
    def __init__(self, largeur, hauteur, echelle=2, papier='#F7F1E3', graine=11):
        self.S = echelle; self.W, self.H = int(largeur * echelle), int(hauteur * echelle); self.lw, self.lh = largeur, hauteur
        W, H = self.W, self.H
        relief = .55 * bruit(H, W, 7, 3, graine) + .30 * bruit(H, W, 26, 3, graine + 1) + .15 * bruit(H, W, 2.5, 1, graine + 2)
        self.relief = (relief - relief.min()) / (relief.max() - relief.min())   # grain du papier, 1 = bosse
        self.creux = 1 - self.relief
        ombrage = (self.relief - .5) * .045 + (np.roll(self.relief, 2, 0) - self.relief) * .05   # eclaire d'en haut
        self.c = np.clip(np.ones((H, W, 3)) * hexrgb(papier) * (1 + ombrage[..., None]), 0, 1)

    # ---------- formes (coordonnees en px CSS) ----------
    def poly(self, points, adoucir=0):
        im = Image.new('L', (self.W, self.H), 0)
        ImageDraw.Draw(im).polygon([(x * self.S, y * self.S) for x, y in points], fill=255)
        a = np.asarray(im, float) / 255
        return flou(a, adoucir * self.S) if adoucir else a

    def ellipse(self, cx, cy, rx, ry):
        yy, xx = np.ogrid[0:self.H, 0:self.W]
        return ((((xx - cx * self.S) / (rx * self.S)) ** 2 + ((yy - cy * self.S) / (ry * self.S)) ** 2) <= 1).astype(float)

    def disque_doux(self, cx, cy, r0, r1):
        """1 jusqu'au rayon r0, 0 au-dela de r1."""
        yy, xx = np.ogrid[0:self.H, 0:self.W]
        d = np.sqrt((xx - cx * self.S) ** 2 + (yy - cy * self.S) ** 2) / self.S
        return np.clip((r1 - d) / (r1 - r0), 0, 1) ** 1.6

    def bande(self, y0, y1, adoucir_haut=0, adoucir_bas=0):
        yy = np.arange(self.H)[:, None] / self.S * np.ones((1, self.W)); a = np.ones((self.H, self.W))
        a *= np.clip((yy - y0) / adoucir_haut, 0, 1) if adoucir_haut else (yy >= y0)
        a *= np.clip((y1 - yy) / adoucir_bas, 0, 1) if adoucir_bas else (yy <= y1)
        return a

    def trait_large(self, points, largeur):
        im = Image.new('L', (self.W, self.H), 0); dr = ImageDraw.Draw(im); p = np.array(points) * self.S
        for (xa, ya), (xb, yb) in zip(p[:-1], p[1:]):
            dr.line([(xa, ya), (xb, yb)], fill=255, width=int(largeur * self.S))
        return np.asarray(im, float) / 255

    def deformer(self, m, amplitude, echelle, graine=0):
        """Deplace un masque par un champ de bruit : bords irreguliers. amplitude et echelle en px CSS."""
        h, w = m.shape; amp, ech = amplitude * self.S, echelle * self.S
        dx = (bruit(h, w, ech, 3, graine) - .5) * 2 * amp; dy = (bruit(h, w, ech, 3, graine + 1) - .5) * 2 * amp
        yy, xx = np.mgrid[0:h, 0:w]
        x = np.clip(xx + dx, 0, w - 1.001); y = np.clip(yy + dy, 0, h - 1.001)
        x0, y0 = x.astype(int), y.astype(int); fx, fy = x - x0, y - y0
        return (m[y0, x0] * (1 - fx) * (1 - fy) + m[y0, x0 + 1] * fx * (1 - fy)
                + m[y0 + 1, x0] * (1 - fx) * fy + m[y0 + 1, x0 + 1] * fx * fy)

    def seche(self, seuil=.38, graine=0):
        """Masque de brosse seche : 1 sur les reliefs du grain, 0 dans les creux. Seuil plus haut = plus sec."""
        return np.clip((self.relief - seuil + .25 * (bruit(self.H, self.W, 12 * self.S / 2, 2, graine) - .5)) * 6, 0, 1)

    # ---------- peinture ----------
    def lavis(self, masque, pigment, densite=1., granulation=.5, bord=.9, rayon_bord=5, variation=.35,
              graine=0, fleurs=0, adoucir=.6):
        """Pose un lavis. pigment = couleur d'un lavis plein sur papier blanc (hex). Les lavis se multiplient."""
        H, W, S = self.H, self.W, self.S
        m = flou(masque, adoucir * S) if adoucir else masque
        d = m * densite * (1 + variation * (bruit(H, W, 90 * S / 2, 3, graine + 5) - .5) * 2)
        d = d * (1 + granulation * (self.creux - .5) * 2.2 + granulation * .6 * (bruit(H, W, 3, 1, graine + 6) - .5))
        d = d + bord * np.clip(m - flou(m, rayon_bord * S), 0, 1) * densite * 2.4      # bord mouille
        if fleurs:                                                                   # auréoles de reprise
            r = np.random.default_rng(graine + 7); ys, xs = np.nonzero(m > .6)
            yy, xx = np.ogrid[0:H, 0:W]
            for i in range(fleurs):
                if not len(xs): break
                j = r.integers(len(xs)); rad = r.uniform(18, 46) * S
                dist = np.sqrt((xx - xs[j]) ** 2 + (yy - ys[j]) ** 2) / rad + (bruit(H, W, 14 * S / 2, 2, graine + 50 + i) - .5) * .5
                d = d * (1 - .45 * np.clip(1 - dist, 0, 1) ** .6) + densite * m * .55 * np.exp(-((dist - 1) / .07) ** 2)
        k = -np.log(np.clip(hexrgb(pigment), .02, 1))
        self.c = self.c * np.exp(-k[None, None, :] * np.clip(d, 0, 4)[..., None])
        return self

    def plume(self, points, largeur=1.1, encre='#1D2733', graine=0, tremble=.9, opacite=.92, pointille=None):
        """Trait de plume, rendu a 4x puis reduit. largeur en px CSS ; pointille = longueur d'un tiret en px CSS."""
        p = np.array(points, float)
        seg = np.sqrt(((p[1:] - p[:-1]) ** 2).sum(1)); L = seg.sum()
        n = max(int(L * 1.5), 4); t = np.linspace(0, L, n); cum = np.concatenate([[0], np.cumsum(seg)])
        xs = np.interp(t, cum, p[:, 0]); ys = np.interp(t, cum, p[:, 1])
        r = np.random.default_rng(graine); f1 = r.uniform(.02, .05); f2 = r.uniform(.11, .2); ph = r.uniform(0, 6, 4)
        nx = np.gradient(ys); ny = -np.gradient(xs); nn = np.sqrt(nx ** 2 + ny ** 2) + 1e-9; nx /= nn; ny /= nn
        off = tremble * (.7 * np.sin(t * f1 + ph[0]) + .3 * np.sin(t * f2 + ph[1])); xs += nx * off; ys += ny * off
        pression = largeur * (.75 + .25 * np.sin(t * .03 + ph[2]) + .15 * np.sin(t * .17 + ph[3]))
        K = 4; im = Image.new('L', (int(self.lw * K), int(self.lh * K)), 0); dr = ImageDraw.Draw(im)
        for i in range(n):
            if pointille and int(t[i] / pointille) % 2: continue
            rr = pression[i] * K / 2
            dr.ellipse([xs[i] * K - rr, ys[i] * K - rr, xs[i] * K + rr, ys[i] * K + rr], fill=255)
        a = np.asarray(im.resize((self.W, self.H), Image.LANCZOS), float) / 255 * opacite
        a = a * (1 - .25 * (bruit(self.H, self.W, 2, 1, graine + 3) > .78))
        self.c = self.c * (1 - a[..., None]) + hexrgb(encre)[None, None, :] * a[..., None]
        return self

    def sauver(self, chemin):
        Image.fromarray((np.clip(self.c, 0, 1) * 255).astype(np.uint8)).save(chemin)
        return chemin


if __name__ == '__main__':
    # Nuancier d'essai : verifie que les primitives tournent. Ce n'est pas un modele de composition.
    f = Feuille(320, 200)
    for i, (pig, gran) in enumerate([('#6FA4CF', .2), ('#CF9257', .7), ('#6D7FB0', .95)]):
        x = 20 + i * 100
        m = f.deformer(f.poly([(x, 20), (x + 80, 20), (x + 80, 120), (x, 120)]), 2, 10, graine=i)
        f.lavis(m * (1 - f.disque_doux(x + 40, 60, 12, 14)) if i == 0 else m, pig, densite=.8, granulation=gran, graine=i * 10, fleurs=i == 1)
    f.lavis(f.trait_large([(20, 160), (300, 165)], 10) * f.seche(.45), "#A9653F", densite=.5, granulation=.9, graine=40, adoucir=.3)
    f.plume([(20, 185), (110, 178), (200, 188), (300, 180)], largeur=1.1, graine=5)
    print(f.sauver(sys.argv[1] if len(sys.argv) > 1 else 'essai-aquarelle.png'))
