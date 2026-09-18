# Promp
Import-Module posh-git
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\montys.omp.json" | Invoke-Expression

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
function which ($command)
{
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function Start-DotnetProject
{
  param(
    [Parameter(Mandatory)]
    [string]$Window,

    [Parameter(Mandatory)]
    [string]$Title,

    [Parameter(Mandatory)]
    [string]$Project,

    [Parameter(Mandatory)]
    [string]$Profile
  )

  if (-not (Test-Path $Project))
  {
    Write-Warning "Project not found: $Project"
    return
  }

  Write-Host "[START] $Title ($Project, profile=$Profile)"

  wt -w $Window `
    --title $Title `
    pwsh -NoExit -Command "dotnet run --project '$Project' --launch-profile '$Profile'"
}

function Start-ITE-Web
{
  Set-Location -Path "$Home\Code\ems\src\Features\GuiCommon\GuiCommon.Web"
  npm run watch
}

function Start-ITE-api
{
  Set-Location -Path "$Home\Code\ems\src\Features"
  powershell ./OneKeyStartDonet.ps1
}

function Build-ITE-api
{
  Set-Location -Path "$Home\Code\ems\"
  dotnet build Examena-ias.sln
}

function Start-ITE-Db
{
  Set-Location -Path "$Home\Code\ems\src\Features\DatabaseServer\DatabaseServer.Web"
  dotnet run
}

function Start-ITE-ECMS
{
  Set-Location -Path "$Home\Code\ems\src\Features\ECMS\ECMS.Web"
  dotnet run
}

function Stop-ITE-Api
{
  Get-Process |
    Where-Object {
      $_.Path -and $_.Path -like "$HOME\Code\ems\*"
    } |
    ForEach-Object {
      Write-Host "Stopping $($_.ProcessName) (PID: $($_.Id))"
      Stop-Process -Id $_.Id -Force
    }
}


function start-esms-api
{
  Set-Location "$HOME\Code\sms\Portal\src\Hosting\SMS.AppHost"
  dotnet run
}

function start-esms-admin
{
  start-esms-nginx
  Set-Location "$HOME\Code\sms\Portal\src\Web"
  npm run dev-admin
}

function start-esms-student
{
  start-esms-nginx
  Set-Location "$HOME\Code\sms\Portal\src\Web"
  npm run dev-student
}

function start-esms-partner
{
  start-esms-nginx
  Set-Location "$HOME\Code\sms\Portal\src\Web"
  npm run dev-partner
}

function start-esms-nginx
{
  Set-Location "$HOME\Code\sms\nginx"
  $nginxPath = (Resolve-Path "$HOME\Code\sms\nginx\nginx.exe").Path

  $process = Get-Process nginx -ErrorAction SilentlyContinue |
    Where-Object { $_.Path -eq $nginxPath }

  if ($process)
  {
    Write-Host "Nginx is already running (PID: $($process.Id))."
    return
  }

  Start-Process -FilePath $nginxPath -WorkingDirectory (Split-Path $nginxPath)
  Write-Host "Nginx started."
}

function Start-Esms-Customize
{
  param(
    [string]$Window = "0"
  )

  Write-Host "[START] $($p.Title)"
  wt -w $Window `
    --title "Customized.AppHost" `
    pwsh -NoExit -Command "
            Set-Location '$HOME\Code\sms\Customization\CustomizedServices\Customized.AppHost'
            dotnet run --project '$HOME\Code\sms\Customization\CustomizedServices\Customized.AppHost\Customized.AppHost.csproj' --launch-profile https
        "
}

function Start-Esms-BatchJob
{
  param(
    [string]$Window = "0"
  )

  Write-Host "Starting BatchJob.sln startup projects..."
  Write-Host

  $root = "$HOME\Code\sms\Customization\dbp\BatchJob"

  $projects = @(
    @{
      Title   = "BatchJob.JobExe"
      Project = "$root\BatchJob.JobExe\BatchJob.JobExe.csproj"
      Profile = "BatchJob.JobExe"
    },
    @{
      Title   = "BatchJob.AppSvc"
      Project = "$root\BatchJob.AppSvc\BatchJob.AppSvc.csproj"
      Profile = "BatchJob.AppSvc"
    },
    @{
      Title   = "BatchJob.JobSvc"
      Project = "$root\BatchJob.JobSvc\BatchJob.JobSvc.csproj"
      Profile = "BatchJob.JobSvc"
    }
  )

  foreach ($p in $projects)
  {
    if (-not (Test-Path $p.Project))
    {
      Write-Warning "Project not found: $($p.Project)"
      continue
    }

    Write-Host "[START] $($p.Title)" 
    $projectDir = Split-Path $p.Project
    wt -w $Window `
      --title $p.Title `
      pwsh -NoExit -Command "Set-Location '$projectDir' && dotnet run --project '$($p.Project)' --launch-profile '$($p.Profile)'"  
  }

}

function Start-Esms-JobWeb
{
  param(
    [string]$Window = "3000"
  )
  Write-host "Starting BatchJob.Web..."
  set-Location "$HOME\Code\sms\Customization\dbp\BatchJob\BatchJob.Web\Spa"
  wt -w $Window `
    --title "BatchJob Web" `
    pwsh -NoExit -Command "set-Location '$HOME\Code\sms\Customization\dbp\BatchJob\BatchJob.Web\Spa' && npm run dev"
}

function Start-Esms-job
{
  param(
    [string]$Window = "3000"
  )
  Start-Esms-Customize -Window $window
  Start-Esms-BatchJob -Window $window
}

function Start-Esms-Db 
{
  param(
    [string]$Window = "3000"
  )
  Write-host "[START] DatabaseServer:..."
  wt -w $Window `
    --title "Customized.AppHost" `
    pwsh -NoExit -Command "
            Set-Location '$HOME\Code\sms\Portal\src\Fundamental\Database\DatabaseServer.Web'
            dotnet run --project '$HOME\\sms\Portal\src\Fundamental\Database\DatabaseServer.Web\DatabaseServer.Web.csproj'
        "
}


function Stop-Esms-Job
{
  Get-Process |
    Where-Object {
      $_.Path -and $_.Path -like "$HOME\Code\sms\Customization\*" 
    } |
    ForEach-Object {
      Write-Host "Stopping $($_.ProcessName) (PID: $($_.Id))"
      Stop-Process -Id $_.Id -Force
    }
}

function Stop-Esms-Api
{
  Get-Process |
    Where-Object {
      $_.Path -and $_.Path -like "$HOME\Code\sms\*"
    } |
    ForEach-Object {
      Write-Host "Stopping $($_.ProcessName) (PID: $($_.Id))"
      Stop-Process -Id $_.Id -Force
    }
}

function Set-esms-token 
{
  param([string]$Text)
  $fileDir = "$HOME\Code\sms\Customization\CustomizedServices\CustomizedForTP\LowcodeService.API\Services\Report\DbpJobExecutionService.cs"
  $lines = Get-Content $fileDir
  $lines[77] = "                cookieContainer.Add(new Uri(RuntimeContext.Config.DbpClient.Endpoint), new Cookie(`"mars_access_token`",`"$Text`"));"
  $lines | Set-Content $fileDir -Encoding utf8
  Write-Host ("Token was Set successfully")
}

function Set-esms-cookie
{
  param([string]$Text)
  $fileDir = "$HOME\Code\sms\Customization\dbp\BatchJob\BatchJob.Report.Common\Extensions\ServiceExtension.cs"
  $lines = Get-Content $fileDir
  $lines[89] = "            cookieContainer.Add(new Uri(baseAddress), new Cookie(`"Cookies`",`"$Text`"));"
  $lines | Set-Content $fileDir -Encoding utf8
  Write-Host ("Cookie was Set successfully")
}


# Chạy LazyVim bằng lệnh 'lazyvim'
function lazyvim
{
  $env:NVIM_APPNAME = "nvim"
  nvim $args
}

# Chạy NvChad bằng lệnh 'nvchad'
function nvchad
{
  $env:NVIM_APPNAME = "nvchad"
  nvim $args
}

# Chạy AstroNvim bằng lệnh 'astronvim'
function astronvim
{
  $env:NVIM_APPNAME = "astronvim"
  nvim $args
}
