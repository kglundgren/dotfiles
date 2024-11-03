Import-Module PSReadLine

function Prompt {
    $currentLocation = (Get-Location).Path
    $homeDirectory = [System.Environment]::GetFolderPath('UserProfile')

    $displayLocation = $currentLocation -replace "^$([regex]::Escape($homeDirectory))", '~'
    $promptString = "PS " + $displayLocation + ">"

    Write-Host $promptString -NoNewline -ForegroundColor Blue
    return " "
}

function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    }
    else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}

$PSReadLineOptions = @{
    EditMode = 'Vi'
    ViModeIndicator = 'Script'
    ViModeChangeHandler = $Function:OnViModeChange
}
Set-PSReadLineOption @PSReadLineOptions

# Source local aliases specific to this machine.
$pwshDir = Join-Path $HOME Documents/PowerShell
$localAliases = Join-Path $pwshDir local_aliases.ps1
if (Test-Path $localAliases) {
    . $localAliases 
}


<#
.SYNOPSIS
Expands the specified property of objects passed through the pipeline.
It will print only the prop without the header line.

.PARAMETER prop
The name of the property to expand.

.EXAMPLE
Get-Process | ep Name
This example gets the list of processes and expands the 'Name' property, printing only the process names.

.EXAMPLE
ls -r -fo '*.cs' | ep FullName
This example lists all .cs files recursively and prints only the full file names.
#>
function ep {
    param(
        # [Parameter(ValueFromPipeline=$true)] $input,
        $prop
    )
    process { $_ | select -ExpandProperty $prop }
}

# Start a pwsh session as admin.
function sudo {
    start pwsh -args "-noe" -Verb RunAs
}

# Change dir to exe location, or for example 'cdf $profile' to switch to the pwsh profile dir.
function cdf {
    param($exeName)
    cd (split-path (Get-Command $exeName).Source)
}

