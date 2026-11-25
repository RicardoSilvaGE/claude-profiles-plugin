#!/usr/bin/env bash
# ==============================================================================================
# check-build-ts.sh — hook Stop d'un profil empaquete en plugin.
#
# CE QU'IL FAIT, ET POURQUOI IL EXISTE.
# La regle absolue spec-builder a trois etages, et le premier — « < 10 lignes : aucune spec » —
# repose sur un filet MECANIQUE : « le filet est check-build-ts.ps1 (Stop), pas une spec ». Ce
# hook compile TypeScript (tsc --noEmit) quand la session a laisse des .ts/.tsx modifies, et
# bloque la fin de tour avec la liste des erreurs. DEPUIS LE 05.09.2026 (audit D4 : sept depots
# reels sur huit n'ont pas de tsconfig.json, donc n'avaient AUCUN filet), un depot sans
# tsconfig.json est couvert aussi : script build/check/lint de package.json si node_modules/
# existe, sinon node --check sur les .js/.mjs/.cjs touches, et la syntaxe Python des .py touches.
# Cadrage : docs/SPEC-lite-check-build-hors-ts.md. C'est le controle qui aurait attrape
# l'accolade orpheline du 19.05.2026, incident fondateur de la regle : la mitigation posee ce
# jour-la etait DOCTRINALE (« passer par une spec ») la ou elle devait etre MECANIQUE (« le code
# compile-t-il ? »). Il ne remplace pas la revue : il rend impossible de terminer une session sur
# un projet TypeScript casse sans en avoir ete averti.
#
# Comme guard-spec-code.ps1, le hook du poste est declare dans le settings-fragment.json du
# profil, que build-plugin.sh ne copie pas. Apres le portage du garde PreToolUse, le plugin
# opposait les etages 2 et 3 ; plus rien ne couvrait le premier. Ce fichier ferme la boucle.
#
# CONTRAIREMENT A guard-spec-code.sh, IL FAIT LE MEME EFFET EN CLOUD QU'AU POSTE. Un
# `decision: block` sur Stop n'est pas une decision de permission : la documentation Claude Code
# (hooks.md, « Stop decision control ») ne le soumet a aucun permission_mode. Il empeche la fin
# de tour et remet le `reason` au modele, en `default` comme en `bypassPermissions`.
#
# DECLENCHEMENT (les quatre conditions, sinon exit 0 silencieux) :
#   1. Le dossier de travail est un depot git (un .git A SA RACINE — pas de remontee, comme le
#      hook PowerShell ; le Stop se joue sur le cwd de la session, pas sur un fichier).
#   2. Avec un tsconfig.json a sa racine : branche TypeScript (conditions 3 et 4). Sans : branche
#      « hors TypeScript », declenchee par un .js/.mjs/.cjs/.jsx ou un .py modifie ou ajoute
#      (hors node_modules/, dist/, build/, vendor/, .min.js).
#   3. git status signale au moins un .ts/.tsx/.mts/.cts modifie ou ajoute (hors .d.ts).
#      --untracked-files=all est OBLIGATOIRE : sans lui, git regroupe un dossier entierement non
#      suivi en une seule ligne (« ?? src/ ») et un dossier de composants cree pendant la session
#      devient invisible du hook. Constate au banc du 17.08.2026 sur le poste.
#   4. Un compilateur tsc est joignable : node_modules/.bin/tsc du depot en priorite (sa version
#      fait foi), sinon le tsc du PATH. Jamais npx : sans --no-install il peut telecharger, avec
#      il n'apporte rien de plus.
#
# TESTS LIES, BOUCLE DE VERIFICATION (25.11.2026, docs/SPEC-boucle-tests-fin-de-tour.md) :
#   build vert (ou non verifiable), le hook lance les SEULS tests lies aux sources modifiees :
#   vitest (`vitest related <sources> --run --passWithNoTests`, si scripts.test cite vitest et que
#   node_modules/.bin/vitest existe), node:test (`node --test` sur les fichiers de test dont le nom
#   reprend celui d'une source touchee, si scripts.test commence par `node --test`), pytest (memes
#   regles de nom : test_<module>.py, <module>_test.py ; si pytest.ini, [tool.pytest dans
#   pyproject.toml ou conftest.py a la racine). Jamais la suite entiere : un depot de 2500 tests ne
#   se rejoue pas a chaque fin de tour. Timeout dur 120 s, au-dela silence. Ne bloque que sur une
#   ligne d'echec reconnue (FAIL, not ok, FAILED, AssertionError...). Lancer des tests EXECUTE le
#   code du depot, comme `npm run build` deja : CLAUDE_CHECK_TESTS=0 coupe cette etape seule.
#
# GARANTIES ANTI-BOUCLE :
#   - au plus TROIS blocages par tour (build ou tests), compteur tours-<session>-<cle>.n. Le
#     plafond du harness (8 continuations) ne suffit pas : « The count [...] resets each time Claude
#     calls a tool », et une correction appelle des outils. stop_hook_active = false (premier stop
#     d'un tour) remet le compteur a 0 ; true le lit. Mesure du 25.11.2026 (Claude Code 2.1.332) :
#     stop_hook_active reste true sur trois continuations successives, outil appele entre deux.
#     Jusqu'au 25.11.2026, true valait silence : la correction n'etait jamais recontrolee.
#   - marqueur build-<session>-<cle>-<etat>.flag, pose AVANT la compilation : un meme etat des
#     sources touchees ne se recompile pas (un echec ne se rejoue pas a chaque stop), un etat
#     change se recompile. Jusqu'au 28.10.2026 le marqueur ne dependait que de la session : un
#     build vert au premier stop rendait muette toute retouche ulterieure (audit dev-fullstack
#     du 27.10.2026, AC-01).
#
# COUT : tsc --noEmit prend 5 a 30 s sur un projet moyen. Seulement si des .ts ont bouge, et
# seulement si les sources touchees ont change depuis le dernier passage. Timeout dur a 90 s pour
# le build, 120 s pour les tests ; au-dela on abandonne en silence plutot que de faire attendre.
# Le timeout declare dans hooks.json (240 s) doit rester SUPERIEUR a leur somme, sinon le harness
# tue le hook avant qu'il ne rende son verdict. L'attente est une boucle `sleep 1` +
# `kill` : une seule voie, POSIX, sans dependre de coreutils — une voie unique est une voie
# testee, deux voies dont l'une ne tourne jamais au banc n'en sont pas.
#
# CE QU'IL NE DIT PAS : si le depot etait DEJA casse avant la session, le hook le signale quand
# meme. Il rapporte l'ETAT, il n'attribue pas la faute — et le message le dit, pour qu'un
# heritage ne soit pas lu comme une regression de la session.
#
# FAIL-OPEN PAR CONSTRUCTION : jq absent, payload vide ou invalide, cwd introuvable, marqueur non
# ecrivable, tsc introuvable, timeout — le hook se tait et sort en 0. Et si tsc rend un code non
# nul SANS aucune ligne `error TSxxxx`, il se tait aussi : ce n'est pas un build casse, c'est
# autre chose, et l'inventer serait pire. Meme regle hors TypeScript : node --check et Python ne
# bloquent que sur une ligne `SyntaxError` ; npm run ne bloque pas si sa sortie dit `: not found`
# (outil absent, pas code casse). Un .js dont la seule erreur est « Unexpected token
# '<' » est du JSX charge par Babel in-browser, le montage reel de plusieurs depots vanilla :
# ignore, plutot qu'un faux positif a chaque fin de tour. Le JSX d'un .js ou d'un .html n'est
# donc PAS couvert, et c'est ecrit. CLAUDE_CHECK_BUILD_TS=0 desactive le hook.
# ==============================================================================================
set -uo pipefail

