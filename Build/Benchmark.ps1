param(
    [parameter(Mandatory=$true)]
    [String]$Name
)

$CmdDir = (Split-Path $script:MyInvocation.MyCommand.Path)
$Dir = Split-Path $CmdDir
Set-Location $Dir
Write-Host "Checking For $Name Bechmarks"
if(Test-Path ".\Stats\*$($Name)_HashRate.txt*"){Remove-Item ".\Stats\*$($Name)_HashRate.txt*" -Force}
Write-Host "Removed Hashrate files" -ForegroundColor Green
