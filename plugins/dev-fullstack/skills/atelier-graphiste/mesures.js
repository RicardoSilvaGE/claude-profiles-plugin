// mesures.js -- skill atelier-graphiste, version 2.0 (13.11.2026), teste sous Chrome sans fenetre.
// Mesure une planche de variantes ou chaque cadre d'ecran porte data-ecran="V1 accueil".
// Usage : copier ce fichier a cote de la planche et ajouter en fin de <body> :
//   <script src="mesures.js"></script>
// puis : chrome --headless=new --user-data-dir=<tmp> --virtual-time-budget=5000 --dump-dom "file:///<planche>.html"
// et lire le JSON du <pre id="mesures"> (masque : absent du PNG).
// Passe etroite : ajouter ?largeur=360 a l'URL ; seuls les cadres de telephone (360 a 430 px) sont retrecis.
// Angles morts : un controle dessine en <div> sans role, tabindex ni cursor:pointer ; le texte contenu
// dans une image ; le texte pose sur une image, un degrade ou un trace SVG (liste aEchantillonner, a
// mesurer sur les pixels du rendu).
addEventListener('load', async () => {
  await document.fonts.ready;
  const largeur = +new URLSearchParams(location.search).get('largeur') || 0;
  if (largeur) {
    document.querySelectorAll('[data-ecran]').forEach(e => {
      const w = e.getBoundingClientRect().width;
      if (w >= 360 && w <= 430) e.style.width = e.style.minWidth = e.style.maxWidth = largeur + 'px';
    });
    await document.fonts.ready; // la mise en page se recalcule a la premiere lecture de boite
  }

  // Couleurs : toute syntaxe CSS (rgb, hex, oklch...) passe par un pixel de canvas.
  const pixel = document.createElement('canvas');
  pixel.width = pixel.height = 1;
  const pctx = pixel.getContext('2d', { willReadFrequently: true });
  const cache = new Map();
  const TEMOIN = '#010203';
  const couleur = s => {
    if (!s || s === 'none' || s.startsWith('url')) return null;
    if (cache.has(s)) return cache.get(s);
    pctx.fillStyle = TEMOIN;
    pctx.fillStyle = s;
    let v = null;
    if (pctx.fillStyle !== TEMOIN || s.replace(/\s/g, '') === 'rgb(1,2,3)') {
      pctx.clearRect(0, 0, 1, 1);
      pctx.fillRect(0, 0, 1, 1);
      const d = pctx.getImageData(0, 0, 1, 1).data;
      v = [d[0], d[1], d[2], d[3] / 255];
    }
    cache.set(s, v);
    return v;
  };
  const melange = (dessus, dessous) => [0, 1, 2].map(i => dessus[3] * dessus[i] + (1 - dessus[3]) * dessous[i]).concat(1);
  const lum = c => c.slice(0, 3).map(v => (v /= 255) <= 0.04045 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4)
    .reduce((s, v, i) => s + v * [0.2126, 0.7152, 0.0722][i], 0);
  const ratio = (a, b) => { const [x, y] = [lum(a), lum(b)].sort((p, q) => q - p); return (x + 0.05) / (y + 0.05); };

  // Fond reel sous un element : fonds translucides composes jusqu'au premier fond opaque.
  const fond = el => {
    const couches = [];
    for (let e = el; e && e.nodeType === 1; e = e.parentElement) {
      const s = getComputedStyle(e);
      if (s.backgroundImage !== 'none') return { cause: 'image ou degrade', el: e };
      const c = couleur(s.backgroundColor);
      if (c && c[3] > 0) {
        couches.push(c);
        if (c[3] >= 0.999) return { c: couches.reduceRight((dessous, dessus) => melange(dessus, dessous)), el: e };
      }
    }
    couches.push([255, 255, 255, 1]);
    return { c: couches.reduceRight((dessous, dessus) => melange(dessus, dessous)), el: null };
  };
  // Texte SVG : la forme pleine qui le precede et couvre son centre sert de fond.
  const fondSvg = el => {
    const svg = el.ownerSVGElement || el.closest('svg');
    const b = el.getBoundingClientRect(), cx = b.x + b.width / 2, cy = b.y + b.height / 2;
    let dessous = null;
    svg.querySelectorAll('rect,circle,ellipse,path,polygon').forEach(f => {
      if (!(f.compareDocumentPosition(el) & Node.DOCUMENT_POSITION_FOLLOWING)) return;
      const r = f.getBoundingClientRect();
      if (cx >= r.left && cx <= r.right && cy >= r.top && cy <= r.bottom) dessous = f;
    });
    if (!dessous) return fond(svg);
    const fs = getComputedStyle(dessous), c = couleur(fs.fill);
    if (!c || c[3] < 1 || +fs.fillOpacity < 1 || +fs.opacity < 1 || /path|polygon/i.test(dessous.tagName))
      return { cause: 'forme SVG', el: dessous };
    return { c, el: dessous };
  };
  const opacite = (el, jusqua) => {
    let o = 1;
    for (let e = el; e && e !== jusqua; e = e.parentElement) o *= +getComputedStyle(e).opacity;
    return o;
  };

  // Polices : largeur mesuree a la graisse et au style reels, comparee aux replis generiques.
  const ctx = document.createElement('canvas').getContext('2d');
  const larg = police => { ctx.font = police; return ctx.measureText('Hamburgefonstiv 0123').width; };
  const GENERIQUES = /^(serif|sans-serif|monospace|cursive|fantasy|system-ui|ui-\w+|math|emoji)$/;
  const rendue = (fam, s) => {
    if (GENERIQUES.test(fam.replace(/["']/g, ''))) return true;
    const p = `${s.fontStyle} ${s.fontWeight} 40px `;
    return larg(p + fam + ',monospace') !== larg(p + 'monospace') || larg(p + fam + ',serif') !== larg(p + 'serif');
  };

  const boite = b => [b.x, b.y, b.width, b.height].map(Math.round);
  const nomDe = el => {
    const classe = typeof el.className === 'string' ? el.className : (el.className && el.className.baseVal) || '';
    return el.tagName.toLowerCase() + (classe ? '.' + classe.split(' ')[0] : '') + ' « ' + el.textContent.trim().slice(0, 24) + ' »';
  };
  const CIBLE = 'a[href],button,input:not([type=hidden]),select,textarea,summary,label[for],[role=button],[role=link],'
    + '[role=tab],[role=switch],[role=checkbox],[role=radio],[role=menuitem],[tabindex]:not([tabindex="-1"]),[onclick]';
  const CHAMP = 'input:not([type=hidden]):not([type=checkbox]):not([type=radio]):not([type=range]),select,textarea';

  const out = [];
  document.querySelectorAll('[data-ecran]').forEach(ecran => {
    const E = ecran.getBoundingClientRect();
    const r = {
      ecran: ecran.dataset.ecran, boite: boite(E), contraste: [], contrasteNonTexte: [], aEchantillonner: [],
      deborde: [], horsCadre: [], chevauche: [], ciblesSous24: [], ciblesSous44: [], polices: {}, couleursTexte: [],
      sousLePli: { elements: 0, coupesParLeBas: [] },
    };
    // Ancetre entre l'element et le cadre qui coupe ou fait defiler cet axe.
    const ancetreQuiCoupe = (el, axe) => {
      for (let e = el.parentElement; e && e !== ecran; e = e.parentElement)
        if (getComputedStyle(e)['overflow' + axe] !== 'visible') return e;
      return null;
    };
    // Exclus des chevauchements : tourne, transforme ou decoratif (aria-hidden), le cadre non compris.
    const libre = el => {
      for (let e = el; e && e !== ecran; e = e.parentElement) {
        const s = getComputedStyle(e);
        if (s.transform !== 'none' || (s.rotate && s.rotate !== 'none') || e.getAttribute('aria-hidden') === 'true') return false;
      }
      return true;
    };

    const textes = [], actifs = [], coupeurs = [];
    ecran.querySelectorAll('*').forEach(el => {
      const s = getComputedStyle(el), b = el.getBoundingClientRect();
      if (s.display === 'none' || s.visibility === 'hidden' || +s.opacity === 0 || !b.width || !b.height) return;
      const svg = el instanceof SVGElement;
      const texte = [...el.childNodes].some(n => n.nodeType === 3 && n.textContent.trim());
      const lienEnLigne = el.matches('a') && s.display === 'inline';
      const pointeur = s.cursor === 'pointer' && el.parentElement && getComputedStyle(el.parentElement).cursor !== 'pointer';
      const cible = !svg && !lienEnLigne && (el.matches(CIBLE) || pointeur);

      if (texte) {
        textes.push([el, b]);
        const px = parseFloat(s.fontSize), grand = px >= 24 || (px >= 18.66 && +s.fontWeight >= 700), seuil = grand ? 3 : 4.5;
        const f = svg ? fondSvg(el) : fond(el);
        const brut = couleur(svg ? s.fill : s.color);
        const plein = s.webkitTextFillColor && couleur(s.webkitTextFillColor);
        if (f.cause) r.aEchantillonner.push([nomDe(el), f.cause, boite(b)]);
        else if (!brut) r.aEchantillonner.push([nomDe(el), 'remplissage SVG non uni', boite(b)]);
        else if (!svg && plein && plein[3] === 0) r.aEchantillonner.push([nomDe(el), 'texte en degrade', boite(b)]);
        else {
          const a = brut[3] * opacite(el, f.el) * (svg ? +s.fillOpacity : 1);
          const k = ratio(melange([brut[0], brut[1], brut[2], a], f.c), f.c);
          if (k < seuil) r.contraste.push([nomDe(el), +k.toFixed(2), seuil]);
        }
        const fam = s.fontFamily.split(',')[0].trim();
        const p = r.polices[fam] = r.polices[fam] || { tailles: [], graisses: [], nonRendues: [] };
        if (!p.tailles.includes(px)) p.tailles.push(px);
        if (!p.graisses.includes(s.fontWeight)) {
          p.graisses.push(s.fontWeight);
          if (!rendue(fam, s)) p.nonRendues.push(s.fontWeight + (s.fontStyle === 'normal' ? '' : ' ' + s.fontStyle));
        }
        const teinteTexte = svg ? s.fill : s.color;
        if (!r.couleursTexte.includes(teinteTexte)) r.couleursTexte.push(teinteTexte);
      }

      // Debordements : le texte coupe par son propre cadre, ou qui sort de sa boite sans etre coupe.
      const coupeX = /hidden|clip/.test(s.overflowX), coupeY = /hidden|clip/.test(s.overflowY);
      if (texte && !svg) {
        if (coupeX && el.scrollWidth > el.clientWidth + 1) r.deborde.push(nomDe(el) + (s.textOverflow === 'ellipsis' ? ' (tronque)' : ' (coupe en largeur)'));
        else if (coupeY && el.scrollHeight > el.clientHeight + 1) r.deborde.push(nomDe(el) + (s.webkitLineClamp !== 'none' ? ' (tronque en lignes)' : ' (coupe en hauteur)'));
        else if (s.display !== 'inline' && s.overflowX === 'visible' && el.scrollWidth > el.clientWidth + 1) r.deborde.push(nomDe(el) + ' (sort de sa boite)');
      }
      if ((coupeX || coupeY) && !svg) coupeurs.push([el, b, coupeX, coupeY]);

      // Contraste hors texte (WCAG 1.4.11) : contour d'un champ, icone d'un bouton sans texte.
      if (el.matches(CHAMP)) {
        const dehors = fond(el.parentElement), dedans = fond(el);
        if (!dehors.cause && !dedans.cause) {
          let k = ratio(dedans.c, dehors.c);
          ['Top', 'Right', 'Bottom', 'Left'].forEach(cote => {
            const c = couleur(s['border' + cote + 'Color']);
            if (parseFloat(s['border' + cote + 'Width']) >= 1 && s['border' + cote + 'Style'] !== 'none' && c && c[3] > 0)
              k = Math.max(k, ratio(melange(c, dehors.c), dehors.c));
          });
          if (k < 3) r.contrasteNonTexte.push([nomDe(el), +k.toFixed(2), 3, 'contour de champ']);
        }
      } else if (cible && !el.textContent.trim()) {
        const trace = [...el.querySelectorAll('svg *')].find(t => {
          const ts = getComputedStyle(t), c = couleur(ts.stroke), p = couleur(ts.fill);
          return (c && c[3] > 0 && parseFloat(ts.strokeWidth) > 0) || (p && p[3] > 0 && !/^(svg|g|defs)$/i.test(t.tagName));
        });
        if (trace) {
          const ts = getComputedStyle(trace), c = couleur(ts.stroke), p = couleur(ts.fill);
          const teinte = c && c[3] > 0 && parseFloat(ts.strokeWidth) > 0 ? c : p, f = fond(el);
          if (!f.cause) {
            const k = ratio(melange(teinte, f.c), f.c);
            if (k < 3) r.contrasteNonTexte.push([nomDe(el), +k.toFixed(2), 3, 'icone']);
          }
        }
      }

      if (cible) {
        if (b.width < 24 || b.height < 24) r.ciblesSous24.push([nomDe(el), Math.round(b.width), Math.round(b.height)]);
        else if (b.width < 44 || b.height < 44) r.ciblesSous44.push([nomDe(el), Math.round(b.width), Math.round(b.height)]);
      }
      if ((texte || cible) && libre(el)) actifs.push([el, b]);

      // Position dans le cadre : hors cadre en largeur ou au-dessus = defaut ; sous le pli = information.
      if (texte || cible) {
        if (!ancetreQuiCoupe(el, 'X') && (b.left < E.left - 1 || b.right > E.right + 1)) r.horsCadre.push(nomDe(el));
        else if (!ancetreQuiCoupe(el, 'Y')) {
          if (b.top < E.top - 1) r.horsCadre.push(nomDe(el));
          else if (b.top >= E.bottom - 1) r.sousLePli.elements++;
          else if (b.bottom > E.bottom + 1) r.sousLePli.coupesParLeBas.push(nomDe(el));
        }
      }
    });

    // Un conteneur qui coupe n'est signale que s'il coupe du texte (une image recadree ne compte pas).
    coupeurs.forEach(([el, C, coupeX, coupeY]) => {
      const coupe = textes.find(([t, T]) => t !== el && el.contains(t) &&
        ((coupeX && (T.left < C.left - 1 || T.right > C.right + 1)) || (coupeY && (T.top < C.top - 1 || T.bottom > C.bottom + 1))));
      if (coupe) r.deborde.push(nomDe(el) + ' (coupe ' + nomDe(coupe[0]) + ')');
    });

    for (let i = 0; i < actifs.length; i++) for (let j = i + 1; j < actifs.length; j++) {
      const [a, A] = actifs[i], [c, C] = actifs[j];
      if (a.contains(c) || c.contains(a)) continue;
      const dx = Math.min(A.right, C.right) - Math.max(A.left, C.left), dy = Math.min(A.bottom, C.bottom) - Math.max(A.top, C.top);
      if (dx > 1 && dy > 1) r.chevauche.push([nomDe(a), nomDe(c)]);
    }
    out.push(r);
  });
  const pre = document.createElement('pre');
  pre.id = 'mesures';
  pre.hidden = true;
  pre.textContent = JSON.stringify(out);
  document.body.appendChild(pre);
});