[ "${CLAUDE_CHECK_BUILD_TS:-1}" = "0" ] && exit 0

command -v jq >/dev/null 2>&1 || { echo "check-build-ts: jq absent, filet non pose" >&2; exit 0; }

RAW="$(cat)"
[ -n "$RAW" ] || exit 0
printf '%s' "$RAW" | jq -e . >/dev/null 2>&1 || exit 0

lire() { printf '%s' "$RAW" | jq -r "$1 // empty" 2>/dev/null; }
tracer() { [ -n "${CLAUDE_HOOK_TRACE:-}" ] && printf 'check-build-ts : %s\n' "$1" >> "$CLAUDE_HOOK_TRACE" 2>/dev/null; return 0; }

# ---- 1. Anti-boucle : lu ici, applique au compteur de tours (6) ---------------------------------
ACTIF="$(lire '.stop_hook_active')"
MAX_TOURS=3

# ---- 2. Dossier de travail ---------------------------------------------------------------------
CWD="$(lire '.cwd')"; [ -n "$CWD" ] || CWD="$PWD"
[ -d "$CWD" ] || exit 0

# ---- 2bis. Compteur de tours, AVANT tout autre filtre : le premier stop d'un tour le remet a 0
#      meme quand le hook se tait ensuite, sinon un compteur epuise au tour precedent survivrait.
SID="$(lire '.session_id')"; [ -n "$SID" ] || SID="nosession"
SID="$(printf '%s' "$SID" | tr -c 'A-Za-z0-9_.-' '_' | cut -c1-64)"
if command -v cksum >/dev/null 2>&1; then
    CLE="$(printf '%s' "$CWD" | cksum | tr -cd '0-9')"
