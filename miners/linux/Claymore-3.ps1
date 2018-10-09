$Path = "$($nvidia.claymore.path3)"
$Uri = "$($nvidia.claymore.uri)"
$MinerName = "$($nvidia.claymore.minername)"

$Build = "Zip"

if($ClayDevices3 -ne ''){$Devices = $ClayDevices3}
if($GPUDevices3 -ne '')
 {
  $GPUEDevices3 = $GPUDevices3 -replace ',',''
  $Devices = $GPUEDevices3
 }

 $Commands = [PSCustomObject]@{
    "ethash" = '-esm 2'
    "daggerhashimoto" = '-esm 3 -estale 0'
    }

    $Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

    if($CoinAlgo -eq $null)
    {
     $Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
      if($Algorithm -eq "$($AlgoPools.$_.Algorithm)")
      {
        [PSCustomObject]@{
        Platform = $Platform  
        Symbol = "$($_)"
        MinerName = $MinerName
        Type = "NVIDIA3"
        Path = $Path
        Devices = $Devices
        DeviceCall = "claymore"
        Arguments = "-mport 3335 -mode 1 -allcoins 1 -allpools 1 -epool $($AlgoPools.$_.Protocol)://$($AlgoPools.$_.Host):$($AlgoPools.$_.Port) -ewal $($AlgoPools.$_.User3) -epsw $($AlgoPools.$_.Pass3) -wd 0 -dbg -1 -eres 1 $($Commands.$_)"
        HashRates = [PSCustomObject]@{$_ = $MinerWatts}
        PowerX = [PSCustomObject]@{$_ = if($WattOMeter -eq "Yes"){$($Stats."$($Name)_$($_)_Power".Day)}elseif($Watts.$($_).NVIDIA3_Watts){$Watts.$($_).NVIDIA3_Watts}elseif($Watts.default.NVIDIA3_Watts){$Watts.default.NVIDIA3_Watts}else{0}}
        FullName = "$($AlgoPools.$_.Mining)"
        API = "claymore"
        Port = 3335
        MinerPool = "$($AlgoPools.$_.Name)"
        Wrap = $false
        URI = $Uri
        BUILD = $Build
        Algo = "$($_)"
        NewAlgo = ''
             }
           }
         }
       }
       else {
         $CoinPools | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name |
         Where {$($Commands.$($CoinPools.$_.Algorithm)) -NE $null} |
         foreach {
               [PSCustomObject]@{
               Platform = $Platform
               Coin = "Yes"
               Symbol = "$($CoinPools.$_.Symbol)"
               MinerName = $MinerName
               Type = "NVIDIA3"
               Path = $Path
               Devices = $Devices
               DeviceCall = "claymore"
               Arguments = "-mport 3335 -mode 1 -allcoins 1 -allpools 1 -epool $($CoinPools.$_.Protocol)://$($CoinPools.$_.Host):$($CoinPools.$_.Port) -ewal $($CoinPools.$_.User3) -epsw $($CoinPools.$_.Pass3) -wd 0 -dbg -1 -eres 1 $($Commands.$($CoinPools.$_.Algorithm))"
               HashRates = [PSCustomObject]@{$CoinPools.$_.Symbol= $MinerWatts}
               PowerX = [PSCustomObject]@{$CoinPools.$_.Symbol = if($WattOMeter -eq "Yes"){$($Stats."$($Name)_$($CoinPools.$_.Algorithm)_Power".Day)}elseif($Watts.$($CoinPools.$_.Algorithm).NVIDIA3_Watts){$Watts.$($CoinPools.$_.Algorithm).NVIDIA3_Watts}elseif($Watts.default.NVIDIA3_Watts){$Watts.default.NVIDIA3_Watts}else{0}}
               FullName = "$($CoinPools.$_.Mining)"
               MinerPool = "$($CoinPools.$_.Name)"
               API = "claymore"
               Port = 3335
               Wrap = $false
               URI = $Uri
               BUILD = $Build
               Algo = "$($CoinPools.$_.Algorithm)"
              }
             }
            }