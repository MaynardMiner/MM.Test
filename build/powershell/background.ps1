<#
SWARM is open-source software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
SWARM is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
#>

param(
[Parameter(Mandatory=$false)]
[String]$WorkingDir,
[Parameter(Mandatory=$false)]
[String]$Platforms
)

Set-Location $WorkingDir

##Functions:
. .\build\powershell\hashrates.ps1
. .\build\powershell\octune.ps1
##Data
$GetMiners = Get-Content ".\build\txt\bestminers.txt" | ConvertFrom-Json

##Set-OC
$GetMiners | foreach {
$NvidiaDone = $false
$AMDDone = $false
if($_.Type -like "*NVIDIA*" -and $NvidiaDone -eq $false -and $Platforms -eq "linux")
{
Write-Host "Starting Tuning"
$NvidiaDone = $true
Start-OC -OCType $($_.Type) -Miner_Algo $($_.Algo)
 }
}

$CPUOnly = $true

$GetMiners | Foreach {
  if($_.Type -like "*NVIDIA*" -or $_.Type -like "*AMD*")
  {
  $CPUOnly = $false; "GPU" | Set-Content ".\build\txt\miner.txt"
  }
  else
  {"CPU" | Set-Content ".\build\txt\miner.txt"}
}
$BackgroundTimer = New-Object -TypeName System.Diagnostics.Stopwatch
$BackgroundTimer.Restart()
$GetMiners | Foreach {
$NEW=0 
$NEW | Set-Content ".\build\txt\$($_.Type)-hash.txt" 
}

