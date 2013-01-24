#
# Profile.ps1 - main powershell profile script
# 
# Applies to all hosts, so only put things here that are global
#

# Setup the $home directory correctly
if (-not $global:home) { $global:home = (Resolve-Path ~) }

# A couple of directory variables for convenience
$dotfiles = Resolve-Path C:\Dev\win-dotfiles\
$scripts = Join-Path $dotfiles "Powershell"

# Load in support modules
Import-Module "Azure"
Import-Module "PsGet"
Import-Module "PsUrl"
Import-Module "Pscx" -Arg (join-path $scripts Pscx.UserPreferences.ps1)
Import-Module "Posh-Git"
Import-Module "Posh-Hg"
Import-Module "Posh-Svn"

Enable-GitColors

# VIM
$VIMPATH = "C:\Program Files (x86)\Vim\vim73\vim.exe"

# for editing your PowerShell profile
Function Edit-Profile
{
    vim $profile
}

Function Edit-Hosts
{
    vim C:\Windows\System32\drivers\etc\hosts
}

Function Flush-Dns
{
    ipconfig /flushdns
}

# Vim-style shorten-path originally from Tomas Restrepo
# https://github.com/tomasr
function Get-VimShortPath([string] $path) {
   $loc = $path.Replace($HOME, '~')
	 $loc = $loc.Replace($env:WINDIR, '[Windows]')
   # remove prefix for UNC paths
   $loc = $loc -replace '^[^:]+::', ''
   # make path shorter like tabs in Vim,
   # handle paths starting with \\ and . correctly
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2')
}

# Source: http://paradisj.blogspot.com/2010/03/powershell-how-to-get-script-directory.html       
function Get-ScriptDirectory {   
	if (Test-Path variable:\hostinvocation) {
		$FullPath=$hostinvocation.MyCommand.Path
	}	Else {
		$FullPath=(Get-Variable myinvocation -scope script).value.Mycommand.Definition
	}

	if (Test-Path $FullPath) {
		return (Split-Path $FullPath)
	} Else {
		$FullPath=(Get-Location).path
		Write-Warning ("Get-ScriptDirectory: Powershell Host <" + $Host.name + "> may not be compatible with this function, the current directory <" + $FullPath + "> will be used.")
		return $FullPath
	}
}

function Get-IsAdminUser() {
	$id = [Security.Principal.WindowsIdentity]::GetCurrent()
	$wp = new-object Security.Principal.WindowsPrincipal($id)
	return $wp.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

$global:promptTheme = @{
	prefixColor = [ConsoleColor]::Cyan
	pathColor = [ConsoleColor]::Cyan
	pathBracesColor = [ConsoleColor]::DarkCyan
	hostNameColor = ?: { Get-IsAdminUser } { [ConsoleColor]::Red } { [ConsoleColor]::Green }
}

function Load-NotepadPlusPlus([string]$file) {
	& 'C:\Program Files (x86)\Notepad++\notepad++.exe' $file
}

function prompt {
	$prefix = [char]0x221e + " "
	$hostName = [net.dns]::GetHostName().ToLower()
	$shortPath = get-vimShortPath(get-location)

	Write-Host $prefix -noNewLine -foregroundColor $promptTheme.prefixColor
	Write-Host $hostName -noNewLine -foregroundColor $promptTheme.hostNameColor
	Write-Host ' {' -noNewLine -foregroundColor $promptTheme.pathBracesColor
	Write-Host $shortPath -noNewLine -foregroundColor $promptTheme.pathColor
	Write-Host '}' -noNewLine -foregroundColor $promptTheme.pathBracesColor
	Write-VcsStatus # from posh-git, posh-hg and posh-svn
	return ' '
}

# UNIX friendly environment variables
$env:EDITOR = "gvim"
$env:VISUAL = $env:EDITOR
$env:GIT_EDITOR = $env:EDITOR
$env:TERM = "msys"

# Global aliases
. (Join-Path $scripts "Aliases.ps1")

# Path tweaks
Add-PathVariable $scripts