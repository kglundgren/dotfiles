Import-Module PSReadLine

# function OnViModeChange
# {
# 
# }
# 
Set-PSReadLineOption -EditMode Vi -ViModeIndicator Cursor # -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

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
function ep
{
    param(
        # [Parameter(ValueFromPipeline=$true)] $input,
        $prop
    )
    process { $_ | select -ExpandProperty $prop }
}

# Start a pwsh session as admin.
function sudo
{
    start pwsh -args "-noe" -Verb RunAs
}

<# 
.SYNOPSIS
Find files that matches the pattern.

.PARAMETER fileType
The file type to search for. Defaults to '*' (all file types).

.PARAMETER pattern
The regex pattern to match the file name to.

.EXAMPLE
ff '*.cs' | fzf
Finds all csharp files and pipes them to fzf for searching.

.EXAMPLE
ff -pattern 'launchSettings'
Finds all files that has 'launchSettings' in their file name.
#>
function ff
{
    param($fileType='*', $pattern)
    ls -r -fo $fileType | ? { $_.Name -match $pattern } | ep FullName
}

# Source local aliases specific to this machine.
$pwshDir = Join-Path $HOME Documents\PowerShell
$localAliases = Join-Path $pwshDir local_aliases.ps1
if (Test-Path $localAliases) {
    . $localAliases 
}

