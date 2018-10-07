
function Start-OC {
    param (
      [Parameter(Mandatory=$false)]
      [String]$OCType,
      [Parameter(Mandatory=$false)]
      [String]$Miner_Algo
    )

if($OCType -like "*NVIDIA*")
{
Write-Host "OCType is NVIDIA"
$OCSettings = Get-Content ".\config\oc\oc-nvidia.conf" | ConvertFrom-Json
$DefaultCore = $OCSettings.Default.Core -split ' '
$DefaultMem = $OCSettings.Default.Memory -split ' '
$DefaultPower = $OCSettings.Default.Power -split ' '
$Core = $OCSettings.$Miner_Algo.Core -split ' '
$Mem = $OCSettings.$Miner_Algo.Memory -split ' '
$Power = $OCSettings.$Miner_Algo.Power -split ' '
$Card = $OCSettings.Cards.Cards -split ' '
$Default = $true
if($Card -ne "" -and $DefaultCore -ne "")
 {
 if($Core)
  {
 $Default = $false
 $OCArgs = @()
 for($i=0; $i -lt $Power.Count; $i++)
 {
   $PWLSelected = $Power | Select -skip $i | Select -First 1
   Start-Process "nvidia-smi" -ArgumentList "-i $i -pl $PWLSelected" -Wait
 }
 for($i=0; $i -lt $Core.Count; $i++)
 {
   $X = 3
   Switch($Card | Select -skip $i | Select -First 1){
   "1050"{$X = 2}
   "1050ti"{$X = 2}
   "P106-100"{$X = 2}
   "P106-090"{$X = 1}
   "P104-100"{$X = 1}
   "P102-100"{$X = 1}
   }
   $OCArgs += " -a [gpu:$i]/GPUGraphicsClockOffset[$X]=$($Core | Select -skip $i | Select -First 1)"
   $OCArgs += " -a [gpu:$i]/GPUMemoryTransferRateOffset[$X]=$($Mem | Select -skip $i | Select -First 1)"
 }
if($OCArgs -ne $null){Start-Process "nvidia-settings" -ArgumentList "$OCArgs"}
}
else{
 Write-Host "Default Settings Selected"
 $OCArgs = @()
 for($i=0; $i -lt $DefaultPower.Count; $i++)
  {
   $PWLSelected = $DefaultPower | Select -skip $i | Select -First 1
   Start-Process "nvidia-smi" -ArgumentList "-i $i -pl $PWLSelected" -Wait
  }
 for($i=0; $i -lt $DefaultCore.Count; $i++)
 {
   $X = 3
   Switch($Card | Select -Skip $i | Select -First 1){
   "1050"{$X = 2}
   "1050ti"{$X = 2}
   "P106-100"{$X = 2}
   "P106-090"{$X = 1}
   "P104-100"{$X = 1}
   "P102-100"{$X = 1}
   }
   $OCArgs += " -a [gpu:$i]/GPUGraphicsClockOffset[$X]=$($DefaultCore | Select -Skip $i | Select -First 1)"
   $OCArgs += " -a [gpu:$i]/GPUMemoryTransferRateOffset[$X]=$($DefaultMem | Select -Skip $i | Select -First 1)"
 }
if($OCArgs -ne $null){Start-Process "nvidia-settings" -ArgumentList "$OCArgs"}

if($Default -eq $true)
{
$OCMessage = "
Current OC Profile:

Algorithm is $Miner_Algo
Default: $Default
Cards: $($OCSettings.Cards.Cards)
Power Settings: $($OCSettings.Default.Power)
Core Settings: $($OCSettings.Default.Core)
Memory Settings: $($OCSettings.Default.Memory)
"
}
else{
$OCMessage = "
Current OC Profile:

Algorithm is $Miner_Algo
Default: $Default
Cards: $($OCSettings.Cards)
Power Settings: $($OCSettings.$Miner_Algo.Power)
Core Settings: $($OCSettings.$Miner_Algo.Core)
Memory Settings: $($OCSettings.$Miner_Algo.Memory)
"
 }
 $OCMessage | Out-File ".\build\txt\oc-settings.txt"

   }
  }
 }
}