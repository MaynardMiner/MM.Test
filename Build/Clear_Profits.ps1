$CmdDir = (Split-Path $script:MyInvocation.MyCommand.Path)
$Dir = Split-Path $CmdDir
Set-Location $Dir
Write-Host "Gathering All Profit Stats"
if(Test-Path ".\Stats\*Profit.txt*"){Remove-Item ".\Stats\*Profit.txt*" -Force}
Write-Host "Cleared All Profit Stats" -Foreground Green