elif command -v md5sum >/dev/null 2>&1; then
    CLE="$(printf '%s' "$CWD" | md5sum | cut -d' ' -f1)"
else
    CLE="$(printf '%s' "$CWD" | tr -c 'A-Za-z0-9_.-' '_' | cut -c1-64)"
fi
[ -n "$CLE" ] || CLE="nokey"
DIR_MARQ="${TMPDIR:-/tmp}/claude-guard"
mkdir -p "$DIR_MARQ" 2>/dev/null || exit 0
FICHIER_TOURS="$DIR_MARQ/tours-$SID-$CLE.n"
TOURS=0
if [ "$ACTIF" = "true" ]; then
    TOURS="$(cat "$FICHIER_TOURS" 2>/dev/null | tr -cd '0-9')"; [ -n "$TOURS" ] || TOURS=0
    [ "$TOURS" -ge "$MAX_TOURS" ] && exit 0
else
    rm -f "$FICHIER_TOURS" 2>/dev/null
fi

# emettre <message> : decision block, numero du tour, compteur incremente.
emettre() {
    local n=$((TOURS + 1)) suite
    suite="Boucle de verification : tour $n sur $MAX_TOURS."
    [ "$n" -ge "$MAX_TOURS" ] && suite="$suite
Dernier tour : si c'est encore rouge, rends la main a l'utilisateur en disant ce qui reste."
    printf '%s\n' "$n" > "$FICHIER_TOURS" 2>/dev/null
    jq -n --arg r "$1

$suite" '{ decision: "block", reason: $r }'
}

# ---- 3 et 4. Depot git ; avec ou sans tsconfig.json -----------------------------------------------
[ -e "$CWD/.git" ] || exit 0
if [ -f "$CWD/tsconfig.json" ]; then BRANCHE=ts; else BRANCHE=autre; fi

# ---- 5. Des sources ont-elles bouge ? ---------------------------------------------------------------
# Lecture NUL : git ne cite alors jamais un nom (espace, accent), et un renommage donne sa destination puis son
# ancien nom, a sauter. Sortie : lignes "XY chemin", comme le format porcelain d'origine. Un git en echec laisse
# STATUT vide, donc sortie 0 plus bas.
statut_z() {
    local entree code
    while IFS= read -r -d '' entree; do
        code="${entree:0:2}"
        case "$code" in R?|?R|C?|?C) IFS= read -r -d '' _ ;; esac
        printf '%s\n' "$entree"
    done < <(git -C "$CWD" status --porcelain -z --untracked-files=all 2>/dev/null)
}
STATUT="$(statut_z)"
[ -n "$STATUT" ] || exit 0
# Chemins des lignes de statut (hors suppressions ; un renommage garde sa destination).
CHEMINS="$(printf '%s\n' "$STATUT" | grep -Ev '^ ?D' | sed -E 's/^.. //' \
    | grep -Ev '(^|/)(node_modules|dist|build|vendor)/' | grep -Eiv '\.min\.js$')"
if [ "$BRANCHE" = ts ]; then
    TOUCHES="$(printf '%s\n' "$STATUT" | grep -Ei '\.(ts|tsx|mts|cts)$' | grep -Eiv '\.d\.ts$')"
    [ -n "$TOUCHES" ] || exit 0
    NB_TOUCHES="$(printf '%s\n' "$TOUCHES" | grep -c .)"
else
    TOUCHES_JS="$(printf '%s\n' "$CHEMINS" | grep -Ei '\.(js|mjs|cjs|jsx)$')"
    TOUCHES_PY="$(printf '%s\n' "$CHEMINS" | grep -Ei '\.py$')"
    [ -n "$TOUCHES_JS$TOUCHES_PY" ] || exit 0
