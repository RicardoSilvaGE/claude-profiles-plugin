"""pixels.py -- skill atelier-graphiste, version 1.0 (16.11.2026). Mesures sur les pixels du rendu.

Ce que mesures.js ne peut pas voir, parce qu'il lit des boites et des couleurs declarees, pas des pixels :
le contraste d'un texte pose sur une image, un degrade, une texture ou une forme SVG ; le contact reel
d'un tres grand texte (chiffre d'affiche, titre a fond perdu), dont la boite deborde largement le trace.

Dependances : Python 3.9+, numpy, Pillow. Aucune autre.
Entrees : des PNG rendus a la meme taille par Chrome sans fenetre, et le JSON de releve.js.

Sous-commandes (python3 pixels.py <sous-commande> -h pour le detail) :
  extraire  <dom.html> <mesures|releve>                -> imprime le JSON du <pre id=...> d'un --dump-dom
  contraste <planche.png> <fond.png> <releve.json>      -> pire ratio entre la couleur du texte, lue sur ses
            pixels d'encre (opacite et oklch() deja composees), et les pixels du fond qui touchent chaque
            glyphe ; fond.png = meme rendu avec ?masque=textes. JSON {mesures, nonMesures} ; sortie 1 si un
            texte est sous le seuil, 2 si un texte n'a pas pu etre mesure (liste sur stderr)
  contact   <planche.png> <sans.png> <releve.json>      -> trace reel de l'element masque (?masque=<selecteur>)
            et pixels de ce trace dans la boite de chaque autre texte (textes aria-hidden exclus,
            comme dans mesures.js ; le masque ne doit viser que l'element signale)
  decouper  <planche.png> <mesures.json> <dossier>      -> un PNG par cadre data-ecran, pour le regarder (Read)

Commun : --echelle = px du PNG par px CSS (le --force-device-scale-factor du rendu, 2 par defaut).

Ce qu'il ne fait pas : il ne rend rien (Chrome rend) ; il ne juge pas la lisibilite d'une police ni la
taille ; un texte sous 1 px CSS de haut ou entierement hors cadre est ignore ; le contraste prend la
couleur mediane du coeur des glyphes (un texte en degrade se mesure a la main, couleur la plus claire
et la plus sombre) ; sur une police tres fine a petite taille, le coeur reste anticrenele et la mesure
peche par prudence.
"""
import argparse, html, json, re, sys
import numpy as np
from PIL import Image


def charger(chemin):
    return np.asarray(Image.open(chemin).convert('RGB'), float) / 255


def luminance(rgb):
    lin = np.where(rgb <= 0.04045, rgb / 12.92, ((rgb + 0.055) / 1.055) ** 2.4)
    return lin[..., 0] * 0.2126 + lin[..., 1] * 0.7152 + lin[..., 2] * 0.0722


def charger_releve(chemin):
    """Liste des textes de releve.js ; une erreur signalee par releve.js arrete la mesure."""
    data = json.load(open(chemin, encoding='utf-8'))
    if isinstance(data, dict) and 'erreur' in data:
        sys.exit('releve.js : ' + data['erreur'])
    return data


def zone(a, boite, k):
    x, y, w, h = boite
    return a[int(y * k):int(np.ceil((y + h) * k)), int(x * k):int(np.ceil((x + w) * k))]


def dilater(m, r):
    d = m.copy()
    for dy in range(-r, r + 1):
        for dx in range(-r, r + 1):
            d |= np.roll(np.roll(m, dy, 0), dx, 1)
    return d


def cmd_extraire(a):
    dom = open(a.dom, encoding='utf-8').read()
    m = re.search(r'<pre id="%s"[^>]*>(.*?)</pre>' % re.escape(a.quoi), dom, re.S)
    if not m:
        sys.exit('pas de <pre id="%s"> : script absent de la planche, ou --virtual-time-budget trop court' % a.quoi)
    print(html.unescape(m.group(1)))


