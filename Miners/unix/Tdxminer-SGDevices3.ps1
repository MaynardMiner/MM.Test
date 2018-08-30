[string]$Path = $update.amd.tdxminer.path3
[string]$Uri = $update.amd.tdxminer.uri

$Build = "Zip"

if($SGDevices2 -ne ''){$Devices = $SGDevices2}
if($GPUDevices2 -ne ''){$Devices = $GPUDevices2}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName


$Commands = [PSCustomObject]@{
"lyra2z" = ''
}


if($CoinAlgo -eq $null)
{
$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
 if($Algorithm -eq "$($AlgoPools.$_.Algorithm)")
  {
    [PSCustomObject]@{
    Platform = $Platform
    Symbol = "$($_)"
    MinerName = "tdxminer-AMD3"
    Type = "AMD3"
    Path = $Path
    Devices = $Devices
    DeviceCall = "sgminer-gm"
    Arguments = "-a $_ -o stratum+tcp://$($AlgoPools.$_.Host):$($AlgoPools.$_.Port) -u $($AlgoPools.$_.User3) -p $($AlgoPools.$_.Pass3) $($Commands.$_)"
    HashRates = [PSCustomObject]@{$_ = $Stats."$($Name)_$($_)_HashRate".Day}
    Selected = [PSCustomObject]@{$_ = ""}
    MinerPool = "$($AlgoPools.$_.Name)"
    FullName = "$($AlgoPools.$_.Mining)"
    Port = 0
    API = "tdxminer"
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
   MinerName = "tdxminer-AMD3"
   Type = "AMD3"
   Path = $Path
   Devices = $Devices
   DeviceCall = "sgminer-gm"
   Arguments = "-a $($CoinPools.$_.Algorithm) -o stratum+tcp://$($CoinPools.$_.Host):$($CoinPools.$_.Port) -u $($CoinPools.$_.User3) -p $($CoinPools.$_.Pass3) $($CoinPools.$Commands.$($CoinPools.$_.Algorithm))"
   HashRates = [PSCustomObject]@{$CoinPools.$_.Symbol= $Stats."$($Name)_$($CoinPools.$_.Algorithm)_HashRate".Day}
   API = "tdxminer"
   Selected = [PSCustomObject]@{$CoinPools.$_.Algorithm = ""}
   FullName = "$($CoinPools.$_.Mining)"
	 MinerPool = "$($CoinPools.$_.Name)"
   Port = 0
   Wrap = $false
   URI = $Uri
   BUILD = $Build
	 Algo = "$($CoinPools.$_.Algorithm)"
   }
  }
 }