fi

# ---- 6. Marqueur AVANT la compilation (SID, CLE, DIR_MARQ : 2bis) ------------------------------
# Etat des sources touchees : chemin + empreinte git du contenu (statut compris en TypeScript, pour
# qu'une suppression change l'etat). Sans outil d'empreinte, etat constant : retour au marqueur de
# session, plutot que de recompiler a chaque stop.
if [ "$BRANCHE" = ts ]; then
    FICHIERS_ETAT="$(printf '%s\n' "$TOUCHES" | sed -E 's/^.. //')"
    ENTETE_ETAT="$TOUCHES"
else
    FICHIERS_ETAT="$(printf '%s\n%s\n' "$TOUCHES_JS" "$TOUCHES_PY" | grep .)"
    ENTETE_ETAT=""
fi
etat_brut() {
    printf '%s\n' "$ENTETE_ETAT" | LC_ALL=C sort
    printf '%s\n' "$FICHIERS_ETAT" | LC_ALL=C sort | while IFS= read -r p; do
        [ -n "$p" ] || continue
        printf '%s|' "$p"
        [ -f "$CWD/$p" ] && git -C "$CWD" hash-object -- "$p" 2>/dev/null
        echo
    done
}
if command -v cksum >/dev/null 2>&1; then
    ETAT="$(etat_brut | cksum | tr -cd '0-9')"
elif command -v md5sum >/dev/null 2>&1; then
    ETAT="$(etat_brut | md5sum | cut -d' ' -f1)"
fi
[ -n "${ETAT:-}" ] || ETAT="x"

MARQ="$DIR_MARQ/build-$SID-$CLE-$ETAT.flag"
[ -f "$MARQ" ] && exit 0
# Un seul marqueur par session et par depot : l'etat precedent n'a plus a etre retenu.
rm -f "$DIR_MARQ/build-$SID-$CLE-"*.flag 2>/dev/null
: > "$MARQ" 2>/dev/null || exit 0

# ---- 6bis. Branche HORS TYPESCRIPT (05.09.2026) -------------------------------------------------------
# CODE DU DEPOT (audit du 10.11.2026, constat H1 securite). Ce hook tourne chez des tiers, sur
# des depots qu'ils n'ont pas forcement ecrits. Un node_modules/ SUIVI par git n'a pas ete installe
# par l'utilisateur : son .bin/tsc et les scripts de package.json sont alors du code du depot, que
# le hook ne lance pas (repli : tsc du PATH, node --check). Le CONTROLE DE SYNTAXE Python tourne en
# mode isole (-I) : sans lui, `python -c` met le dossier courant en tete de sys.path, et un ast.py
# pose a la racine du depot etait importe et execute a la place du module standard. L'etape TESTS
# (12) lance pytest SANS -I, a dessein : -I masquerait un pytest installe dans le site utilisateur,
# et lancer des tests execute de toute facon le code du depot (conftest.py, tests). Un pytest.py
# pose a la racine n'ajoute donc aucun pouvoir ; CLAUDE_CHECK_TESTS=0 coupe l'etape. -B : aucun
# __pycache__/ ecrit dans le depot.
NM_SUIVI=0
[ -n "$(git -C "$CWD" ls-files -- node_modules 2>/dev/null | head -n 1)" ] && NM_SUIVI=1

