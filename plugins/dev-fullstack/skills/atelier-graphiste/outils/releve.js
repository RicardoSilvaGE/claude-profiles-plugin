// releve.js -- skill atelier-graphiste, version 1.0 (16.11.2026), teste sous Chrome sans fenetre.
// Complement de mesures.js : releve chaque texte visible de chaque cadre data-ecran (texte entier,
// boite serree sur les lignes, couleur, taille, graisse) et sait masquer du texte pour une capture.
// Sert a trois choses :
//   1. la liste des textes de l'ecran, a confronter au brief ligne par ligne (aucune donnee ajoutee) ;
//   2. le contraste sur le pire pixel (pixels.py contraste) : capture normale + capture ?masque=textes ;
//   3. le contact reel d'un trace (pixels.py contact) : capture normale + capture ?masque=<selecteur CSS>,
//      pour un tres grand texte que mesures.js signale en « chevauche » sur sa seule boite.
// Usage : copier a cote de la planche, ajouter en fin de <body>, APRES mesures.js :
//   <script src="mesures.js"></script><script src="releve.js"></script>
// Releve : chrome --headless=new --user-data-dir=<tmp> --virtual-time-budget=8000 --dump-dom "file:///<planche>.html"
//          puis : python3 pixels.py extraire <dom.html> releve > releve.json
// Masque : meme URL plus ?masque=textes (tout texte non decoratif transparent) ou ?masque=<selecteur> (ex. .chiffre-geant),
//          rendue par --screenshot ; le selecteur masque l'element, ses enfants, son texte, son fill et son stroke.
// Avec ?largeur=360 (mesures.js), le releve attend que mesures.js ait retreci les cadres.
// Ne voit pas : le texte dans une image ou un canvas ; un texte rendu par ::before / ::after ; un chiffre
// dessine en traces (segments SVG, paths) : ceux-la se relisent a l'oeil contre le brief.
addEventListener('load', async () => {
  await document.fonts.ready;
  const q = new URLSearchParams(location.search);
  const masque = q.get('masque');
  // Si mesures.js est la, attendre son JSON : la mise en page a 360 px est alors faite.
  if (document.querySelector('script[src$="mesures.js"]')) {
    for (let i = 0; i < 100 && !document.getElementById('mesures'); i++) await new Promise(r => setTimeout(r, 50));
  }
  const mesure = document.createElement('canvas').getContext('2d');
  // Un selecteur invalide leverait une exception dans chaque appel de closest, sans <pre> de sortie :
  // on le valide une fois et l'erreur part dans le <pre id="releve">, que pixels.py extraire lit.
  if (masque && masque !== 'textes') {
    try { document.querySelector(masque); } catch (err) {
      const pre = document.createElement('pre');
      pre.id = 'releve'; pre.hidden = true;
      pre.textContent = JSON.stringify({ erreur: 'selecteur ?masque= invalide : ' + masque + ' (' + err.message + ')' });
      document.body.appendChild(pre);
      return;
    }
  }
  const dansMasque = el => !!(masque && masque !== 'textes' && el.closest(masque));
  const out = [];
  document.querySelectorAll('[data-ecran]').forEach(ecran => {
    const E = ecran.getBoundingClientRect();
    ecran.querySelectorAll('*').forEach(el => {
      const champ = el.matches('input:not([type=hidden]),textarea');
      const noeuds = [...el.childNodes].filter(n => n.nodeType === 3 && n.textContent.trim());
      if (!champ && !noeuds.length) return;
      const s = getComputedStyle(el);
      if (s.visibility === 'hidden' || s.display === 'none') return;
      const svg = el instanceof SVGElement;
      let r;
      if (champ) {
        // Valeur d'un champ : pas de Range possible ; boite tiree de la mesure du texte dans sa police.
        if (!el.value.trim()) return;
        const b = el.getBoundingClientRect();
        mesure.font = s.font;
        const m = mesure.measureText(el.value), w = Math.min(m.width, b.width);
        const h = m.actualBoundingBoxAscent + m.actualBoundingBoxDescent;
        const pl = parseFloat(s.paddingLeft) + parseFloat(s.borderLeftWidth), pr = parseFloat(s.paddingRight) + parseFloat(s.borderRightWidth);
        const x = s.textAlign === 'center' ? b.x + b.width / 2 - w / 2 : /right|end/.test(s.textAlign) ? b.right - pr - w : b.x + pl;
        r = { left: x, top: b.y + b.height / 2 - h / 2, right: x + w, bottom: b.y + b.height / 2 + h / 2 };
      } else {
        const rects = noeuds.flatMap(n => { const g = document.createRange(); g.selectNodeContents(n); return [...g.getClientRects()]; });
        if (!rects.length) return;
        r = { left: Math.min(...rects.map(x => x.left)), top: Math.min(...rects.map(x => x.top)),
              right: Math.max(...rects.map(x => x.right)), bottom: Math.max(...rects.map(x => x.bottom)) };
      }
      // Rogne au cadre : ce qui depasse est le travail de mesures.js (horsCadre).
      r = { left: Math.max(r.left, E.left), top: Math.max(r.top, E.top), right: Math.min(r.right, E.right), bottom: Math.min(r.bottom, E.bottom) };
      if (r.right - r.left < 1 || r.bottom - r.top < 1) return;
      const classe = typeof el.className === 'string' ? el.className : (el.className && el.className.baseVal) || '';
      out.push({
        ecran: ecran.dataset.ecran,
        nom: el.tagName.toLowerCase() + (classe ? '.' + classe.split(' ')[0] : ''),
        texte: champ ? el.value : noeuds.map(n => n.textContent.trim()).join(' '),
        couleur: svg ? s.fill : s.color,
        taille: parseFloat(s.fontSize),
        graisse: +s.fontWeight,
        decoratif: !!el.closest('[aria-hidden="true"]'),
        masque: dansMasque(el),
        boite: [r.left + scrollX, r.top + scrollY, r.right - r.left, r.bottom - r.top].map(v => +v.toFixed(1)),
      });
    });
  });
  if (masque) {
    const st = document.createElement('style');
    st.textContent = masque === 'textes'
      // Les textes decoratifs (aria-hidden) restent : ils font partie du fond, comme dans mesures.js.
      ? '[data-ecran] :not([aria-hidden="true"],[aria-hidden="true"] *){color:transparent!important;-webkit-text-fill-color:transparent!important;text-decoration-color:transparent!important;text-shadow:none!important;caret-color:transparent!important}[data-ecran] svg text:not([aria-hidden="true"],[aria-hidden="true"] *){fill:transparent!important;stroke:transparent!important}'
      : `${masque},${masque} *{color:transparent!important;-webkit-text-fill-color:transparent!important;fill:transparent!important;stroke:transparent!important;text-shadow:none!important;background:transparent!important;border-color:transparent!important;box-shadow:none!important}`;
    document.head.appendChild(st);
  }
  const pre = document.createElement('pre');
  pre.id = 'releve';
  pre.hidden = true;
  pre.textContent = JSON.stringify(out);
  document.body.appendChild(pre);
});
