<#
.SYNOPSIS
  Genere un certificat HTTPS auto-signe pour une application servie sur le reseau local.

.DESCRIPTION
  POURQUOI CE SCRIPT EXISTE, et c'est la seule chose qui ne se devine pas :
  un service worker ne s'enregistre que dans un CONTEXTE SECURISE - HTTPS, ou
  http://localhost. Tant que le serveur n'est atteint que depuis le poste qui
  l'heberge, le mode hors ligne fonctionne deja sans rien faire. Des qu'un
  telephone y accede par l'IP du reseau local (http://192.168.x.x:PORT), le
  navigateur BLOQUE le service worker faute de contexte securise, et le hors
  ligne cesse d'exister - sans message d'erreur cote application.

  Un certificat auto-signe suffit a lever ce blocage : le navigateur exige un
  contexte securise, pas un certificat approuve par une autorite. Contrepartie
  a annoncer a l'utilisateur, elle n'est pas negociable : chaque appareil devra
  accepter un avertissement de securite au premier acces, et a chaque
  renouvellement du certificat.

  Ecrit key.pem + cert.pem dans data\certs\. Verifier que data\ est exclu par
  le .gitignore du projet AVANT de lancer ce script : une cle privee commitee
  ne se retire pas d'un historique par un simple commit.

.PARAMETER Force
  Ecrase un certificat deja present. Sans ce parametre, le script refuse.

.PARAMETER SousDossier
  Chemin du dossier de certificats, relatif a ce script. Defaut : ..\data\certs

.NOTES
  L'IP est FIGEE au moment de la generation. Changement de reseau ou bail DHCP
  renouvele = certificat invalide, et le hors ligne retombe en panne
  silencieuse. Relancer avec -Force.

  Aucun renouvellement automatique n'est prevu : c'est un choix, pas un oubli.
  Une tache planifiee qui regenere le certificat obligerait chaque appareil a
  re-accepter l'avertissement sans prevenir personne.

  Sorties console volontairement en ASCII pur : ce script n'a pas de BOM, et
  PowerShell 5.1 decode alors un texte accentue en ANSI - les messages
  s'afficheraient corrompus. L'original dont ce fichier est tire avait ce
  defaut.
#>
param(
  [switch]$Force,
  [string]$SousDossier = "..\data\certs"
)

$ErrorActionPreference = "Stop"

# --- Resolution d'openssl -----------------------------------------------------
# Git pour Windows le fournit, mais ne le met pas sur le PATH de PowerShell : le
# chercher uniquement par Get-Command donne un faux "absent" sur un poste qui
# l'a pourtant.
$opensslCandidats = @(
  (Get-Command openssl -ErrorAction SilentlyContinue).Source,
  "$env:ProgramFiles\Git\usr\bin\openssl.exe",
  "$env:ProgramFiles\Git\mingw64\bin\openssl.exe"
) | Where-Object { $_ -and (Test-Path -LiteralPath $_ -PathType Leaf) }

$openssl = $opensslCandidats | Select-Object -First 1
if (-not $openssl) {
  Write-Host "REFUS : openssl introuvable (ni sur le PATH, ni dans l'installation Git standard)." -ForegroundColor Red
  Write-Host "Git pour Windows (https://git-scm.com/download/win) fournit openssl.exe - l'installer suffit." -ForegroundColor Red
  exit 1
}

# --- IP du reseau local -------------------------------------------------------
# Premiere IPv4 non interne. Les interfaces virtuelles (Hyper-V, WSL) sont
# ecartees : un certificat emis pour une IP de vEthernet est valide, et
# parfaitement inutile depuis un telephone.
$ip = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
  Where-Object {
    $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*" -and
    $_.InterfaceAlias -notmatch "Loopback|vEthernet|WSL"
  } |
  Select-Object -First 1 -ExpandProperty IPAddress

if (-not $ip) {
  Write-Host "Aucune IP reseau locale detectee, certificat genere pour 127.0.0.1 uniquement." -ForegroundColor Yellow
  Write-Host "Le hors ligne restera donc indisponible depuis un autre appareil." -ForegroundColor Yellow
  $ip = "127.0.0.1"
}

$certDir  = Join-Path $PSScriptRoot $SousDossier
$certFile = Join-Path $certDir "cert.pem"
$keyFile  = Join-Path $certDir "key.pem"

if ((Test-Path -LiteralPath $certFile) -and -not $Force) {
  Write-Host "REFUS : $certFile existe deja. Relance avec -Force pour le remplacer (ex. si l'IP a change)." -ForegroundColor Red
  exit 1
}

New-Item -ItemType Directory -Force -Path $certDir | Out-Null

& $openssl req -x509 -newkey rsa:2048 -nodes `
  -keyout $keyFile -out $certFile -days 825 `
  -subj "/CN=$ip" `
  -addext "subjectAltName=DNS:localhost,IP:127.0.0.1,IP:$ip"

if ($LASTEXITCODE -ne 0) {
  Write-Host "REFUS : openssl a echoue (code $LASTEXITCODE)." -ForegroundColor Red
  exit 1
}

Write-Host ""
Write-Host "Certificat genere pour localhost / 127.0.0.1 / $ip (valable 825 jours)." -ForegroundColor Green
Write-Host "  $certFile"
Write-Host "  $keyFile"
Write-Host ""
Write-Host "Cote serveur : charger ces deux fichiers s'ils existent, et continuer en HTTP seul sinon." -ForegroundColor Green
Write-Host "Auto-signe : chaque appareil doit accepter l'avertissement de securite au premier acces HTTPS."