# Trois verifications, dans cet ordre, toutes en fail-open. Un seul rapport, qui les cumule.
attendre() { # attendre <pid> [limite s, 90] : boucle sleep 1 + kill, une seule voie, POSIX. Rend 124 si tue.
    local pid="$1" limite="${2:-90}" i=0
    while kill -0 "$pid" 2>/dev/null && [ "$i" -lt "$limite" ]; do sleep 1; i=$((i + 1)); done
    if kill -0 "$pid" 2>/dev/null; then
        # Un lanceur de tests cree des processus enfants (pools de vitest) : les tuer aussi. TERM
        # d'abord, 3 s de grace, puis KILL : un processus qui ignore TERM (arret propre d'un serveur
        # teste) laissait le `wait` sans borne, jusqu'a ce que le harness coupe le hook sans verdict.
        command -v pkill >/dev/null 2>&1 && pkill -TERM -P "$pid" 2>/dev/null
        kill "$pid" 2>/dev/null
        i=0; while kill -0 "$pid" 2>/dev/null && [ "$i" -lt 3 ]; do sleep 1; i=$((i + 1)); done
        if kill -0 "$pid" 2>/dev/null; then
            command -v pkill >/dev/null 2>&1 && pkill -KILL -P "$pid" 2>/dev/null
            kill -KILL "$pid" 2>/dev/null
        fi
        wait "$pid" 2>/dev/null; return 124
    fi
    wait "$pid"
}
if [ "$BRANCHE" = autre ]; then
    RAPPORT=""; OUTILS=""
    # (a) npm run <build|check|lint> : seulement si package.json le declare, que node_modules/ existe
    #     (sinon c'est un clone frais, pas un depot casse) et que npm est joignable.
    SCRIPT=""
    if [ -n "$TOUCHES_JS" ] && [ -f "$CWD/package.json" ] && [ -d "$CWD/node_modules" ] && [ "$NM_SUIVI" -eq 0 ] && command -v npm >/dev/null 2>&1; then
        for s in build check lint; do
            if [ -n "$(jq -r --arg s "$s" '.scripts[$s] // empty' "$CWD/package.json" 2>/dev/null)" ]; then SCRIPT="$s"; break; fi
        done
    fi
    if [ -n "$SCRIPT" ]; then
        OUT="$DIR_MARQ/npm-$CLE.out"
        (cd "$CWD" && exec npm run --silent "$SCRIPT") > "$OUT" 2>&1 &
        attendre $!; CODE=$?
        if [ "$CODE" -ne 0 ] && [ "$CODE" -ne 124 ] && ! grep -Eqi '(: |command )not found' "$OUT" 2>/dev/null; then
            RAPPORT="$RAPPORT$(tail -n 12 "$OUT" 2>/dev/null)
"
            OUTILS="$OUTILS  npm run $SCRIPT : code $CODE
"
        fi
    elif [ -n "$TOUCHES_JS" ] && command -v node >/dev/null 2>&1; then
        # (b) node --check, fichier par fichier ; jamais un .jsx (extension refusee par node).
        NB_JS=0; ERR_JS=""
        while IFS= read -r f; do
            [ -n "$f" ] || continue
            case "$f" in *.jsx|*.JSX) continue ;; esac
            [ -f "$CWD/$f" ] || continue
            NB_JS=$((NB_JS + 1))
            SORTIE="$(cd "$CWD" && node --check "$f" 2>&1)"
            [ $? -eq 0 ] && continue
            LIGNE="$(printf '%s\n' "$SORTIE" | grep -m1 'SyntaxError')"
            [ -n "$LIGNE" ] || continue
            # JSX dans un .js (Babel in-browser) : hors perimetre de node --check, pas une erreur du code.
            case "$LIGNE" in *"Unexpected token '<'"*) continue ;; esac
            NUM="$(printf '%s\n' "$SORTIE" | grep -m1 -E "^.*$(printf '%s' "$f" | sed 's/[.[\*^$/]/\\&/g'):[0-9]+" | sed -E 's/.*:([0-9]+)$/\1/')"
            ERR_JS="$ERR_JS$f:${NUM:-?}: $LIGNE
"
        done <<EOF_JS
$TOUCHES_JS
EOF_JS
        if [ -n "$ERR_JS" ]; then RAPPORT="$RAPPORT$ERR_JS"; OUTILS="$OUTILS  node --check : $NB_JS fichier(s) lu(s)
"; fi
    fi
    # (c) Python : ast.parse, jamais py_compile (qui ecrirait un __pycache__/ dans le depot).
    PY=""
    if command -v python3 >/dev/null 2>&1; then PY=python3; elif command -v python >/dev/null 2>&1; then PY=python; fi
    if [ -n "$TOUCHES_PY" ] && [ -n "$PY" ]; then
        ERR_PY="$(cd "$CWD" && printf '%s\n' "$TOUCHES_PY" | "$PY" -I -c '
import ast, sys
for p in [l.strip() for l in sys.stdin if l.strip()]:
    try:
        ast.parse(open(p, "rb").read(), p)
    except SyntaxError as e:
        print("%s:%s: SyntaxError: %s" % (p, e.lineno, e.msg))
    except OSError:
        pass
' 2>/dev/null)"
        if [ -n "$ERR_PY" ]; then RAPPORT="$RAPPORT$ERR_PY