def cmd_contraste(a):
    """Couleur du texte lue sur les pixels d'encre du rendu, pas sur la couleur declaree : l'opacite
    d'un parent, un format oklch() ou color(), un melange de calques y sont deja composes."""
    k = a.echelle
    avec, fond = charger(a.planche), charger(a.fond)
    if avec.shape != fond.shape:
        sys.exit('les deux PNG doivent avoir la meme taille : %s contre %s' % (avec.shape, fond.shape))
    res, non_mesures = [], []
    for t in charger_releve(a.releve):
        if t.get('decoratif'):
            continue
        z, za = zone(fond, t['boite'], k), zone(avec, t['boite'], k)
        ecart = np.abs(za - z).sum(-1) if z.size else np.zeros((0, 0))
        encre = ecart > a.seuil_encre
        if not encre.any():
            # Rien ne change entre les deux captures : texte transparent, masque sans effet, ou
            # texte de la couleur exacte du fond. Aucun de ces cas ne se declare conforme.
            non_mesures.append((t, 'aucun pixel d encre entre la capture normale et la capture masquee'))
            continue
        # Coeur du glyphe : le quart des pixels d'encre les plus eloignes du fond (les bords
        # anticreneles melangent texte et fond et feraient croire a un contraste plus faible).
        coeur = encre & (ecart >= np.percentile(ecart[encre], 75))
        lt = float(np.median(luminance(za[coeur])))
        pres = dilater(encre, max(1, round(1.5 * k)))           # le fond qui touche le glyphe
        lb = luminance(z)[pres]
        ratios = (np.maximum(lb, lt) + 0.05) / (np.minimum(lb, lt) + 0.05)
        grand = t['taille'] >= 24 or (t['taille'] >= 18.66 and t['graisse'] >= 700)
        seuil = 3 if grand else 4.5
        res.append({'ecran': t['ecran'], 'nom': t['nom'], 'texte': t['texte'][:40], 'taille': t['taille'], 'seuil': seuil,
                    'couleurDeclaree': t['couleur'], 'pire': round(float(ratios.min()), 2),
                    'centile1': round(float(np.percentile(ratios, 1)), 2), 'ok': bool(ratios.min() >= seuil)})
    json.dump({'mesures': res, 'nonMesures': [{'ecran': t['ecran'], 'nom': t['nom'], 'texte': t['texte'][:40], 'cause': c}
                                              for t, c in non_mesures]}, sys.stdout, ensure_ascii=False, indent=1)
    print(file=sys.stderr)
    for e in sorted({x['ecran'] for x in res}):
        r = [x for x in res if x['ecran'] == e]
        p = min(r, key=lambda x: x['pire'] / x['seuil'])
        print('%s : %d textes, %d sous le seuil ; pire marge : %s « %s » %s:1 (seuil %s)'
              % (e, len(r), sum(not x['ok'] for x in r), p['nom'], p['texte'][:24], p['pire'], p['seuil']), file=sys.stderr)
    for t, cause in non_mesures:
        print('NON MESURE : %s %s « %s » : %s' % (t['ecran'], t['nom'], t['texte'][:30], cause), file=sys.stderr)
    if non_mesures:
        sys.exit(2)
    if any(not x['ok'] for x in res):
        sys.exit(1)


