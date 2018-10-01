$Path = "$($nvidia.lolminer.path3)"
$Uri = "$($nvidia.lolminer.uri)"
$MinerName = "$($nvidia.lolminer.minername)"

$Build = "Tar"

if($REXDevices3 -ne ''){$Devices = $REXDevices3}
if($GPUDevices3 -ne ''){$Devices = $GPUDevices3}

#Equihash192

$MinerType = "NVIDIA3"

$Commands = [PSCustomObject]@{
  "equihash-btg" = [PSCustomObject]@{
   coin="BTG"
   disable_memcheck=1
   }
  "equihash192" = [PSCustomObject]@{
    coin="ZER"
    disable_memcheck=1
    }
  "equihash96" = [PSCustomObject]@{
    coin="MNX"
    disable_memcheck=0
    }
  }

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

if($CoinAlgo -eq $null)
{
$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
 if($Type -eq $MinerType)
  {
  if($Algorithm -eq "$($AlgoPools.$_.Algorithm)")
   {
  $JsonConfig = [PSCustomObject]@{
   miner=[PSCustomObject]@{
   APIPORT=4040
   SHORTSTATS=10
   LONGSTATS=120
   COIN="$($Commands.$_.coin)"
   POOL="$($AlgoPools.$_.Host)"
   PORT="$($AlgoPools.$_.Port)"
   USER="$($AlgoPools.$_.User3)"
   PASS="$($AlgoPools.$_.Pass3)"
   DISABLE_MEMCHECK="$($Commands.$_.disable_memcheck)"
   DIGITS=2
    }
   }
   if(Test-Path (Split-Path $Path))
    {
     $JsonConfig | ConvertTo-Json | Set-Content (Join-Path (Split-Path $Path) "$_.json")
    }
  }
 }
}
}
else{
  $CoinPools | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name |
  Where {$($Commands.$($CoinPools.$_.Algorithm)) -NE $null} |
  foreach {
    if($Type -eq $MinerType)
    {
      $JsonConfig = [PSCustomObject]@{
        miner=[PSCustomObject]@{
        APIPORT=4037
        SHORTSTATS=10
        LONGSTATS=120
        COIN="$($Commands.$($CoinPools.$_.Algorithm).coin)"
        POOL="$($CoinPools.$_.Host)"
        PORT="$($CoinPools.$_.Port)"
        USER="$($CoinPools.$_.User1)"
        PASS="$($CoinPools.$_.Pass1)"
        DISABLE_MEMCHECK="$($Commands.$($CoinPools.$_.Algorithm).disable_memcheck)"
        DIGITS=2
         }
        }
        $JsonConfig | ConvertTo-Json | Set-Content (Join-Path (Split-Path $Path) "$($CoinPools.$_.Symbol).json")
       }
      }
    }
    
if($CoinAlgo -eq $null)
{
$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
  if($Algorithm -eq "$($AlgoPools.$_.Algorithm)" -and $Type -eq "NVIDIA3")
  {
    if($WattOMeter -eq "No")
    {
    if($Watts.$($_).NVIDIA3_Watts){$Stat = Set-Stat "$($Name)_$($_)_Power" -Value $Watts.$($_).NVIDIA3_Watts}
    else{$Stat = Set-Stat "$($Name)_$($_)_Power" -Value $Watts.default.NVIDIA3_Watts}
    }
    if($Stat = $null){$MinerWatts = $Stats."$($Name)_$($_)_Power".Day}
    else{$MinerWatts = $Stat.Day}
    [PSCustomObject]@{
      Platform = $Platform
      Symbol = "$($_)"
      MinerName = $MinerName
      Type = $MinerType
      Path = $Path
      Devices = $Devices
      DeviceCall = "lolminer"
      Config = "$_.json"
      Arguments = "-APIPORT=4068 -pool=$($AlgoPools.$_.Host) -port=$($AlgoPools.$_.Port) -user=$($AlgoPools.$_.User3) -pass=$($AlgoPools.$_.Pass3)"
      HashRates = [PSCustomObject]@{$_ = $Stats."$($Name)_$($_)_HashRate".Day}
      PowerX = [PSCustomObject]@{$CoinPools.$_.Symbol = if($WattOMeter -eq "Yes"){$($Stats."$($Name)_$($CoinPools.$_.Algorithm)_Power".Day)}elseif($Watts.$($CoinPools.$_.Algorithm).NVIDIA3_Watts){$Watts.$($CoinPools.$_.Algorithm).NVIDIA3_Watts}elseif($Watts.default.NVIDIA3_Watts){$Watts.default.NVIDIA3_Watts}else{0}}
      MinerPool = "$($AlgoPools.$_.Name)"
      FullName = "$($AlgoPools.$_.Mining)"
      API = "lolminer"
      Port = 4040
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
          if($Type -eq "NVIDIA3")
          {
          if($WattOMeter -eq "No")
          {
           if($Watts.$($CoinPools.$_.Algorithm).NVIDIA3_Watts -ne ""){Set-Stat "$($Name)_$($CoinPools.$_.Algorithm)_Power" -Value $Watts.$($_).NVIDIA3_Watts}
           else{Set-Stat "$($Name)_$($CoinPools.$_.Algorithm)_Power" -Value $Watts.default.NVIDIA3_Watts}
          }
          if($Stat = $null){$MinerWatts = $Stats."$($Name)_$($CoinPools.$_.Algorithm)_Power".Day}
          else{$MinerWatts = $Stat.Day}      
         [PSCustomObject]@{
          Platform = $Platform
          Symbol = "$($Coinpools.$_.Symbol)"
          MinerName = $MinerName
          Type = $MinerType
           Path = $Path
           Devices = $Devices
           DeviceCall = "lolminer"
           Config = "$($CoinPools.$_.Symbol).json"
           Arguments = "-APIPORT=4068 -pool=$($CoinPools.$_.Host) -port=$($CoinPools.$_.Port) -user=$($CoinPools.$_.User3) -pass=$($CoinPools.$_.Pass3)"
           HashRates = [PSCustomObject]@{$CoinPools.$_.Symbol= $Stats."$($Name)_$($CoinPools.$_.Algorithm)_HashRate".Day}
           PowerX = [PSCustomObject]@{$CoinPools.$_.Symbol = if($WattOMeter -eq "Yes"){$($Stats."$($Name)_$($CoinPools.$_.Algorithm)_Power".Day)}elseif($Watts.$($_).NVIDIA3_Watts){$Watts.$($_).NVIDIA3_Watts}elseif($Watts.default.NVIDIA3_Watts){$Watts.default.NVIDIA3_Watts}else{0}}
           FullName = "$($CoinPools.$_.Mining)"
           API = "lolminer"
           MinerPool = "$($CoinPools.$_.Name)"
           Port = 4040
           Wrap = $false
           URI = $Uri
           BUILD = $Build
           Algo = "$($CoinPools.$_.Algorithm)"
           }
          }
         }
        }