"; OUTILS="$OUTILS  python (ast.parse) : $(printf '%s\n' "$TOUCHES_PY" | grep -c .) fichier(s) lu(s)
"; fi
    fi
    if [ -n "$RAPPORT" ]; then
        NB="$(printf '%s' "$RAPPORT" | grep -c .)"
        EXTRAIT="$(printf '%s' "$RAPPORT" | head -12)"
        RESTE=$((NB - 12)); [ "$RESTE" -lt 0 ] && RESTE=0
        SUITE=""; [ "$RESTE" -gt 0 ] && SUITE="... et $RESTE autre(s) ligne(s).
"
        MSG="BUILD CASSE (hook du profil, depot sans tsconfig.json).

  Depot   : $(basename "$CWD")
  Verifications faites :
$OUTILS
-------- premieres lignes --------
$EXTRAIT
$SUITE----------------------------------

C'est le filet du premier etage de la regle spec-builder (< 10 lignes : pas de spec, mais le
code doit passer) — celui qui aurait attrape l'accolade orpheline du 19.05.2026, et qui n'existait
jusqu'ici que sur les depots TypeScript. Il ne lit pas le JSX d'un .js ou d'un .html.

Attention a l'attribution : le hook rapporte l'ETAT du depot, pas la faute. Si ces erreurs
preexistaient a la session, le dire plutot que de les corriger en passant.

Sorties : corriger, ou constater que l'erreur est heritee et l'annoncer en une ligne.
Ce rapport ne revient que si les sources touchees changent."
        emettre "$MSG"
        exit 0
    fi
fi

# ---- 7 a 11. Branche TYPESCRIPT. Un build vert, ou non verifiable (tsc absent, trop long, echec
#      sans ligne `error TS`), passe a l'etape 12 : les tests. -------------------------------------
if [ "$BRANCHE" = ts ]; then
    # 7. Trouver tsc. Le binaire local du projet prime : c'est sa version qui fait foi. Sauf s'il
    #    est SUIVI par git : c'est alors du code du depot, pas un outillage installe (NM_SUIVI).
    TSC=""
    if [ "$NM_SUIVI" -eq 0 ] && [ -x "$CWD/node_modules/.bin/tsc" ]; then
        TSC="$CWD/node_modules/.bin/tsc"
    elif command -v tsc >/dev/null 2>&1; then
        TSC="$(command -v tsc)"
    fi
    if [ -n "$TSC" ]; then
        # 8. Compilation, sortie capturee, timeout dur 90 s (124 : trop long, pas de verdict partiel).
        OUT="$DIR_MARQ/tsc-$CLE.out"
        ERR="$DIR_MARQ/tsc-$CLE.err"
        (cd "$CWD" && exec "$TSC" --noEmit) > "$OUT" 2> "$ERR" &
        attendre $! 90; CODE=$?
        # 9. Ne garder que les vraies erreurs de compilation.
        ERREURS=""
        if [ "$CODE" -ne 0 ] && [ "$CODE" -ne 124 ]; then
            ERREURS="$(cat "$OUT" "$ERR" 2>/dev/null | grep -E 'error TS[0-9]+')"
        fi
        if [ -n "$ERREURS" ]; then
            NB="$(printf '%s\n' "$ERREURS" | grep -c .)"
            EXTRAIT="$(printf '%s\n' "$ERREURS" | head -12)"
            RESTE=$((NB - 12)); [ "$RESTE" -lt 0 ] && RESTE=0
            # 10. Message.
            SUITE=""
            [ "$RESTE" -gt 0 ] && SUITE="... et $RESTE autre(s).
"
            MSG="BUILD TYPESCRIPT CASSE (hook du profil).

  Depot   : $(basename "$CWD")
  Erreurs : $NB  (tsc --noEmit)
  Sources TypeScript modifiees dans cette session : $NB_TOUCHES

-------- premieres erreurs --------
$EXTRAIT
$SUITE-----------------------------------

C'est le controle qui aurait attrape l'accolade orpheline du 19.05.2026 : build de production
casse par un cleanup en aveugle, detecte par des mails d'erreur GitHub et Vercel plutot que sur
le poste.

Attention a l'attribution : le hook rapporte l'ETAT du depot, pas la faute. Si ces erreurs
preexistaient a la session, le dire plutot que de les corriger en passant.

Sorties : corriger, ou constater que l'erreur est heritee et l'annoncer en une ligne.
Ce rapport ne revient que si les sources touchees changent."
            # 11. Sortie : decision et reason A LA RACINE, format documente pour Stop.
            emettre "$MSG"
            exit 0
        fi
    fi
