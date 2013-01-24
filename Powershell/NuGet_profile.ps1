$global:promptTheme = @{
	prefixColor = [ConsoleColor]::Blue
	pathColor = [ConsoleColor]::Blue
	pathBracesColor = [ConsoleColor]::DarkBlue
	hostNameColor = ?: { get-isAdminUser } { [ConsoleColor]::DarkRed } { [ConsoleColor]::DarkGreen }
}

$GitPromptSettings.BeforeForegroundColor = [ConsoleColor]::Gray
$GitPromptSettings.AfterForegroundColor = [ConsoleColor]::Gray
$GitPromptSettings.BranchForegroundColor = [ConsoleColor]::DarkYellow


# Load up the VS Command prompt stuff
$script:vsdir = $dte.FullName | split-path | split-path
invoke-batchfile (join-path $vsdir "Tools\vsvars32.bat")

function Add-ExistingProject([string] $projFile) {
	$dte.Solution.AddFromFile($projFile, $false)
}

function Open-File([string] $path) {
	$dte.ItemOperations.OpenFile( $(resolve-path $path) ) | out-null
}

function Get-SolutionDir {
	$dte.Solution.FullName
}

function Build-Solution {
	$dte.ExecuteCommand("Build.BuildSolution", "")
}

function Clean-Solution {
	$dte.ExecuteCommand("Build.CleanSolution", "")
}