While($True)
{

$GPUHashrates = @()
$CPUHashrates = @()
$GPUFans = @()
$GPUTemps = @()
$KHS = 0

$GetMiners | Foreach {
 if($_.Type -eq "CPU")
 {
  $GetDevices = Get-DeviceString -TypeDevices $_.LogGPUS 
  $GetDevices | Foreach {$CPUHashrates += 0}
 }
 else
 {
  if($_.Devices -eq $null)
  {
   $GetDevices = Get-DeviceString -TypeDevices $_.LogGPUS
  }
  else
  {
   $GetDevices = Get-DeviceString -TypeDevices $_.Devices
  }
   $GetDevices | foreach {$GPUHashrates += 0; $GPUFans += 0; $GPUTemps += 0}
 }
}

$GetMiners | Foreach {

if($_.Type -like "*NVIDIA*" -or $_.Type -like "*AMD*")
 {
  $Server = "localhost"
  $Interval = 15
  $Port = $($_.Port)
  $MinerType = $($_.Type)
  $MinerAlgo = $($_.Algo)
  if($_.Devices -eq $null){$Devices = Get-DeviceString -TypeDevices $_.LogGPUS}
  else{$Devices = Get-DeviceString -TypeDevices $_.Devices}
 try
  {
  switch($_.API)
   {
    "claymore"
      {
      Write-Host "Miner $MinerType is claymore api"
      Write-Host "Miner Port is $Port"    
      $Request = Invoke-WebRequest "http://$($server):$($port)" -UseBasicParsing -TimeoutSec 10
      $Data = $Request.Content.Substring($Request.Content.IndexOf("{"), $Request.Content.LastIndexOf("}") - $Request.Content.IndexOf("{") + 1) | ConvertFrom-Json
      $Hash = $Data.result[3] -split ";"
      for($i=0;$i -lt $Devices.Count; $i++){$GPU = $Devices[$i]; $GPUHashrates[$GPU] = $Hash[$i]}
      $ACC = $Data.result[2] -split ";" | Select -skip 1 -first 1
      $REJ = $Data.result[2] -split ";" | Select -skip 2 -first 1
      $KHS += $Data.result[2] -split ";" | Select -First 1 | foreach {[Double]$_/1000}
      $UPTIME = $Data.result[1] | Select -first 1 | foreach {[Double]$_*60}
      $A = $Data.result[6] -split ";"
      $temp = $true
      for($i=0; $i -lt $A.count; $i++){if($temp -eq $true){$A[$i] = "$($A[$i])T"; $temp=$false; continue}if($temp -eq $false){$A[$i] = "$($A[$i])F"; $temp=$true; continue}} 
      $FanSelect = $A | Select-String "F" | foreach {$_ -replace "F"}
      $TempSelect = $A | Select-String "T"| foreach {$_ -replace "T"}
      for($i=0;$i -lt $Devices.Count; $i++){$GPU = $Devices[$i]; $GPUFans[$GPU] = $FanSelect[$i]}
      for($i=0;$i -lt $Devices.Count; $i++){$GPU = $Devices[$i]; $GPUTemps[$GPU] = $TempSelect[$i]}      
      $ALGO = $MinerAlgo
      $RAW = 0
      $Hash = $Hash | % {iex $_}
      $Hash | foreach {$RAW += $_}
      $RAW | Set-Content ".\build\txt\$MinerType-hash.txt"
      }
   "ewbf"
      {
       Write-Host "Miner $MinerType is ewbf api"
       Write-Host "Miner Port is $Port"  
       $Message = @{id = 1; method = "getstat"} | ConvertTo-Json -Compress
       $Client = New-Object System.Net.Sockets.TcpClient $server, $port
       $Writer = New-Object System.IO.StreamWriter $Client.GetStream()
       $Reader = New-Object System.IO.StreamReader $Client.GetStream()
       $client.SendTimeout = 10000
       $client.ReceiveTimeout = 10000
       $Writer.AutoFlush = $true
       $Writer.WriteLine($Message)
       $Request = $Reader.ReadLine()
       $Data = $Request | ConvertFrom-Json
       $Data = $Data.result
       for($i=0;$i -lt $Devices.Count; $i++){$GPU = $Devices[$i]; $GPUHashrates[$GPU] = $Data.speed_sps[$i]} 
       $ACC = 0; $Data.accepted_shares | Foreach {$ACC += $_}
       $REJ = 0; $Data.rejected_shares | Foreach {$REJ += $_}
       $Data.speed_sps | foreach {$KHS += [Double]$_/1000}
       $UPTIME = ((Get-Date) - [DateTime]$Data.start_time[0]).seconds
       for($i=0;$i -lt $Devices.Count; $i++){$GPU = $Devices[$i]; $GPUTemps[$GPU] = $Data.temperature[$i]} 
       for($i=0;$i -lt $Devices.Count; $i++){$GPU = $Devices[$i]; $GPUFans[$GPU] = ""} 
       $ALGO = $MinerAlgo
       $RAW = 0
       $Hash = @()
       $Data.speed_sps | foreach {$Hash += $_}
       $Hash = $Hash | % {iex $_}
       $Hash | foreach {$RAW += $_}
       $RAW | Set-Content ".\build\txt\$MinerType-hash.txt"
      }
    "ccminer" 
      {
        Write-Host "Miner $MinerType is ccminer api"
        Write-Host "Miner Port is $Port"  
        $GetSummary = Get-TCP -Server $Server -Port $port -Message "summary"
        $GetThreads = Get-TCP -Server $Server -Port $port -Message "threads"
        $Data = $GetThreads -split "\|"
        $Hash = $Data -split ";" | Select-String "KHS" | foreach {$_ -replace ("KHS=","")}
        $Mfan = $Data -split ";" | Select-String "FAN" | foreach {$_ -replace ("FAN=","")}
        $MTemp = $Data -split ";" | Select-String "TEMP" | foreach {$_ -replace ("TEMP=","")}
        $ACC = $GetSummary -split ";" | Select-String "ACC=" | foreach{$_ -replace ("ACC=","")}
        $REJ = $GetSummary -split ";" | Select-String "REJ=" | foreach{$_ -replace ("REJ=","")}
        $UPTIME = $GetSummary -split ";" | Select-String "UPTIME=" | foreach{$_ -replace ("UPTIME=","")}
        $ALGO = $GetSummary -split ";" | Select-String "ALGO=" | foreach{$_ -replace ("ALGO=","")}
        for($i=0;$i -lt $Devices.Count; $i++){$GPU = $Devices[$i]; $GPUHashrates[$GPU] = $Hash[$i]}
        for($i=0;$i -lt $Devices.Count; $i++){$GPU = $Devices[$i]; $GPUFans[$GPU] = $Mfan[$i]}
        for($i=0;$i -lt $Devices.Count; $i++){$GPU = $Devices[$i]; $GPUTemps[$GPU] = $MTemp[$i]}
        $RAW = 0
        $Hash = $Hash | % {iex $_}
        $Hash | foreach {$RAW += $_*1000; $KHS += $_}
        $RAW | Set-Content ".\build\txt\$MinerType-hash.txt"      
      }
    "trex"
     {
      Write-Host "Miner $MinerType is trex api"
      Write-Host "Miner Port is $Port"  
      $Request = Invoke-WebRequest "http://$($server):$($port)/summary" -UseBasicParsing -TimeoutSec 10
      $Data = $Request.Content | ConvertFrom-Json
      for($i=0;$i -lt $Devices.Count; $i++){$GPU = $Devices[$i]; $GPUHashrates[$GPU] = $Data.gpus.hashrate_minute[$i]} 
      $ACC = 0; $Data.accepted_count | Foreach {$ACC += $_}
      $REJ = 0; $Data.rejected_count | Foreach {$REJ += $_}
      $KHS = [Double]$Data.hashrate_minute/1000
      $UPTIME = $Data.uptime
      for($i=0;$i -lt $Devices.Count; $i++){$GPU = $Devices[$i]; $GPUTemps[$GPU] = $Data.gpus.temperature[$i]} 
      for($i=0;$i -lt $Devices.Count; $i++){$GPU = $Devices[$i]; $GPUFans[$GPU] = $Data.gpus.fan_speed[$i]} 
      $ALGO = $Data.Algorithm
      $RAW = $Data.hashrate_minute
      $RAW | Set-Content ".\build\txt\$MinerType-hash.txt"      
     }
    "dstm" 
      {
        Write-Host "Miner $MinerType is dstm api"
        Write-Host "Miner Port is $Port"
        $GetSummary = Get-TCP -Server $Server -Port $port -Message "summary"
        $Data = $GetSummary | ConvertFrom-Json
        $Data = $Data.result       
        for($i=0;$i -lt $Devices.Count; $i++){$GPU = $Devices[$i]; $GPUHashrates[$GPU] = $Data.sol_ps[$i]} 
        $REJ = 0; $Data.rejected_shares | Foreach {$REJ += $_}
        $ACC = 0; $Data.accepted_shares | Foreach {$ACC += $_}
        $Data.speed_sps | foreach {$KHS += [Double]$_/1000}
        for($i=0;$i -lt $Devices.Count; $i++){$GPU = $Devices[$i]; $GPUTemps[$GPU] = $Data.temperature[$i]} 
        for($i=0;$i -lt $Devices.Count; $i++){$GPU = $Devices[$i]; $GPUFans[$GPU] = ""} 
        $ALGO = $MinerAlgo
        $RAW = 0
        $Hash = @()
        $Data.sol_ps | foreach {$Hash += $_}
        $Hash = $Hash | % {iex $_}
        $Hash | foreach {$RAW += $_}
        $RAW | Set-Content ".\build\txt\$MinerType-hash.txt" 
      }


    }
  }catch{$RAW = 0; $GPUHashRates | foreach {$RAW += $_}}
 }
elseif($_.Type -eq "CPU")
{
 $Server = "localhost"
 $Interval = 15
 $Port = $($_.Port)
 $MinerType = $($_.Type)
 try
 {
 switch($_.API)
  {   
  "cpuminer" 
   {
    Write-Host "Miner $MinerType is cpuminer api"
    Write-Host "Miner Port is $Port"
    $GetThreads = Get-TCP -Server $Server -Port $Port -Message "threads"
    $GetSummary = Get-TCP -Server $Server -Port $Port -Message "summary"
    $Hash = $GetThreads -split "="
    $Hash = $Hash -split "\|" | Select-String "\."
    for($i=0;$i -lt $GetDevices.Count; $i++){$GPU = $GetDevices[$i]; $CPUHashrates[$GPU] = $Hash[$i]}
    $CPUACC = $GetSummary -split ";" | Select-String "ACC=" | foreach{$_ -replace ("ACC=","")}
    $CPUREJ = $GetSummary -split ";" | Select-String "REJ=" | foreach{$_ -replace ("REJ=","")}
    $CPUKHS = $GetSummary -split ";" | Select-String "KHS=" | foreach{$_ -replace ("KHS=","")}
    $CPURAW = ([Double]$KHS*1000)
    $CPUUPTIME = $GetSummary -split ";" | Select-String "UPTIME=" | foreach{$_ -replace ("UPTIME=","")}
    $CPUALGO = $GetSummary -split ";" | Select-String "ALGO=" | foreach{$_ -replace ("ALGO=","")}
    $CPUTEMP = $GetSummary -split ";" | Select-String "TEMP=" | foreach{$_ -replace ("TEMP=","")}
    $CPUFAN = $GetSummary -split ";" | Select-String "FAN=" | foreach{$_ -replace ("FAN=","")}
    $CPUHashRates = @()
    $RAW | Set-Content ".\build\txt\$MinerType-hash.txt"
    $Hash = $Hash | % {iex $_}
    $Hash | foreach {$RAW += $_}
    $Hash | foreach {$CPUHashRates += "GPU=$_"}
    }
   }
  }catch{}
 }
}

if($CPUOnly -eq $true)
{
$HIVE="
$($CPUHashRates -join "`n")
KHS=$CPUKHS
ACC=$CPUACC
REJ=$CPUREJ
ALGO=$CPUALGO
TEMP=$CPUTEMP
FAN=$CPUFAN
UPTIME=$CPUUPTIME
"
$Hive
$Hive | Set-Content ".\build\bash\hivestats.sh"
}

else
{
  $HashRates = @()
  $Fans = @()
  $Temps = @()
  $GPUHashrates = $GPUHashrates | % {iex $_}
  $GPUHashrates | foreach {$HashRates += "GPU=$_" }
  $GPUFans | Foreach {$Fans += "FAN=$_" }
  $GPUTemps | Foreach {$Temps += "TEMP=$_" }

$HIVE="
$($HashRates -join "`n")
KHS=$KHS
ACC=$ACC
REJ=$REJ
ALGO=$ALGO
$($Fans -join "`n")
$($Temps -join "`n")
UPTIME=$UPTIME
"
$Hive
$Hive | Set-Content ".\build\bash\hivestats.sh"

}
if($BackgroundTimer.Elapsed.TotalSeconds -gt 120){Clear-Content ".\build\bash\hivestats.sh"; $BackgroundTimer.Restart()}
Start-Sleep -S 10
if($Platforms -eq "windows"){Clear-Host}
}