fi

# ---- 12. TESTS LIES (25.11.2026, docs/SPEC-boucle-tests-fin-de-tour.md) ---------------------------
# Atteint seulement quand le build n'a rien a dire. Trois lanceurs, dans cet ordre, et aucun autre.
[ "${CLAUDE_CHECK_TESTS:-1}" = "0" ] && exit 0
SOURCES_JS="$(printf '%s\n' "$CHEMINS" | grep -Ei '\.(ts|tsx|mts|cts|js|jsx|mjs|cjs)$' | grep -Eiv '\.d\.ts$')"
SOURCES_PY="$(printf '%s\n' "$CHEMINS" | grep -Ei '\.py$')"
SCRIPT_TEST=""
[ -f "$CWD/package.json" ] && SCRIPT_TEST="$(jq -r '.scripts.test // empty' "$CWD/package.json" 2>/dev/null)"

# Fichiers du depot (suivis et nouveaux non ignores), noms non cites grace a -z.
fichiers_depot() {
    git -C "$CWD" ls-files -z --cached --others --exclude-standard 2>/dev/null | tr '\0' '\n' \
        | grep -Ev '(^|/)(node_modules|dist|build|vendor|\.venv|venv)/'
}
# tests_lies <js|py> <sources> : fichiers de test touches, et ceux dont le nom reprend le nom de base
# d'une source touchee (calc.mjs -> calc.test.mjs, calc-bornes.test.mjs ; calc.py -> test_calc.py).
tests_lies() {
    local mode="$1" motif
    if [ "$mode" = js ]; then motif='\.(test|spec)\.(js|mjs|cjs)$'; else motif='(^|/)(test_[^/]*|[^/]*_test)\.py$'; fi
    printf '%s\n' "$2" | grep . > "$DIR_MARQ/sources-$CLE.lst"
    fichiers_depot | grep -E "$motif" > "$DIR_MARQ/candidats-$CLE.lst"
    [ -s "$DIR_MARQ/sources-$CLE.lst" ] && [ -s "$DIR_MARQ/candidats-$CLE.lst" ] || return 0
    awk -v mode="$mode" '
        function nom(p) { sub(/.*\//, "", p); return p }
        FNR == NR { touche[$0] = 1; b = nom($0); sub(/\.[^.]*$/, "", b); if (b != "") base[b] = 1; next }
        {
            f = $0
            if (f in touche) { print f; next }
            b = nom(f)
            if (mode == "js") sub(/\.(test|spec)\.(js|mjs|cjs)$/, "", b)
            else if (b ~ /^test_/) { sub(/^test_/, "", b); sub(/\.py$/, "", b) }
            else sub(/_test\.py$/, "", b)
            for (s in base) if (b == s || index(b, s "-") == 1 || index(b, s ".") == 1 || index(b, s "_") == 1) { print f; break }
        }' "$DIR_MARQ/sources-$CLE.lst" "$DIR_MARQ/candidats-$CLE.lst"
}

LANCEUR=""; LISTE=""; PYT=""
if [ -n "$SOURCES_JS" ] && [ "$NM_SUIVI" -eq 0 ] && [ -x "$CWD/node_modules/.bin/vitest" ] \
   && printf '%s' "$SCRIPT_TEST" | grep -q 'vitest'; then
    LANCEUR=vitest; LISTE="$SOURCES_JS"
elif [ -n "$SOURCES_JS" ] && printf '%s' "$SCRIPT_TEST" | grep -Eq '^[[:space:]]*node[[:space:]]+--test' \
   && command -v node >/dev/null 2>&1; then
    LANCEUR=node; LISTE="$(tests_lies js "$SOURCES_JS")"
elif [ -n "$SOURCES_PY" ] && { [ -f "$CWD/pytest.ini" ] || [ -f "$CWD/conftest.py" ] \
   || grep -q '^\[tool\.pytest' "$CWD/pyproject.toml" 2>/dev/null; }; then
    # Un environnement virtuel du depot, non suivi par git, prime : c'est la que pytest est installe.
    for c in "$CWD/.venv/bin/python" "$CWD/.venv/Scripts/python.exe" "$CWD/venv/bin/python"; do
        if [ -x "$c" ] && [ -z "$(git -C "$CWD" ls-files -- "${c#"$CWD"/}" 2>/dev/null | head -n 1)" ]; then PYT="$c"; break; fi
    done
    [ -n "$PYT" ] || { command -v python3 >/dev/null 2>&1 && PYT=python3; } || { command -v python >/dev/null 2>&1 && PYT=python; }
    [ -n "$PYT" ] && { LANCEUR=pytest; LISTE="$(tests_lies py "$SOURCES_PY")"; }
fi
[ -n "$LANCEUR" ] && [ -n "$LISTE" ] || exit 0

ARGS=()
while IFS= read -r f; do [ -n "$f" ] && ARGS+=("$f"); done <<EOF_LISTE
$LISTE
EOF_LISTE
NB_ARGS="${#ARGS[@]}"
[ "$NB_ARGS" -gt 0 ] || exit 0
# Noms des fichiers passes au lanceur, cinq au plus, pour le rapport.
NOMS=""; k=0
for f in "${ARGS[@]}"; do
    [ "$k" -lt 5 ] || { NOMS="$NOMS, ..."; break; }
    if [ -n "$NOMS" ]; then NOMS="$NOMS, $f"; else NOMS="$f"; fi
    k=$((k + 1))
done

SORTIE="$DIR_MARQ/tests-$CLE.out"
case "$LANCEUR" in
    vitest) LIB="vitest related ($NB_ARGS source(s) modifiee(s))"
            (cd "$CWD" && exec "$CWD/node_modules/.bin/vitest" related "${ARGS[@]}" --run --passWithNoTests) > "$SORTIE" 2>&1 </dev/null & ;;
    node)   LIB="node --test ($NB_ARGS fichier(s) de test)"
            (cd "$CWD" && exec node --test --test-reporter=tap "${ARGS[@]}") > "$SORTIE" 2>&1 </dev/null & ;;
    pytest) LIB="pytest ($NB_ARGS fichier(s) de test)"
            (cd "$CWD" && exec "$PYT" -B -m pytest -q -x -p no:cacheprovider "${ARGS[@]}") > "$SORTIE" 2>&1 </dev/null & ;;
esac
attendre $! 120; CODE=$?
if [ "$CODE" -eq 124 ]; then tracer "tests $LANCEUR : plus de 120 s, abandon sans verdict"; exit 0; fi
[ "$CODE" -eq 0 ] && exit 0
# pytest : 5 = aucun test collecte, pas un echec.
[ "$LANCEUR" = pytest ] && [ "$CODE" -eq 5 ] && exit 0

# Lignes d'echec reconnues seulement (couleurs retirees) ; aucune => autre panne, silence.
case "$LANCEUR" in
    vitest) MOTIF='(^|[[:space:]])FAIL[[:space:]]|AssertionError|[A-Za-z]*Error:' ;;
    node)   MOTIF='^[[:space:]]*not ok|AssertionError|^[[:space:]]+(error|expected|actual):' ;;
    pytest) MOTIF='^(FAILED|ERROR)[[:space:]]|^E[[:space:]]' ;;
