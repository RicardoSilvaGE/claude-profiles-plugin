' Lance le serveur en arriere-plan, sans fenetre visible.
' Depose dans le dossier Demarrage de Windows, il releve le serveur a chaque
' ouverture de session.
'
' TROIS POINTS QUI NE SE DEVINENT PAS :
'  1. Le chemin ci-dessous est A RENSEIGNER. Ne jamais y laisser le chemin d'un
'     autre poste : il echouera en silence, sans fenetre pour le dire.
'  2. La redirection vers un journal n'est pas un confort. Sans fenetre, c'est
'     la SEULE trace d'un demarrage rate.
'  3. Le troisieme argument de Run vaut False : on ne veut pas attendre la fin
'     du serveur, qui ne se termine jamais.

Set objShell = CreateObject("WScript.Shell")

' A RENSEIGNER : chemin absolu du dossier de l'application sur CE poste.
appDir = "C:\chemin\vers\le\dossier\de\l\application"

cmd = "cmd /c cd /d """ & appDir & """ && node server.js >> data\server.log 2>&1"
objShell.Run cmd, 0, False
