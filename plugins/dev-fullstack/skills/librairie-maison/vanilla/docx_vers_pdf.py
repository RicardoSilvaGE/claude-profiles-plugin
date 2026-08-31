# -*- coding: utf-8 -*-
"""
Convertit un .docx en .pdf, pour qu'un export PDF reflete exactement la mise en
page reelle du .docx (gabarit du bureau) plutot que le rendu HTML de
"Imprimer / PDF" du navigateur - qui produit une mise en page differente et des
tableaux qui ne correspondent pas.

DEUX MOTEURS, choisis automatiquement selon ce qui est present sur la machine.
Le motif de cet ordre est le seul point qui ne se devine pas :

- LibreOffice headless (`soffice --headless --convert-to pdf`), PREFERE des
  qu'il est trouve. C'est le seul des deux a fonctionner sur un NAS Linux.
- Word par COM, utilise seulement si LibreOffice est absent. Jamais disponible
  sur un NAS ; c'est donc le repli poste Windows, pas l'inverse.

Preferer LibreOffice partout donne le meme rendu des deux cotes, ce qui est
justement le but : un PDF qui change selon la machine qui l'a produit est un
PDF dont on ne peut rien dire.

Usage : python docx_vers_pdf.py <entree.docx> <sortie.pdf>

Depuis un appelant Node ou PowerShell : le timeout de ce script doit rester
SOUS celui de l'appelant, sans quoi c'est l'appelant qui tue le processus et le
message d'erreur utile est perdu.
"""

import os
import shutil
import subprocess
import sys

WD_FORMAT_PDF = 17
SOFFICE_TIMEOUT_S = 90  # a garder sous le timeout du processus appelant


def trouver_soffice():
    chemin = shutil.which("soffice") or shutil.which("soffice.exe")
    if chemin:
        return chemin
    for candidat in (
        r"C:\Program Files\LibreOffice\program\soffice.exe",
        r"C:\Program Files (x86)\LibreOffice\program\soffice.exe",
        "/usr/bin/soffice",
        "/opt/libreoffice/program/soffice",
    ):
        if os.path.isfile(candidat):
            return candidat
    return None


def convertir_libreoffice(chemin_docx, chemin_pdf, soffice_bin):
    dossier_sortie = os.path.dirname(chemin_pdf)
    resultat = subprocess.run(
        [soffice_bin, "--headless", "--norestore", "--convert-to", "pdf",
         "--outdir", dossier_sortie, chemin_docx],
        capture_output=True, text=True, timeout=SOFFICE_TIMEOUT_S,
    )
    if resultat.returncode != 0:
        raise RuntimeError(
            "soffice a echoue (code %s) : %s"
            % (resultat.returncode, resultat.stderr or resultat.stdout)
        )
    # soffice nomme sa sortie d'apres le .docx SOURCE, jamais d'apres le nom de
    # sortie demande : sans ce renommage, le fichier attendu n'existe pas et
    # l'appelant conclut a un echec silencieux.
    genere = os.path.join(
        dossier_sortie,
        os.path.splitext(os.path.basename(chemin_docx))[0] + ".pdf",
    )
    if os.path.abspath(genere) != os.path.abspath(chemin_pdf):
        os.replace(genere, chemin_pdf)


def convertir_word_com(chemin_docx, chemin_pdf):
    try:
        import win32com.client
    except ImportError:
        # Ni soffice ni Word. Cas reel sur un NAS Linux : win32com n'existe que
        # sous Windows. Sans ce garde, ModuleNotFoundError remonte brute au
        # processus appelant, qui n'a aucun moyen de la traduire.
        raise RuntimeError(
            "Aucun moteur de conversion PDF disponible : ni LibreOffice (soffice) "
            "ni Word (win32com, Windows uniquement) ne sont presents sur cette machine."
        )

    word = win32com.client.DispatchEx("Word.Application")
    word.Visible = False
    word.DisplayAlerts = 0
    try:
        doc = word.Documents.Open(chemin_docx, ReadOnly=True)
        try:
            doc.SaveAs2(chemin_pdf, FileFormat=WD_FORMAT_PDF)
        finally:
            doc.Close(SaveChanges=False)
    finally:
        # Liberation en finally des DEUX cotes : un Word laisse ouvert par une
        # exception reste un processus fantome qui verrouille le gabarit.
        word.Quit()


def convertir(chemin_docx, chemin_pdf):
    chemin_docx = os.path.abspath(chemin_docx)
    chemin_pdf = os.path.abspath(chemin_pdf)
    soffice_bin = trouver_soffice()
    if soffice_bin:
        convertir_libreoffice(chemin_docx, chemin_pdf, soffice_bin)
    else:
        convertir_word_com(chemin_docx, chemin_pdf)


def main():
    if len(sys.argv) != 3:
        raise SystemExit("Usage : python docx_vers_pdf.py <entree.docx> <sortie.pdf>")
    convertir(sys.argv[1], sys.argv[2])
    print("OK:" + sys.argv[2])


if __name__ == "__main__":
    main()
