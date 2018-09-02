[string]$Path = $update.amd.claymore.path2
[string]$Uri = $update.amd.claymore.uri
[string]$MinerName = $update.amd.claymore.minername

$Build = "Zip"

if($ClayDevices2 -ne ''){$Devices = $ClayDevices2}
if($GPUDevices1 -ne '')
 {
  $GPUEDevices2 = $GPUDevices2 -replace ',',''
  $Devices = $GPUEDevices2
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
     Type = "AMD2"
     Path = $Path
     Devices = $Devices
     DeviceCall = "claymore"
     Arguments = "-mport -3337 -mode 1 -allcoins 1 -allpools 1 -epool $($AlgoPools.$_.Protocol)://$($AlgoPools.$_.Host):$($AlgoPools.$_.Port) -ewal $($AlgoPools.$_.User1) -epsw $($AlgoPools.$_.Pass1) -wd 0 -dbg -1 -eres 2 $($Commands.$_)"
     HashRates = [PSCustomObject]@{$_ = $Stats."$($Name)_$($_)_HashRate".Day}
     Selected = [PSCustomObject]@{$_ = ""}
     FullName = "$($AlgoPools.$_.Mining)"
     API = "claymore"
     Port = 3337
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
            Type = "AMD2"
            Path = $Path
            Devices = $Devices
            DeviceCall = "claymore"
            Arguments = "-mport -3337 -mode 1 -allcoins 1 -allpools 1 -epool $($CoinPools.$_.Protocol)://$($CoinPools.$_.Host):$($CoinPools.$_.Port) -ewal $($CoinPools.$_.User1) -epsw $($CoinPools.$_.Pass1) -wd 0 -dbg -1 -eres 2 $($Commands.$($CoinPools.$_.Algorithm))"
            HashRates = [PSCustomObject]@{$CoinPools.$_.Symbol= $Stats."$($Name)_$($CoinPools.$_.Algorithm)_HashRate".Day}
            Selected = [PSCustomObject]@{$($CoinPools.$_.Algorithm) = ""}
            FullName = "$($CoinPools.$_.Mining)"
            MinerPool = "$($CoinPools.$_.Name)"
            API = "claymore"
            Port = 3337
            Wrap = $false
            URI = $Uri
            BUILD = $Build
            Algo = "$($CoinPools.$_.Algorithm)"
           }
          }
         }
