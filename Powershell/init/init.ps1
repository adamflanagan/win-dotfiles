# Import pscx for New-Junction
Import-Module .\pscx
$psDir = Join-Path (Resolve-Path '~\Documents') 'WindowsPowerShell'
# TODO: check existing $psDir
New-Junction $psDir ..\
New-Symlink ~\Documents\profile.ps1 ..\profile.ps1
# Remove pscx; we'll get an upto date version using PsGet later.
Remove-Module Pscx

(New-Object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
Install-Module Pscx
Install-Module PsUrl
Install-Module posh-git
Install-Module posh-hg
Install-Module posh-svn