def cmd_contact(a):
    k = a.echelle
    avec, sans = charger(a.planche), charger(a.sans)
    if avec.shape != sans.shape:
        sys.exit('les deux PNG doivent avoir la meme taille : %s contre %s' % (avec.shape, sans.shape))
    trace = np.abs(avec - sans).sum(-1) > a.seuil_encre       # pixels de l'element masque, et de lui seul
    textes = charger_releve(a.releve)
    cibles = [t for t in textes if t.get('masque')]
    if not cibles:
        sys.exit('aucun texte marque "masque" dans le releve : le releve doit venir de la meme URL ?masque=<selecteur>')
    out = []
    for e in sorted({t['ecran'] for t in cibles}):
        # trace reel : les pixels qui changent, bornes a la boite de l'element masque dans ce cadre
        bx = [t['boite'] for t in cibles if t['ecran'] == e]
        x0 = min(b[0] for b in bx); y0 = min(b[1] for b in bx)
        x1 = max(b[0] + b[2] for b in bx); y1 = max(b[1] + b[3] for b in bx)
        sous = zone(trace, (x0, y0, x1 - x0, y1 - y0), k)
        ys, xs = np.nonzero(sous)
        if not len(xs):
            # Aucun pixel ne change : masque oublie, sans effet, ou mauvaise URL. « Sans contact » serait faux.
            sys.exit('%s : trace vide, aucun pixel ne change entre les deux captures ; verifier que sans.png '
                     'vient bien de ?masque=<selecteur> et que le selecteur vise l element signale' % e)
        reel = [round(float(x0 + xs.min() / k), 1), round(float(y0 + ys.min() / k), 1),
                                         round(float(x0 + (xs.max() + 1) / k), 1), round(float(y0 + (ys.max() + 1) / k), 1)]
        marge = a.marge
        contacts = []
        for t in textes:
            if t['ecran'] != e or t.get('masque') or (t.get('decoratif') and not a.avec_decoratifs):
                continue
            x, y, w, h = t['boite']
            n = int(zone(trace, (x - marge, y - marge, w + 2 * marge, h + 2 * marge), k).sum())
            if n:
                contacts.append({'nom': t['nom'], 'texte': t['texte'][:30], 'pixels': n})
        out.append({'ecran': e, 'boiteDeclaree': [round(x0, 1), round(y0, 1), round(x1, 1), round(y1, 1)],
                    'traceReel': reel, 'marge': marge, 'contacts': contacts})
        print('%s : boite %s, trace reel %s ; textes touches a %s px pres : %s'
              % (e, out[-1]['boiteDeclaree'], reel, marge,
                 ', '.join('%s (%d px)' % (c['texte'], c['pixels']) for c in contacts) or 'aucun'), file=sys.stderr)
    json.dump(out, sys.stdout, ensure_ascii=False, indent=1)


def cmd_decouper(a):
    k = a.echelle
    im = Image.open(a.planche)
    for c in json.load(open(a.mesures, encoding='utf-8')):
        x, y, w, h = c['boite']
        nom = re.sub(r'[^\w-]+', '-', c['ecran']).strip('-').lower()
        im.crop((int(x * k), int(y * k), int((x + w) * k), int((y + h) * k))).save('%s/%s.png' % (a.dossier, nom))
        print('%s/%s.png' % (a.dossier, nom))


def main():
    p = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    s = p.add_subparsers(dest='cmd', required=True)
    e = s.add_parser('extraire'); e.add_argument('dom'); e.add_argument('quoi', choices=['mesures', 'releve'])
    c = s.add_parser('contraste'); c.add_argument('planche'); c.add_argument('fond'); c.add_argument('releve')
    t = s.add_parser('contact'); t.add_argument('planche'); t.add_argument('sans'); t.add_argument('releve')
    t.add_argument('--marge', type=float, default=2, help='px CSS autour de chaque boite de texte (2)')
    t.add_argument('--avec-decoratifs', action='store_true', help='compter aussi les textes aria-hidden (exclus par defaut, comme dans mesures.js)')
    d = s.add_parser('decouper'); d.add_argument('planche'); d.add_argument('mesures'); d.add_argument('dossier')
    for x in (c, t, d):
        x.add_argument('--echelle', type=float, default=2)
    for x in (c, t):
        x.add_argument('--seuil-encre', type=float, default=0.06, help='ecart RGB cumule qui compte comme trace (0.06)')
    a = p.parse_args()
    {'extraire': cmd_extraire, 'contraste': cmd_contraste, 'contact': cmd_contact, 'decouper': cmd_decouper}[a.cmd](a)


if __name__ == '__main__':
    main()