#echo $stats
#uptime: load averages for the past 1, 5, and 15 minutes
#[[ ! -z $META ]] && meta="$META" || meta='null'
##--arg rig_id "$RIG_ID" \
##--arg passwd "$RIG_PASSWD" \
##--arg miner "$MINER" \
##--argjson meta "$meta" \
##--argjson miner_stats "$stats" \
##--arg total_khs "$khs" \
##--argjson temp "$temp" \
##--argjson fan "$fan" \
##--argjson power "$power" \
##--arg df "`df -h / | awk '{ print $4 }' | tail -n 1 | sed 's/%//'`" \
##--argjson mem "`free -m | grep 'Mem' | awk '{print "["$2","$4"]"}'`" \
##--argjson cpuavg "[`uptime | awk -F': ' '{print $2}'`]" \
##'{
  ##"method": "stats", "jsonrpc": "2.0", "id": 0,
  ##"params": {
    ##$rig_id, $passwd, $miner, $meta, $miner_stats, $total_khs,
    #$temp, $fan, $power, $df, $mem, $cpuavg
  #}
#}'

#$response = Invoke-RestMethod "https://HiveOS.Farm/worker/api -Method Put -Body $json -ContentType 'application/json'
#{"method":"stats","jsonrpc":"2.0","id":0,"params":{"rig_id":"","passwd":"","miner":"custom","meta":{"custom":{"coin":"RVN"}},"miner_stats":{"hs":[0,0,0,0,0,0,0,0,0,0,0,0,0],"hs_units":"khs","temp":[56,58,54,0,0,0,59,0,0,57,44,0,0],"fan":[80,80,80,0,0,0,80,0,0,80,80,0,0],"uptime":"6\r,","ar":["0\r","0\r"],"algo":"tribus\r"},"total_khs":"0\r","temp":["0","62","63","61","49","47","46","64","54","45","64","54","51","44"],"fan":["0","80","80","80","80","80","80","80","80","80","80","80","80","80"],"power":["0","143","137","150","0","0","0","147","0","0","143","151","0","0"],"df":"196G","mem":[7681,1669],"cpuavg":[5.29,4.33,4.61]}}
