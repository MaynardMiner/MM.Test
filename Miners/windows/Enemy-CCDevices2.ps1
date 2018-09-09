[string]$Path = $update.nvidia.enemy.path2
[string]$Uri = $update.nvidia.enemy.uri
$Build = "Zip"

if($CCDevices2 -ne ''){$Devices = $CCDevices2}
if($GPUDevices2 -ne ''){$Devices = $GPUDevices2}
$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

#Algorithms
#X16R
#X16S
#Aergo

$Commands = [PSCustomObject]@{
  "x16r" = ''
  "x16s" = ''
  "aeriumx" = ''
  "phi2" = ''
  "hex" = ''
  "timetravel" = ''
  "xevan" = ''
  "sonoa" = ''
  }
  
if($CoinAlgo -eq $null)
{
$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
  if($Algorithm -eq "$($AlgoPools.(Get-Algorithm($_)).Algorithm)")
  {
  [PSCustomObject]@{
    Platform = $Platform
    Symbol = "$(Get-Algorithm($_))"
    MinerName = "z-enemy-NVIDIA2"
    Type = "NVIDIA2"
    Path = $Path
    Devices = $Devices
    DeviceCall = "ccminer"
    Arguments = "-a $_ -o stratum+tcp://$($AlgoPools.(Get-Algorithm($_)).Host):$($AlgoPools.(Get-Algorithm($_)).Port) -b 0.0.0.0:4068 -u $($AlgoPools.(Get-Algorithm($_)).User1) -p $($AlgoPools.(Get-Algorithm($_)).Pass1) $($Commands.$_)"
    HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day}
    Selected = [PSCustomObject]@{(Get-Algorithm($_)) = ""}
    Port = 4069
    MinerPool = "$($AlgoPools.(Get-Algorithm($_)).Name)"
    FullName = "$($AlgoPools.(Get-Algorithm($_)).Mining)"
    API = "Ccminer"
    Wrap = $false
    URI = $Uri
    BUILD = $Build
    Stats = "ccminer"
    Algo = "$($_)"
    NewAlgo = ''
   }
  }
 }
}
else{
  $CoinPools | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name |
  Where {$($Commands.$($CoinPools.$_.Algorithm)) -NE $null} |
  foreach {
  [PSCustomObject]@{
    Platform = $Platform
   Coin = "Yes"
   Symbol = "$($CoinPools.$_.Symbol)"
   MinerName = "z-enemy-NVIDIA2"
   Type = "NVIDIA2"
   Path = $Path
   Devices = $Devices
   DeviceCall = "ccminer"
   Arguments = "-a $($CoinPools.$_.Algorithm) -o stratum+tcp://$($CoinPools.$_.Host):$($CoinPools.$_.Port) -b 0.0.0.0:4069 -u $($CoinPools.$_.User2) -p $($CoinPools.$_.Pass2) $($Commands.$($CoinPools.$_.Algorithm))"
   HashRates = [PSCustomObject]@{$CoinPools.$_.Symbol= $Stats."$($Name)_$($CoinPools.$_.Algorithm)_HashRate".Day}
   API = "Ccminer"
   Selected = [PSCustomObject]@{$($CoinPools.$_.Algorithm) = ""}
   FullName = "$($CoinPools.$_.Mining)"
   MinerPool = "$($CoinPools.$_.Name)"
   Port = 4069
   Wrap = $false
   URI = $Uri
   BUILD = $Build
   Algo = "$($CoinPools.$_.Algorithm)"
   }
  }
 }
