# Promp
Import-Module posh-git
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\montys.omp" | Invoke-Expression

# Load prompt config
# function Get-ScriptDirection { Split-Path $MyInvocation.ScriptName}
# $PROMPT_CONFIG = Join-Path (Get-ScriptDirection) 'minhgiang.omp.json'

# PSReadline
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History

#Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Icons
Import-Module -Name Terminal-Icons

# Alias
Set-Alias v nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias c cls
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'

#Ultilities
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
      Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
  }

