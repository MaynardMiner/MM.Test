[string]$Path = $update.nvidia.cryptodredge.path3
[string]$Uri = $update.nvidia.cryptodredge.uri
[string]$MinerName = $update.nvidia.cryptodredge.minername

$Build = "Zip"

if($RexDevices3 -ne ''){$Devices = $RexDevices3}
if($GPUDevices3 -ne ''){$Devices = $GPUDevices3}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands = [PSCustomObject]@{
  
  "lyra2v2" = ''
  "lyra2rev2" = ''
  "lyra2z" = ''
  "lyra2re" = ''
  "allium" = ''
  "neoscrypt" = ''
  "blake2s" = ''
  "skein" = ''
  "cryptonightv7" = ''
  "cryptonightheavy" = ''
  "aeon" = ''
  "masari" = ''
  "stellite" = ''
  "lbk3" = ''

  }
        

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
                DeviceCall = "ccminer"
                Arguments = "-a $(Get-Nvidia($_)) -o stratum+tcp://$($AlgoPools.$_.Host):$($AlgoPools.$_.Port) -b 0.0.0.0:4070 -u $($AlgoPools.$_.User3) -p $($AlgoPools.$_.Pass3) $($Commands.$_)"
                HashRates = [PSCustomObject]@{$_ = $Stats."$($Name)_$($_)_HashRate".Day}
                Selected = [PSCustomObject]@{$_ = ""}
                MinerPool = "$($AlgoPools.$_.Name)"
                FullName = "$($AlgoPools.$_.Mining)"
                Port = 4069
                API = "Ccminer"
                Wrap = $false
                URI = $Uri
                BUILD = $Build
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
         Symbol = "$($CoinPools.$_.Symbol)"
         MinerName = "Dredge"
         Type = "NVIDIA3"
         Path = $Path
         Devices = $Devices
         DeviceCall = "ccminer"
         Arguments = "-a $(Get-Algorithm($CoinPools.$_.Algorithm)) -o stratum+tcp://$($CoinPools.$_.Host):$($CoinPools.$_.Port) -b 0.0.0.0:4070 -u $($CoinPools.$_.User3) -p $($CoinPools.$_.Pass3) $($Commands.$($Coinpools.$_.Algorithm))"
         HashRates = [PSCustomObject]@{$CoinPools.$_.Symbol= $Stats."$($Name)_$($CoinPools.$_.Algorithm)_HashRate".Day}
         API = "Ccminer"
         Selected = [PSCustomObject]@{$($CoinPools.$_.Algorithm) = ""}
         FullName = "$($CoinPools.$_.Mining)"
	 MinerPool = "$($CoinPools.$_.Name)"
         Port = 4070
         Wrap = $false
         URI = $Uri
         BUILD = $Build
	 Algo = "$($CoinPools.$_.Algorithm)"
         }
        }
       }