esac
ECHECS="$(sed 's/\x1b\[[0-9;]*m//g' "$SORTIE" 2>/dev/null | grep -E "$MOTIF")"
if [ -z "$ECHECS" ]; then tracer "tests $LANCEUR : code $CODE sans ligne d'echec reconnue"; exit 0; fi
NB="$(printf '%s\n' "$ECHECS" | grep -c .)"
EXTRAIT="$(printf '%s\n' "$ECHECS" | head -12)"
RESTE=$((NB - 12)); [ "$RESTE" -lt 0 ] && RESTE=0
SUITE=""; [ "$RESTE" -gt 0 ] && SUITE="... et $RESTE autre(s) ligne(s).
"
MSG="TESTS ROUGES (hook du profil).

  Depot   : $(basename "$CWD")
  Lance   : $LIB, code $CODE
  Fichiers : $NOMS
  Seuls les tests lies aux sources modifiees ont tourne, pas la suite entiere.

-------- premieres lignes --------
$EXTRAIT
$SUITE----------------------------------

Le code compile, mais des tests lies aux fichiers modifies echouent.

Attention a l'attribution : le hook rapporte l'ETAT du depot, pas la faute. Si ces echecs
preexistaient a la session, le dire en une ligne sans les corriger au passage, et ne rien
retoucher : ce rapport ne revient que si les sources touchees changent.

Sorties : corriger, ou constater que l'echec est herite et l'annoncer en une ligne."
emettre "$MSG"
exit 0
