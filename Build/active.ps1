Set-Location (Join-Path (Split-Path $script:MyInvocation.MyCommand.Path) "\Unix\Hive")
Get-Content ".\mineractive.sh"
exit
