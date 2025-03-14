# Custom Prompt Function
function prompt {
    # Get username
    $username = $env:USERNAME  # Windows, or use [System.Environment]::UserName for cross-platform
    # Get hostname
    $hostname = [System.Net.Dns]::GetHostName()
    # Get current directory (tilde-like behavior needs custom logic)
    $currentDir = (Get-Location).Path
    $homeDir = $env:HOME ?? $env:USERPROFILE  # Use HOME if set, else USERPROFILE
    if ($currentDir.StartsWith($homeDir)) {
        $currentDir = "~" + $currentDir.Substring($homeDir.Length)
    }

    # Build the prompt string with colors
    Write-Host "[" -NoNewline -ForegroundColor Red
    Write-Host "$username" -NoNewline -ForegroundColor Yellow
    Write-Host "@" -NoNewline -ForegroundColor Green
    Write-Host "$hostname" -NoNewline -ForegroundColor Blue
    Write-Host " " -NoNewline
    Write-Host "$currentDir" -NoNewline -ForegroundColor Magenta
    Write-Host "]" -NoNewline -ForegroundColor Red
    Write-Host "$" -NoNewline -ForegroundColor White

    # Return a space to ensure the cursor starts after the prompt
    return " "
}

# Touch-File Function
function Touch-File {
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$Path
    )
    foreach ($file in $Path) {
        if (Test-Path $file) {
            # Update the timestamp of an existing file
            (Get-Item $file).LastWriteTime = Get-Date
        } else {
            # Create a new empty file
            New-Item -ItemType File -Path $file -Force | Out-Null
        }
    }
}

# Set the touch alias
Set-Alias -Name touch -Value Touch-File

# Keep your existing aliases
function Connect-Watch { ssh -C debian@51.79.254.133 }
Set-Alias -Name sshwatch -Value Connect-Watch

function Connect-Pdf { ssh -C debian@51.178.139.7 }
Set-Alias -Name sshpdf -Value Connect-Pdf
