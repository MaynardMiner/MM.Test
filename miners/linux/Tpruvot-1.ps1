$Path = "$($nvidia.tpruvot.path1)"
$Uri = "$($nvidia.tpruvot.uri)"
$MinerName = "$($nvidia.tpruvot.minername)"


$Build = "Zip"

if($CCDevices1 -ne ''){$Devices = $CCDevices1}
if($GPUDevices1 -ne ''){$Devices = $GPUDevices1}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

#Algorithms
#Lyra2v2 
#Keccak
#Skunk
#Tribus
#Phi
#Keccakc
#Quark (Not Used)
#X12
#Phi
#Sib

$Commands = [PSCustomObject]@{
"qubit" = ''
"keccak" = ''
"blakecoin" = ''
"keccakc" = ''
"x12" = ''
"sib" = ''
"myr-gr" = ''

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
    Type = "NVIDIA1"
    Path = $Path
    Devices = $Devices
    DeviceCall = "ccminer"
    Arguments = "-a $_ -o stratum+tcp://$($AlgoPools.$_.Host):$($AlgoPools.$_.Port) -b 0.0.0.0:4068 -u $($AlgoPools.$_.User1) -p $($AlgoPools.$_.Pass1) $($Commands.$_)"
    HashRates = [PSCustomObject]@{$_ = $Stats."$($Name)_$($_)_HashRate".Day}
    PowerX = [PSCustomObject]@{$_ = if($WattOMeter -eq "Yes"){$($Stats."$($Name)_$($_)_Power".Day)}elseif($Watts.$($_).NVIDIA1_Watts){$Watts.$($_).NVIDIA1_Watts}elseif($Watts.default.NVIDIA1_Watts){$Watts.default.NVIDIA1_Watts}else{0}}
    MinerPool = "$($AlgoPools.$_.Name)"
    FullName = "$($AlgoPools.$_.Mining)"
    Port = 4068
    API = "Ccminer"
    Wrap = $false
    URI = $Uri
    BUILD = $Build
    Algo = "$($_)"
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
    MinerName = $MinerName
   Type = "NVIDIA1"
   Path = $Path
   Devices = $Devices
   DeviceCall = "ccminer"
   Arguments = "-a $($CoinPools.$_.Algorithm) -o stratum+tcp://$($CoinPools.$_.Host):$($CoinPools.$_.Port) -b 0.0.0.0:4068 -u $($CoinPools.$_.User1) -p $($CoinPools.$_.Pass1) $($Commands.$($CoinPools.$_.Algorithm))"
   HashRates = [PSCustomObject]@{$CoinPools.$_.Symbol= $Stats."$($Name)_$($CoinPools.$_.Algorithm)_HashRate".Day}
   API = "Ccminer"
   PowerX = [PSCustomObject]@{$CoinPools.$_.Symbol = if($WattOMeter -eq "Yes"){$($Stats."$($Name)_$($CoinPools.$_.Algorithm)_Power".Day)}elseif($Watts.$($CoinPools.$_.Algorithm).NVIDIA1_Watts){$Watts.$($CoinPools.$_.Algorithm).NVIDIA1_Watts}elseif($Watts.default.NVIDIA1_Watts){$Watts.default.NVIDIA1_Watts}else{0}}
   FullName = "$($CoinPools.$_.Mining)"
	 MinerPool = "$($CoinPools.$_.Name)"
   Port = 4068
   Wrap = $false
   URI = $Uri
   BUILD = $Build
	 Algo = "$($CoinPools.$_.Algorithm)"
   }
  }
 }
