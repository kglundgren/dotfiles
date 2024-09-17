param (
    [string]$Username
)

function Print($Message, $Value, $Color = 'Green') {
    Write-Host $Message -NoNewLine -ForegroundColor $Color
    Write-Host $Value
}

if ($Username -match '^[a-zA-Z0-9]+') {
    Print "Using username: " $Username
}
else {
    return Print "Username is invalid. Can only contain letters and numbers." -Color Red
}

$usersDir = Join-Path C:\Users $Username
if (Test-Path $usersDir -PathType container) {
    Print "Directory found: " $usersDir
}
else {
    return Print "No directory for user '$Username' found in C:\Users" -Color Red
}

$root = $PSScriptRoot # Directory of the script.

$vsvimrc = Join-Path $usersDir .vsvimrc
if (Test-Path $vsvimrc) {
    Print ".vsvimrc is already linked." -Color DarkCyan
}
else {
    New-Item -ItemType SymbolicLink -Path $vsvimrc -Target "$root\src\.vsvimrc"
}

$nvim = Join-Path $usersDir AppData\Local nvim
if (Test-Path $nvim) {
    Print "nvim is already linked." -Color DarkCyan
}
else {
    New-Item -ItemType SymbolicLink -Path $nvim -Target "$root\src\nvim"
}

$alacritty = Join-Path $usersDir AppData\Roaming alacritty 
if (Test-Path $alacritty) {
    Print "alacritty is already linked." -Color DarkCyan
}
else {
    New-Item -ItemType SymbolicLink -Path $alacritty -Target "$root\src\alacritty"
}

$pwsh = Join-Path $usersDir Documents\PowerShell Microsoft.PowerShell_profile.ps1
if (Test-Path $pwsh) {
    Print "pwsh is already linked." -Color DarkCyan
}
else {
    New-Item -ItemType SymbolicLink -Path $pwsh -Target "$root\src\Microsoft.PowerShell_profile.ps1"
}

while ($True) {
    $answer = Read-Host "Delete all symlinks? [y/N]"
    if ($answer -eq 'y') {
        rm $vsvimrc
        rm $nvim 
        echo "All symlinks deleted."
        break
    }
    elseif ($answer -eq 'N' -or [string]::IsNullOrWhitespace($answer)) {
        echo "No symlinks deleted."
        break
    }
    else {
        echo "Enter 'y' or 'N'."
    }
}

