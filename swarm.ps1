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
    [String]$Wallet = "Yes",  ##Miner Can Load Pools
    [Parameter(Mandatory=$false)]
    [String]$Wallet1 = '1DRxiWx6yuZfN9hrEJa3BDXWVJ9yyJU36i',  ##Group 1 Wallet
    [Parameter(Mandatory=$false)]
    [String]$Wallet2 = '', ##Group 2 Wallet
    [Parameter(Mandatory=$false)]
    [String]$Wallet3 = '', ##Group 3 Wallet
    [Parameter(Mandatory=$false)]
    [String]$CPUWallet = '1DRxiWx6yuZfN9hrEJa3BDXWVJ9yyJU36i', ##CPU Wallet
    [Parameter(Mandatory=$false)]
    [String]$ZergpoolWallet1 = '', ##Group 1 Zergpool Wallet
    [Parameter(Mandatory=$false)]
    [String]$ZergpoolWallet2 = '', ##Group 2 Zergpool Wallet
    [Parameter(Mandatory=$false)]
    [String]$ZergpoolWallet3 = '', ##Group 3 Zergpool Wallet
    [Parameter(Mandatory=$false)]
    [String]$blockmastersWallet1 = '',  ##Group 1 BlockMasters Wallet
    [Parameter(Mandatory=$false)]
    [String]$blockmastersWallet2 = '',  ##Group 2 BlockMasters Wallet
    [Parameter(Mandatory=$false)]
    [String]$blockmastersWallet3 = '',  ##Group 3 BlockMasters Wallet
    [Parameter(Mandatory=$false)]
    [String]$Nicehash_Wallet1 = '',  ##Group 1 Nicehash Wallet
    [Parameter(Mandatory=$false)]
    [String]$Nicehash_Wallet2 = '',  ##Group 2 Nicehash Wallet
    [Parameter(Mandatory=$false)]
    [String]$Nicehash_Wallet3 = '',  ##Group 3 Nicehash Wallet
    [Parameter(Mandatory=$false)]
    [String]$nlWallet1 = '',  ##Group 3 Nicehash Wallet
    [Parameter(Mandatory=$false)]
    [String]$nlWallet2 = '',  ##Group 3 Nicehash Wallet
    [Parameter(Mandatory=$false)]
    [String]$nlWallet3 = '',  ##Group 3 Nicehash Wallet
    [Parameter(Mandatory=$false)]
    [String]$UserName = "MaynardVII", ##MPH Username
    [Parameter(Mandatory=$false)]
    [String]$WorkerName = "Rig1",  ##MPH Workername
    [Parameter(Mandatory=$false)]
    [String]$RigName1 = "MMHash",  ##ID=Rigname (Yiimp Pool) Group 1
    [Parameter(Mandatory=$false)]
    [String]$RigName2 = "MMHash",  ##ID=Rigname (Yiimp Pool) Group 2
    [Parameter(Mandatory=$false)]
    [String]$RigName3 = "MMHash", ##ID=Rigname (Yiimp Pool) Group 3
    [Parameter(Mandatory=$false)]
    [Int]$API_ID = 0, ##Future Implentation
    [Parameter(Mandatory=$false)]
    [String]$API_Key = "", ##Future Implementation
    [Parameter(Mandatory=$false)]
    [Int]$Timeout = 0,  ##Hours Before Mine Clears All Hashrates/Profit 0 files
    [Parameter(Mandatory=$false)]
    [Int]$Interval = 300, #seconds before reading hash rate from miners
    [Parameter(Mandatory=$false)] 
    [Int]$StatsInterval = 1, #seconds of current active to gather hashrate if not gathered yet 
    [Parameter(Mandatory=$false)]
    [String]$Location = "US", #europe/us/asia
    [Parameter(Mandatory=$false)]
    [String]$MPHLocation = "US", #europe/us/asia 
    [Parameter(Mandatory=$false)]
    [Array]$Type, #AMD/NVIDIA/CPU
    [Parameter(Mandatory=$false)]
    [String]$CCDevices1, ##Group 1 ccminer gpus
    [Parameter(Mandatory=$false)] 
    [String]$CCDevices2,  ##Group 2 ccminer gpus
    [Parameter(Mandatory=$false)]
    [String]$CCDevices3,  ##Group 3 ccminer gpus
    [Parameter(Mandatory=$false)]
    [String]$EWBFDevices1, ##Group 1 ewbf
    [Parameter(Mandatory=$false)] 
    [String]$EWBFDevices2, ##Group 2 ewbf
    [Parameter(Mandatory=$false)]
    [String]$EWBFDevices3, ##Group 3 ewbf
    [Parameter(Mandatory=$false)]
    [String]$GPUDevices1, ##Group 1 all miners
    [Parameter(Mandatory=$false)] 
    [String]$GPUDevices2, ##Group 2 all miners
    [Parameter(Mandatory=$false)]
    [String]$GPUDevices3, ##Group 3 all miners
    [Parameter(Mandatory=$false)]
    [String]$DSTMDevices1, 
    [Parameter(Mandatory=$false)] 
    [String]$DSTMDevices2,
    [Parameter(Mandatory=$false)]
    [String]$DSTMDevices3,
    [Parameter(Mandatory=$false)]
    [String]$ClayDevices1,
    [Parameter(Mandatory=$false)]
    [String]$ClayDevices2,
    [Parameter(Mandatory=$false)]
    [String]$ClayDevices3,
    [Parameter(Mandatory=$false)]
    [String]$RexDevices1,
    [Parameter(Mandatory=$false)]
    [String]$RexDevices2,
    [Parameter(Mandatory=$false)]
    [String]$RexDevices3,
    [Parameter(Mandatory=$false)]
    [String]$SGDevices1,
    [Parameter(Mandatory=$false)]
    [String]$SGDevices2,
    [Parameter(Mandatory=$false)]
    [String]$SGDevices3,
    [Parameter(Mandatory=$false)]
    [Array]$PoolName = ("zergpool_algo","zergpool_coin"), 
    [Parameter(Mandatory=$false)]
    [Array]$Currency = ("USD"), #i.e. GBP,EUR,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [Array]$Passwordcurrency = ("BTC"), #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [Array]$Passwordcurrency1 = ("BTC"), #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [Array]$Passwordcurrency2 = ("BTC"), #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [Array]$Passwordcurrency3 = ("BTC"), #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [Array]$CPUcurrency = ("BTC"), #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [String]$Zergpoolpassword1 = ("BTC"), #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [String]$Zergpoolpassword2 =  '', #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [String]$Zergpoolpassword3 = '', #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [String]$blockmasterspassword1 = ("BTC"), #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [String]$blockmasterspassword2 =  '', #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [String]$blockmasterspassword3 = '', #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [String]$nlpassword1 = '', #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [String]$nlpassword2 = '', #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [String]$nlpassword3 = '', #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [Int]$Donate = .5, #Percent per Day
    [Parameter(Mandatory=$false)]
    [String]$Proxy = "", #i.e http://192.0.0.1:8080 
    [Parameter(Mandatory=$false)]
    [Int]$Delay = 1, #seconds before opening each miner
    [Parameter(Mandatory=$false)]
    [String]$CoinExchange = "LTC",
    [Parameter(Mandatory=$false)]
    [array]$Coin= $null,
    [Parameter(Mandatory=$false)]
    [array]$GPU_Group1= $null,
    [Parameter(Mandatory=$false)]
    [array]$GPU_Group2= $null,
    [Parameter(Mandatory=$false)]
    [array]$GPU_Group3= $null,
    [Parameter(Mandatory=$false)]
    [string]$Auto_Coin = "Yes",
    [Parameter(Mandatory=$false)]
    [Int]$Nicehash_Fee = "2",
    [Parameter(Mandatory=$false)]
    [Int]$Benchmark = 120,
    [Parameter(Mandatory=$false)]
    [Int]$GPU_Count = 0,
    [Parameter(Mandatory=$false)]
    [array]$No_Algo = "myr-gr",
    [Parameter(Mandatory=$false)]
    [String]$Favor_Coins = "Yes",
    [Parameter(Mandatory=$false)]
    [double]$Threshold = .01,
    [Parameter(Mandatory=$false)]
    [string]$Platform = "linux",
    [Parameter(Mandatory=$false)]
    [int]$CPUThreads = 3,
    [Parameter(Mandatory=$false)]
    [string]$Stat_Coin = "Live",
    [Parameter(Mandatory=$false)]
    [string]$Stat_Algo = "Live",
    [Parameter(Mandatory=$false)]
    [string]$CPUOnly = "No",
    [Parameter(Mandatory=$false)]
    [string]$HiveOS = "Yes",
    [Parameter(Mandatory=$false)]
    [string]$Update = "No",
    [Parameter(Mandatory=$false)]
    [string]$Cuda = "9.1",
    [Parameter(Mandatory=$false)]
    [string]$Power = "Yes",
    [Parameter(Mandatory=$false)]
    [string]$WattOMeter = "No"
)

Set-Location (Split-Path $script:MyInvocation.MyCommand.Path)
Get-ChildItem . -Recurse -Force | Out-Null 
if($Platform -eq "Windows"){$Platform = "windows"}
if($Platform -eq "Linux"){$Platform = "linux"}
if($Platform -eq "windows"){
$Cuda = "9.2"
}

. .\build\powershell\killall.ps1
. .\build\powershell\startlog.ps1
. .\build\powershell\remoteupdate.ps1
. .\build\powershell\datafiles.ps1
. .\build\powershell\gpu-count.ps1
. .\build\powershell\algorithm.ps1
. .\build\powershell\statcommand.ps1
. .\build\powershell\poolcommand.ps1
. .\build\powershell\minercommand.ps1
. .\build\powershell\launchcode.ps1
. .\build\powershell\datefiles.ps1
. .\build\powershell\watchdog.ps1
. .\build\powershell\miners.ps1
. .\build\powershell\sorting.ps1
. .\build\powershell\download.ps1
. .\build\powershell\hashrates.ps1
. .\build\powershell\naming.ps1
. .\build\powershell\childitems.ps1
. .\build\powershell\powerup.ps1
if($Platform -eq "linux"){. .\build\powershell\getbestunix.ps1; . .\build\powershell\sexyunixlogo.ps1}
if($Platform -eq "windows"){. .\build\powershell\getbestwin.ps1; . .\build\powershell\sexywinlogo.ps1}


##filepath dir
$dir = (Split-Path $script:MyInvocation.MyCommand.Path)
$build = (Join-Path (Split-Path $script:MyInvocation.MyCommand.Path) "build")
$dir | set-content ".\build\bash\dir.sh"
$pwsh = (Join-Path (Split-Path $script:MyInvocation.MyCommand.Path) "build\powershell")
$bash = (Join-Path (Split-Path $script:MyInvocation.MyCommand.Path) "build\linux")
$windows = (Join-Path (Split-Path $script:MyInvocation.MyCommand.Path) "build\windows")
$data = (Join-Path (Split-Path $script:MyInvocation.MyCommand.Path) "build\data")
$txt = (Join-Path (Split-Path $script:MyInvocation.MyCommand.Path) "build\txt")

##Start The Log
start-log

##Start Kill-Script
if($Platform -eq "linux"){start-killscript}

##Version Information & Remote Update
if($platform -eq "linux")
{
$cuda | Out-file ".\build\txt\cuda.txt" -Force
start-update -Update $update
  if($HiveOS -eq "Yes"){
  Write-Host "Getting Data"
  Get-Data -CmdDir $dir
  }
}
Write-Host "HiveOS = $HiveOS"
#Startings Settings:
$BenchmarkMode = "No"
$Instance = 1
$InfoCheck1 = Get-Content "$data\conversion.ifx" -Force | Out-String
$VerifyCheck1 = Get-Content "$data\verification.ifx" -Force | Out-String
$InfoCheck2 = Get-Content "$data\conversion2.ifx" -Force | Out-String
$VerifyCheck2 = Get-Content "$data\verification2.ifx" -Force | Out-String
$InfoPass1 = $InfoCheck1
$InfoPass2 = $InfoCheck2
$VerifyPass1 = $VerifyCheck1
$VerifyPass2 = $VerifyCheck2 
$DecayStart = Get-Date
$DecayPeriod = 60 #seconds
$DecayBase = 1-0.1 #decimal percentage
$Deviation = $Donation
$WalletDonate = "1DRxiWx6yuZfN9hrEJa3BDXWVJ9yyJU36i"
$NicehashDonate = "3JfBiUZZV17DTjAFCnZb97UpBgtLPLLDop"
$UserDonate = "MaynardVII"
$WorkerDonate = "Rig1"
$WalletSwitch = $Wallet
$WalletSwitch1 = $Wallet1
$WalletSwitch2 = $Wallet2
$WalletSwitch3 = $Wallet3
$CPUWalletSwitch = $CPUWallet
$ZergpoolWallet1Switch = $ZergpoolWallet1
$ZergpoolWallet2Switch = $ZergpoolWallet2
$ZergpoolWallet3Switch = $ZergpoolWallet3
$PasswordSwitch = $Passwordcurrency
$PasswordSwitch1 = $Passwordcurrency1
$PasswordSwitch2 = $Passwordcurrency2
$PasswordSwitch3 = $Passwordcurrency3
$CPUcurrencySwitch = $CPUcurrency
$Zergpoolpassword1Switch = $Zergpoolpassword1
$Zergpoolpassword2Switch = $Zergpoolpassword2
$Zergpoolpassword3Switch = $Zergpoolpassword3
$Nicehash_Wallet1Switch = $Nicehash_Wallet1
$Nicehash_Wallet2Switch = $Nicehash_Wallet2
$Nicehash_Wallet3Switch = $Nicehash_Wallet3
$UserSwitch = $UserName
$WorkerSwitch = $WorkerName
$RigSwitch = $RigName
$IntervalSwitch = $Interval
$ActiveMinerPrograms = @()

#Timers
$TimeoutTimer = New-Object -TypeName System.Diagnostics.Stopwatch
$TimeoutTimer.Start()
$logtimer = New-Object -TypeName System.Diagnostics.Stopwatch
$logtimer.Start()

##Load Previous Times & PID Data
Get-DateFiles

##Remove Exclusion
try{if((Get-MpPreference).ExclusionPath -notcontains (Convert-Path .)){Start-Process powershell -Verb runAs -ArgumentList "Add-MpPreference -ExclusionPath '$(Convert-Path .)'"}}catch{}

##Proxy
if($Proxy -eq ""){$PSDefaultParameterValues.Remove("*:Proxy")}
else{$PSDefaultParameterValues["*:Proxy"] = $Proxy}

##Check for lib & restart agent
if($Platform -eq "linux" -and $HiveOS -eq "Yes")
{
Start-Process ".\build\bash\libc.sh" -wait
Start-Process ".\build\bash\libv.sh" -wait
start-process "screen" -ArgumentList "-S agent -X quit" -wait
start-process "agent-screen" -wait
}

if($Platform -eq "linux")
 {
#Start Watchdog
start-watchdog
 }
elseif($Platform -eq "windows"){$PID | Set-Content ".\build\pid\miner_pid.txt"}

##Threads
$GPU_Count = Get-GPUCount -DeviceType $Type -CmdDir $Dir
if($GPU_Count -ne 0){$GPUCount = @(); for($i=0; $i -lt $GPU_Count; $i++){[string]$GPUCount += "$i,"}}
if($CPUThreads -ne 0){$CPUCount = @(); for($i=0; $i -lt $CPUThreads; $i++){[string]$CPUCount += "$i,"}}
if($GPU_Count -eq 0){$Device_Count = $CPUThreads}
else{$Device_Count = $GPU_Count}
Write-Host "Device Count = $Device_Count" -foregroundcolor green
Start-Sleep -S 2
if($GPUCount -ne $null){$LogGPUS = $GPUCount.Substring(0,$GPUCount.Length-1)}
if($CPUThreads -ne 0 -and $GPU_Count -eq 0){$LogGPUS = $CPUCount.Substring(0,$CPUCount.Length-1)}
elseif($CPUThreads -ne 0 ){$LogGPUS = $CPUCount.Substring(0,$CPUCount.Length-1)}

##GPU Count & Miner Type
if($Platform -eq "linux" -and $HiveOS -eq "Yes")
{
$Type | Foreach {
if($_ -eq "NVIDIA1"){
"NVIDIA1" | Out-File ".\build\bash\minertype.sh" -Force
Write-Host "Group 1 is NVIDIA- Commands and Stats will work for NVIDIA1" -foreground yellow
Start-Sleep -S 3
}
if($_ -eq "AMD1"){
"AMD1" | Out-File ".\build\bash\minertype.sh" -Force
Write-Host "Group 1 is AMD- Commands and Stats will work for AMD1" -foreground yellow
Start-Sleep -S 3
}
if($_ -eq "CPU"){
if($GPU_Count -eq 0){
"CPU" | Out-File ".\build\bash\minertype.sh" -Force
Write-Host "Group 1 is CPU- Commands and Stats will work for CPU" -foreground yellow
Start-Sleep -S 3
   }
  }
 }
}


##Reset-Old Stats
if(Test-Path "stats"){Get-ChildItemContent "stats" | ForEach {$Stat = Set-Stat $_.Name $_.Content.Week}}

##Logo
if($Platform -eq "windows"){Get-SexyWinLogo}
elseif($Platform -eq "linux"){Get-SexyUnixLogo}
 
#Get-Algorithms
$Algorithm = @()
$NeedsToBeBench = $false
$Algorithm = Get-Algolist -Devices $Type -No_Algo $No_Algo

#Get-Update Files
if($Type -like "*CPU*"){$cpu = get-minerfiles -Types "CPU" -Platforms $Platform}
if($Type -like "*NVIDIA*"){$nvidia = get-minerfiles -Types "NVIDIA" -Platforms $Platform -Cudas $Cuda}
if($Type -like "*AMD*"){$amd = get-minerfiles -Types "AMD" -Platforms $Platform}

While($true)
{
##Reset Coins
$CoinAlgo = $null  
##Get Watt Configuration
$Watts = get-content ".\config\power\power.conf" | ConvertFrom-Json
##Check Time Parameters
$MinerWatch = New-Object -TypeName System.Diagnostics.Stopwatch
$TimeoutTime = [int]$Timeout*3600
$DecayExponent = [int](((Get-Date)-$DecayStart).TotalSeconds/$DecayPeriod)
$TimeDeviation = [int]($Deviation + 1.40)
$InfoCheck = Get-Content ".\build\data\info.txt" -Force | Out-String
$DonateCheck = Get-Content ".\build\data\system.txt" -Force | Out-String
$LastRan = Get-Content ".\build\data\timetable.txt" -Force | Out-String
 
if($TimeDeviation -ne 0)
{
$DonationTotal = (864*[int]$TimeDeviation)
$DonationIntervals = ([int]$DonationTotal/288)
$FinalDonation = (86400/[int]$DonationIntervals)
 if($LastRan -eq "")
 {
  Get-Date | Out-File ".\build\data\timetable.txt"
  Continue
 }
 if($LastRan -ne "")
 {
 $RanDonate = [DateTime]$LastRan
 $LastRanDonated = [math]::Round(((Get-Date)-$RanDonate).TotalSeconds)
  if($LastRanDonated -ge 86400)
  {
  Clear-Content ".\build\data\timetable.txt" -Force
  Get-Date | Out-File ".\build\data\timeTable.txt"
  Continue
  }
 }

 if($LastRan -ne "")
 {
 $LastRanDonate = [DateTime]$LastRan
 $LastTimeActive = [math]::Round(((Get-Date)-$LastRanDonate).TotalSeconds)
  if($LastTimeActive -ge 1) 
  {
  if($DonateCheck -eq "")
  {
  Get-Date | Out-File ".\build\data\system.txt"
  Continue
  }
  $Donated = [DateTime]$DonateCheck
  $CurrentlyDonated = [math]::Round(((Get-Date)-$Donated).TotalSeconds)
  if($CurrentlyDonated -ge [int]$FinalDonation)
  {
   $Wallet = $InfoPass1
   $Wallet1 = $InfoPass1
   $Wallet2 = $InfoPass1
   $Wallet3 = $InfoPass1
   $CPUWallet = $InfoPass1
   $ZergpoolWallet1 = $InfoPass1
   $ZergpoolWallet2 = $InfoPass1
   $ZergpoolWallet3 = $InfoPass1
   $blockmastersWallet1 = $InfoPass1
   $blockmastersWallet2 = $InfoPass1
   $blockmastersWallet3 = $InfoPass1
   $Nicehash_Wallet1 = $VerifyPass1
   $Nicehash_Wallet2 = $VerifyPass1
   $Nicehash_Wallet3 = $VerifyPass1
   $UserName = $InfoPass2
   $WorkerName = $VerifyPass2
   $RigName = "DONATING!!!"
   $Interval = 288
   $Passwordcurrency = ("BTC")
   $Passwordcurrency1 = ("BTC")
   $Passwordcurrency2 = ("BTC")
   $Passwordcurrency3 = ("BTC")
   $CPUcurrency = ("BTC")
   $Zergpoolpassword1 = ("BTC")
   $Zergpoolpassword2 = ("BTC")
   $Zergpoolpassword3 = ("BTC")
   $blockmasterspassword1 = ("BTC")
   $blockmasterspassword2 = ("BTC")
   $blockmasterspassword3 = ("BTC")

   if(($InfoCheck) -eq ""){Get-Date | Out-File ".\build\data\info.txt"}
     Clear-Content ".\build\data\system.txt" -Force
     Get-Date | Out-File ".\build\data\system.txt"
     Start-Sleep -s 1
     Write-Host  "Entering Donation Mode" -foregroundColor "darkred"
     Continue
    }
  }

 if($InfoCheck -ne "")
  {
     $TimerCheck = [DateTime]$InfoCheck
     $LastTimerCheck = [math]::Round(((Get-Date)-$LastRanDonate).TotalSeconds)
     if(((Get-Date)-$TimerCheck).TotalSeconds -ge $Interval)
      {
        $Wallet = $WalletSwitch
        $Wallet1 = $WalletSwitch1
        $Wallet2 = $WalletSwitch2
	      $Wallet3 = $WalletSwitch3
        $ZergpoolWallet1 = $ZergpoolWallet1Switch
        $ZergpoolWallet2 = $ZergpoolWallet2Switch
        $ZergpoolWallet3 = $ZergpoolWallet3Switch
        $Nicehash_Wallet1 = $Nicehash_Wallet1Switch
        $Nicehash_Wallet2 = $Nicehash_Wallet2Switch
        $Nicehash_Wallet3 = $Nicehash_Wallet3Switch
        $CPUWallet = $CPUWalletSwitch
      	$UserName = $UserSwitch
	      $WorkerName = $WorkerSwitch
      	$RigName = $RigSwitch
        $Interval = $IntervalSwitch
        $Passwordcurrency = $PasswordSwitch
      	$Passwordcurrency1 = $PasswordSwitch1
        $Passwordcurrency2 = $PasswordSwitch2
        $Passwordcurrency3 = $PasswordSwitch3
        $Zergpoolpassword1 = $Zergpoolpassword1Switch
        $Zergpoolpassword2 = $Zergpoolpassword2Switch
        $Zergpoolpassword3 = $Zergpoolpassword3Switch
        $CPUcurrency = $CPUcurrencySwitch
	      Clear-Content ".\build\data\info.txt" -Force
	      Write-Host "Leaving Donation Mode- Thank you For The Support!" -foregroundcolor "darkred"
	      Continue
       }
     }
   }
  }

##Get Price Data
try {
$R= [string]$Currency
Write-Host "SWARM Is Building The Database. Auto-Coin Switching: $Auto_Coin" -foreground "yellow"
$Rates = Invoke-RestMethod "https://api.coinbase.com/v2/exchange-rates?currency=BTC" -UseBasicParsing | Select-Object -ExpandProperty data | Select-Object -ExpandProperty rates
$Currency | Where-Object {$Rates.$_} | ForEach-Object {$Rates | Add-Member $_ ([Double]$Rates.$_) -Force}
$WattCurr = (1/$Rates.$Currency)
$WattEx = [Double](($WattCurr*$Watts.KWh.KWh))
}
catch {
Write-Host -Level Warn "Coinbase Unreachable. "
Write-Host -ForegroundColor Yellow "Last Refresh: $(Get-Date)"
Write-host "Trying To Contact Cryptonator.." -foregroundcolor "Yellow"
$Rates = [PSCustomObject]@{}
$Currency | ForEach {$Rates | Add-Member $_ (Invoke-WebRequest "https://api.cryptonator.com/api/ticker/btc-$_" -UseBasicParsing | ConvertFrom-Json).ticker.price}
}


##Load File Stats
if($TimeoutTimer.Elapsed.TotalSeconds -lt $TimeoutTime -or $Timeout -eq 0){$Stats = Get-Stats -Timeouts "No"}
else
{
 Get-Stats -Timeouts "Yes"
 $TimeoutTimer.Restart()
 continue
}

##GetPools
Write-Host "Checking Algo Pools" -Foregroundcolor yellow
$AllAlgoPools = Get-Pools -PoolType "Algo" -Stats $Stats
$AlgoPools = [PSCustomObject]@{}
$AlgoPools_Comparison = [PSCustomObject]@{}
$AllAlgoPools.Symbol | Select -Unique | ForEach {$AlgoPools | Add-Member $_ ($AllAlgoPools | Where Symbol -EQ $_ | Sort-Object Price -Descending | Select -First 1)}
$AllAlgoPools.Symbol | Select -Unique | ForEach {$AlgoPools_Comparison | Add-Member $_ ($AllAlgoPools | Where Symbol -EQ $_ | Sort-Object StablePrice -Descending | Select -First 1)}

##Load Only Needed Algorithm Miners
Write-Host "Checking Algo Miners"
$AlgoMiners = Get-Miners -Platforms $Platform -Stats $Stats -Pools $AlgoPools

##Re-Name Instance In Case Of Crashes
$AlgoMiners | ForEach {
$AlgoMiner = $_
if(-not (Test-Path $AlgoMiner.path))
{
 if(Test-Path (Split-Path $Algominer.Path))
 {
  Set-Location (Split-Path $AlgoMiner.Path)
  if(Test-Path "*$($_.Type)*")
  {
  $OldInstance = Get-ChildItem "*$($AlgoMiner.Type)-*"
  Rename-Item $OldInstance -NewName "$($AlgoMiner.MinerName)" -force
  }
  Set-Location $Dir
 }
}
}

$Download = $false

##Download Miners
$AlgoMiners = $AlgoMiners | ForEach {
$AlgoMiner = $_
 if((Test-Path $_.Path) -eq $false)
 {
  Expand-WebRequest -URI $AlgoMiner.URI -BuildPath $AlgoMiner.BUILD -Path (Split-Path $AlgoMiner.Path) -MineName (Split-Path $AlgoMiner.Path -Leaf) -MineType $AlgoMiner.Type
  $Download = $true
 }
 else{$AlgoMiner}
}

if($AlgoMiners.Count -eq 0){"No Miners!" | Out-Host; start-sleep $Interval; continue}
if($Download -eq $true){continue}

##Sort Algorithm Miners
start-minersorting -Command "Algo" -Stats $Stats -Pools $AlgoPools -Pools_Comparison $AlgoPools_Comparison -SortMiners $AlgoMiners -DBase $DecayBase -DExponent $DecayExponent -WattCalc $WattEx
$GoodAlgoMiners = @()
$ActiveMinerPrograms | ForEach {$AlgoMiners | Where Path -EQ $_.Path | Where Arguments -EQ $_.Arguments | ForEach {$_.Profit_Bias = $_.Profit}}
$AlgoMiners | Foreach {if($_.Profit -lt $Threshold -or $_.Profit -eq $null){$GoodAlgoMiners += $_}}
$Miners = @()
$GoodAlgoMiners | foreach {$Miners += $_}
if($Platform -eq "windows"){$BestAlgoMiners_Combo = Get-BestWin -SortMiners $AlgoMiners}
elseif($Platform -eq "linux"){$BestAlgoMiners_Combo = Get-BestUnix -SortMiners $AlgoMiners}
$BestMiners_Combo = $BestAlgoMiners_Combo

#check if Auto_Coin is working- Start Coin Sorting
if($Auto_Coin -eq "Yes")
{
##Determine Benchmark Mode
$NeedsToBeBench = $false
$BestAlgoMiners_Combo | foreach {if($_.Profit -eq $null){$NeedsToBeBench = $true; Write-Host "Coins Disabled - Benchmarking Required." -foreground yellow}}

if($NeedsToBeBench -eq $false)
{ 
#Get Specfic Coin Algorithms
$CoinAlgo = $Algorithm
Write-Host "CoinPools Are Active: Searching For Coins" -ForegroundColor Magenta

#Load Coin Pools
$AllCoinPools = Get-Pools -PoolType "Coin" -Stats $Stats
$CoinPools = [PSCustomObject]@{}
$CoinPools_Comparison = [PSCustomObject]@{}
$AllCoinPools.Symbol | Select -Unique | ForEach {$CoinPools | Add-Member $_ ($AllCoinPools | Where Symbol -EQ $_)}
$AllCoinPools.Symbol | Select -Unique | ForEach {$CoinPools_Comparison | Add-Member $_ ($AllCoinPools | Where Symbol -EQ $_)}

#Load Coin Miners
$CoinMiners = Get-Miners -Platforms $Platform -Stats $Stats -Pools $CoinPools
if($CoinMiners -ne $null){start-minersorting -Command "Coin" -Stats $Stats -Pools $CoinPools -Pools_Comparison $CoinPools_Comparison -SortMiners $CoinMiners -DBase $DecayBase -DExponent $DecayExponent -WattCalc $WattEx}
$Miners = @()
if($BestAlgoMiners_Combo.MinerPool -like "*algo*")
{
 if($Favor_Coins -eq "Yes"){Write-Host "User Specified To Favor Coins & Best Pool Is CoinPool: Factoring Only Coins";$Miners = $CoinMiners | Where Profit -lt $Threshold}
 else{$Miners = $CoinMiners | Where Profit -lt $Threshold;$BestAlgoMiners_Combo | foreach {$Miners += $_}}
}
else{$Miners = $CoinMiners | Where Profit -lt $Threshold; $BestAlgoMiners_Combo | foreach {$Miners += $_}}

$ActiveMinerPrograms | ForEach {$Miners | Where Path -EQ $_.Path | Where Arguments -EQ $_.Arguments | ForEach {$_.Profit_Bias = $_.Profit}}
if($Platform -eq "windows"){$BestMiners_Combo = Get-BestWin -SortMiners $Miners}
elseif($Platform -eq "linux"){$BestMiners_Combo = Get-BestUnix -SortMiners $Miners}

if($Favor_Coins -eq "Yes")
{
$Miners = @()
$NewCoinSymbol = @()
$ProfitsArray = @()
$NewCoinAlgo = @()

$BestMiners_Combo | Foreach {$NewCoinSymbol += [PSCustomObject]@{"$($_.Type)" = "$($_.Symbol)"}}  
$BestMiners_Combo | Foreach {$NewCoinAlgo += [PSCustomObject]@{"$($_.Type)" = "$($_.Algo)"}}  
$BestMiners_Combo | Foreach {$ProfitsArray += [PSCustomObject]@{"$($_.Type)" = $($_.Profit)}}

$Type | Foreach {
$Selected = $_
$TypeAlgoMiners = $GoodAlgoMiners | Where Type -eq $Selected
 $TypeAlgoMiners | Foreach{
  if($NewCoinSymbol.$($_.Type) -ceq $($_.Symbol)){$Miners += $_}
  else
  {
   if($NewCoinAlgo.$($_.Type) -cne $($_.Algo))
   {
   if($ProfitsArray.$($_.Type) -gt $($_.Profit)){$Miners += $_}
   }
  }
 }
}
$CoinMiners | foreach {$Miners += $_}
}

 else{$Miners = @(); $GoodAlgoMiners | foreach {$Miners += $_}; $CoinMiners | foreach {$Miners += $_}}
 }
}

##Write On Screen Best Choice  
$BestMiners_Selected = $BestMiners_Combo.Symbol
$BestPool_Selected = $BestMiners_Combo.MinerPool 
Write-Host "Most Ideal Choice Is $($BestMiners_Selected) on $($BestPool_Selected)" -foregroundcolor green          

 ##Build Stats Table
 $ProfitTable = $null
 $ProfitTable = @()
 $Miners | foreach {
 $ProfitTable += [PSCustomObject]@{
  Power = [Decimal]$($_.Power*24)/1000*$WattEX
  Type = $_.Type
  Miner = $_.Name
  Name = $($_.Symbol)
  Arguments = $($_.Arguments)
  HashRates = $_.HashRates.$($_.Symbol)
  Profits = $_.Profit_Bias
  Algo = $_.Algo
  Fullname = $_.FullName
  MinerPool = $_.MinerPool
 }
}

##Add Instance Settings To Miners For Tracking
$BestMiners_Combo | ForEach {
 if(-not ($ActiveMinerPrograms | Where Path -eq $_.Path | Where Arguments -eq $_.Arguments ))
  {
   if($_.Type -eq "CPU" -and $GPU_Count -eq 0){$LogType = $LogGPUS}
   elseif($_.Type -eq "CPU" -and $GPU_Count -ne 0){$LogType = $LogCPUS}
   elseif($_.Devices -eq $null){$LogType = $LogGPUS}
   elseif($_.Devices -ne $null){$LogType = $_.Devices}
  $ActiveMinerPrograms += [PSCustomObject]@{
   Name = $_.Name
   Type = $_.Type
   Devices = $_.Devices
   DeviceCall = $_.DeviceCall
	 MinerName = $_.MinerName
   Path = $_.Path
   Arguments = $_.Arguments
   API = $_.API
   Port = $_.Port
   Coins = $_.Symbol
   Active = [TimeSpan]0
   Activated = 0
   Status = "Idle"
   HashRate = 0
   Benchmarked = 0
   Timeout = 0
   WasBenchmarked = $false
   XProcess = $null
   MinerPool = $_.MinerPool
   Algo = $_.Algo
   Bad_Benchmark = 0
   FullName = $_.FullName
   Instance = $null
   InstanceNumber = $null
   Username = $_.Username
   Connection = $_.Connection
   Password = $_.Password
   BestMiner = $false
   JsonFile = $_.Config
   LogGPUS = $LogType
  }
 }
}

$Restart = $false
$NoMiners = $false


#Determine Which Miner Should Be Active
$BestActiveMiners = @()
$ActiveMinerPrograms | foreach {
if($BestMiners_Combo | Where Path -EQ $_.Path | Where Arguments -EQ $_.Arguments){$_.BestMiner = $true; $BestActiveMiners += $_}
else{$_.BestMiner = $false}
}

$BestActiveMiners | ConvertTo-Json | Out-File ".\build\txt\bestminers.txt"

if($Platform -eq "windows")
{
 $background = ".\build\pid\background_pid.txt"
 if(Test-Path $background)
  {
   $bprocess = Get-Content $background
   if(Get-Process -id $bprocess -ErrorAction SilentlyContinue){Stop-Process -id $bprocess; remove-item $background}
  }
 Start-Background -WorkingDir $pwsh -Dir $dir -Platforms $Platform
}
elseif($Platform -eq "linux")
 {
  Start-Process ".\build\bash\killall.sh" -ArgumentList "background" -Wait
  Start-Sleep -S .25
  Start-Process "screen" -ArgumentList "-S background -d -m" -Wait
  Start-Sleep -S .25
  Start-Process ".\build\bash\background.sh" -ArgumentList "background $dir $Platform" -Wait
 }

##Handle Miners Open/Not Active
$ActiveMinerPrograms | foreach {
 if($_.BestMiner -eq $false)
  {
  if($_.XProcess.HasExited -and $_.Status -eq "Running"){$_.Status = "Failed"}
  else
   {
    $_.Status = "Idle"
    $PIDDate = ".\build\pid\$($_.Instance)_date.txt"
    if(Test-path $PIDDate)
    {
     $PIDDateFile = Get-Content $PIDDate | Out-String
     $PIDTime = [DateTime]$PIDDateFile
     $_.Active += (Get-Date)-$PIDTime
     if($Platform -eq "windows"){$_.XProcess.CloseMainWindow(); Start-Sleep -S $Delay}
    }
   }
  }
##Launch Best Miners
else
{
if($TimeDeviation -ne 0)
{
 $CurrentLog = ".\logs\$($_.Type).log"
 if(Test-Path $CurrentLog){"" | Out-File $CurrentLog -NoNewline}    
 if($null -eq $_.XProcess -or $_.XProcess.HasExited -ne $false)
 {
  $Restart = $true
  $DecayStart = Get-Date
  $_.Activated++
  $LogDir = Join-Path $Dir "logs\$($_.Type).log"
  if($Platform -eq "linux"){Rename-Item $_.Path -NewName "$($_.Type)-$($Instance)" -Force}
  $MinerDir = Split-Path $_.Path
  $LaunchCodes = @{}
  $LaunchCodes.Add("OCType",$_.Type)
  $LaunchCodes.Add("Logs",$LogDir)
  $LaunchCodes.Add("Name",$_.Name)
  $LaunchCodes.Add("MinerName",$_.MinerName)
  $LaunchCodes.Add("Path",$_.Path)
  $LaunchCodes.Add("Coins",$_.Coins)
  $LaunchCodes.Add("CmdDir",$build)
  $LaunchCodes.Add("MinerDir",$MinerDir)
  $LaunchCodes.Add("Delay",$Delay)
  $LaunchCodes.Add("Algos",$_.Algo)
  $LaunchCodes.Add("APIs",$_.API)
  $LaunchCodes.Add("Ports",$_.Port)
  $LaunchCodes.Add("MDir",$Dir)
  if($Platform -eq "linux"){$LaunchCodes.Add("MinerInstance","$($_.Type)-$($Instance)")}
  elseif($Platform -eq "windows"){$LaunchCodes.Add("MinerInstance","$($_.Type)-$($Instance)");$LaunchCodes.Add("Number","$Instance");}
  $LaunchCodes.Add("Platforms",$Platform)
  if($GPUGrouping -ne $null){$LaunchCodes.Add("GPUGroup",$GPUGrouping)}
  if($_.Arguments -ne "none"){$LaunchCodes.Add("Arguments","$($_.Arguments)")}
  if($null -ne $_.Connection){$LaunchCodes.Add("Connection","$($_.Connection)")}
  if($null -ne $_.Username){$LaunchCodes.Add("Username","$($_.Username)")}
  if($null -ne $_.Password){$LaunchCodes.Add("Password","$($_.Password)")}
  if($null -ne $_.DeviceCall){$LaunchCodes.Add("DeviceCall",$_.DeviceCall)}
  if($null -ne $_.Devices){$LaunchCodes.Add("Devices",$_.Devices)}
  if($null -ne $_.JsonFile){$LaunchCodes.Add("jsonfile",$_.JsonFile)}
  
  Start-LaunchCode @LaunchCodes
  
  $_.Instance = "$($_.Type)-$($Instance)"
  $MinerID = ".\build\pid\$($_.Instance)_pid.txt"
  if(Test-Path $MinerId){$MinerID = Get-Content ".\build\pid\$($_.Instance)_pid.txt"}
  $_.XProcess = Get-Process -Id $MinerID
  
  $_.InstanceNumber = $($Instance)
  $Instance++
  $LaunchCodes = $null
 }

if($Restart -eq $true)
{
 if($null -eq $_.XProcess -or $_.XProcess.HasExited)
 {
 $_.Status = "Failed"
 $NoMiners = $true
 Write-Host "$($_.MinerName) Failed To Launch" -ForegroundColor Darkred
 }
 else
 {
 $_.Status = "Running"
 Write-Host "$($_.MinerName) Is Running!" -ForegroundColor Green
    }
   }
  }
 }
}


$MinerWatch.Restart()

if($Restart -eq $true -and $NoMiners -eq $true)
{
##Notify User Of Failures
  Write-Host "
       
       
       
  There are miners that have failed! Check Your Settings And Arguments!
  https://github.com/MaynardMiner/SWARM/wiki/Arguments-(Miner-Configuration) >> Right Click 'Open URL In Browser'


  " -foreground Darkred
  Start-Sleep -s 20
}
#Notify User Of Delay
if($Platform -eq "linux" -and $Restart -eq $true -and $NoMiners -eq $false)
 {
   Write-Host "         
        
                             //\\  _______
                            //  \\//~//.--|
                            Y   /\\~~//_  |
                           _L  |_((_|___L_|
                          (/\)(____(_______)      
Waiting 20 Seconds For Miners To Load & Restarting Background Tracking

Type 'mine' in another terminal to see miner working- This is NOT a remote command!

Type 'get-screen [MinerType]' to see last 100 lines of log- This IS a remote command!

https://github.com/MaynardMiner/SWARM/wiki/HiveOS-management >> Right Click 'Open URL In Browser'  

   " -foreground Magenta
   Start-Sleep -s 20
 }
if($Platform -eq "windows" -and $Restart -eq $true -and $NoMiners -eq $false)
 {
   Write-Host "         
         
                              //\\  _______
                             //  \\//~//.--|
                             Y   /\\~~//_  |
                            _L  |_((_|___L_|
                           (/\)(____(_______)      
 Waiting 20 Seconds For Miners To Load & Restarting Background Tracking"
 Start-Sleep -s 20
}
##Notify User No Miners Started
if($Restart -eq $false)
 {
  Write-Host "
        
        
  Most Profitable Miners Are Running


  " -foreground DarkCyan
  Start-Sleep -s 5
 }

function Get-MinerActive {

  $ActiveMinerPrograms | Sort-Object -Descending Status,
  {if($null -eq $_.XProcess){[DateTime]0}else{$_.XProcess.StartTime}
  } | Select -First (1+6+6) | Format-Table -Wrap -GroupBy Status (
  @{Label = "Speed"; Expression={$_.HashRate | ForEach {"$($_ | ConvertTo-Hash)/s"}}; Align='right'},
  @{Label = "Active"; Expression={"{0:dd} Days {0:hh} Hours {0:mm} Minutes" -f $(if($null -eq $_.XProcess){$_.Active}else{if($_.XProcess.HasExited){($_.Active)}else{($_.Active+((Get-Date)-$_.XProcess.StartTime))}})}},
  @{Label = "Launched"; Expression={Switch($_.Activated){0 {"Never"} 1 {"Once"} Default {"$_ Times"}}}},
  @{Label = "Command"; Expression={"$($_.MinerName) $($_.Devices) $($_.Arguments)"}}
)
}

function Get-MinerStatus {
       Write-Host '
                                                                           (                    (      *     
                                                                            )\ ) (  (      (     )\ ) (  `    
                                                                            (()/( )\))(     )\   (()/( )\))(   
                                                                             /(_)|(_)()\ |(((_)(  /(_)|(_)()\  
                                                                            (_)) _(())\_)()\ _ )\(_)) (_()((_) 
                                                                            / __|\ \((_)/ (_)_\(_) _ \|  \/  | 
                                                                            \__ \ \ \/\/ / / _ \ |   /| |\/| | 
                                                                            |___/  \_/\_/ /_/ \_\|_|_\|_|  |_| 
                                                                                                                                                     ' -foregroundcolor "DarkRed"
        Write-Host "                                                                                     sudo apt-get lambo" -foregroundcolor "Yellow"
        Write-Host ""
        Write-Host ""
        Write-Host ""
        Write-Host ""
        $Y = [string]$CoinExchange
	      $H = [string]$Currency
      	$J = [string]'BTC'
        $BTCExchangeRate = Invoke-WebRequest "https://min-api.cryptocompare.com/data/pricemulti?fsyms=$Y&tsyms=$J" -UseBasicParsing | ConvertFrom-Json | Select-Object -ExpandProperty $Y | Select-Object -ExpandProperty $J
        $ProfitTable | Sort-Object -Property Type,Profits -Descending | Format-Table -GroupBy Type (
        @{Label = "Miner"; Expression={$($_.Miner)}},
        @{Label = "Coin"; Expression={$($_.Name)}},
        @{Label = "Speed"; Expression={$($_.HashRates) | ForEach {if($null -ne $_){"$($_ | ConvertTo-Hash)/s"}else{"Bench"}}}; Align='center'},
        @{Label = "Watt/Day"; Expression={$($_.Power) | ForEach {if($null -ne $_){($_ * $Rates.$Currency).ToString("N2")}else{"Bench"}}}; Align='center'},
        @{Label = "BTC/Day"; Expression={$($_.Profits) | ForEach {if($null -ne $_){  $_.ToString("N5")}else{"Bench"}}}; Align='right'},
        @{Label = "$Y/Day"; Expression={$($_.Profits) | ForEach {if($null -ne $_){  ($_ / $BTCExchangeRate).ToString("N5")}else{"Bench"}}}; Align='right'},
        @{Label = "$Currency/Day"; Expression={$($_.Profits) | ForEach {if($null -ne $_){($_ * $Rates.$Currency).ToString("N2")}else{"Bench"}}}; Align='center'},
        @{Label = "   Pool"; Expression={$($_.MinerPool)}; Align='center'}
            )
      }

#Check For Bechmark
$BenchmarkMode = $false
$ActiveMinerPrograms | Foreach {
if($null -eq (Get-Item ".\Stats\$($_.Name)_$($_.Algo)_HashRate.txt" -ErrorAction SilentlyContinue))
 {
  $BenchmarkMode = $true
 }
}

#Set Interval
if($BenchmarkMode -eq $true){$MinerInterval = $Benchmark}
else{$MinerInterval = $Interval}

#Clear Logs If There Are 12
if($Log -eq 12)
 {
  Remove-Item ".\Logs\*miner*"
  $Log = 0
}

#Start Another Log If An Hour Has Passed
if($LogTimer.Elapsed.TotalSeconds -ge 3600)
 {
  Stop-Transcript
  if(Test-Path ".\Logs\*Active*")
  {
   Set-Location ".\Logs"
   $OldActiveFile = Get-ChildItem "*Active*"
   $OldActiveFile | Foreach {
    $RenameActive = $_ -replace ("-Active","")
    if(Test-Path $RenameActive){Remove-Item $RenameActive -Force}
    Rename-Item $_ -NewName $RenameActive -force
    }
   Set-Location (Split-Path $script:MyInvocation.MyCommand.Path)
  }
  $Log++
  Start-Transcript ".\Logs\miner$($Log)-Active.log"
  $LogTimer.Restart()
 }

##Write Details Of Active Miner And Stats To File
if($Platform -eq "linux")
{
$StatusDate = Get-Date
$StatusDate | Out-File ".\build\bash\mineractive.sh"
Get-MinerActive | Out-File ".\build\bash\mineractive.sh" -Append
Clear-Content ".\build\bash\minerstats.sh" -Force
$StatusDate | Out-File ".\build\bash\minerstats.sh"
Get-MinerStatus | Out-File ".\build\bash\minerstats.sh" -Append
$mcolor = "93"
$me = [char]27
$MiningStatus = "$me[${mcolor}mCurrently Mining $($BestMiners_Combo.Algo) Algorithm${me}[0m"
$MiningStatus | Out-File ".\build\bash\minerstats.sh" -Append
if($Favor_Coins -eq "Yes")
 {
  if($BenchmarkMode -eq $false)
   {
$Crazy = "Favor Coins Was Specified. Algorithms may be removed from this list so that highest value coin is at the top. See github wik FAQ section as to why."
$CrazyLink = "https://github.com/MaynardMiner/Swarm/wiki/FAQ >> Right Click 'Open URL In Browser"
$Crazy | Out-File ".\build\bash\minerstats.sh" -Append
$CrazyLink | Out-File ".\build\bash\minerstats.sh" -Append
   }
 }
}
else{
Get-MinerActive | Out-Host
Get-MinerStatus | Out-Host
}

function Restart-Miner {
$BestActiveMiners | Foreach {
$Restart = $false
if($_.XProcess -eq $null -or $_.XProcess.HasExited)
{
$Restart = $true
$DecayStart = Get-Date
$_.Activated++
$LogDir = Join-Path $Dir "logs\$($_.Type).log"
if($Platform -eq "linux"){Rename-Item $_.Path -NewName "$($_.Type)-$($Instance)" -Force}
$MinerDir = Split-Path $_.Path
$LaunchCodes = @{}
$LaunchCodes.Add("OCType",$_.Type)
$LaunchCodes.Add("Logs",$LogDir)
$LaunchCodes.Add("Name",$_.Name)
$LaunchCodes.Add("MinerName",$_.MinerName)
$LaunchCodes.Add("Path",$_.Path)
$LaunchCodes.Add("Coins",$_.Coins)
$LaunchCodes.Add("CmdDir",$build)
$LaunchCodes.Add("MinerDir",$MinerDir)
$LaunchCodes.Add("Delay",$Delay)
$LaunchCodes.Add("Algos",$_.Algo)
$LaunchCodes.Add("APIs",$_.API)
$LaunchCodes.Add("Ports",$_.Port)
$LaunchCodes.Add("MDir",$Dir)
if($Platform -eq "linux"){$LaunchCodes.Add("MinerInstance","$($_.Type)-$($Instance)")}
elseif($Platform -eq "windows"){$LaunchCodes.Add("MinerInstance","$($_.Type)-$($Instance)");$LaunchCodes.Add("Number","$Instance");}
$LaunchCodes.Add("Platforms",$Platform)
if($GPUGrouping -ne $null){$LaunchCodes.Add("GPUGroup",$GPUGrouping)}
if($_.Arguments -ne "none"){$LaunchCodes.Add("Arguments","$($_.Arguments)")}
if($null -ne $_.Connection){$LaunchCodes.Add("Connection","$($_.Connection)")}
if($null -ne $_.Username){$LaunchCodes.Add("Username","$($_.Username)")}
if($null -ne $_.Password){$LaunchCodes.Add("Password","$($_.Password)")}
if($null -ne $_.DeviceCall){$LaunchCodes.Add("DeviceCall",$_.DeviceCall)}
if($null -ne $_.Devices){$LaunchCodes.Add("Devices",$_.Devices)}
if($null -ne $_.JsonFile){$LaunchCodes.Add("jsonfile",$_.JsonFile)}

Start-LaunchCode @LaunchCodes

$_.Instance = "$($_.Type)-$($Instance)"
$MinerID = Get-Content ".\build\pid\$($_.Instance)_pid.txt" 
$_.XProcess = Get-Process -Id $MinerID

$Instance++
$LaunchCodes = $null

if($Restart -eq $true)
{
if($null -eq $_.XProcess -or $_.XProcess.HasExited)
 {
  $_.Status = "Failed"
  $NoMiners = "Yes"
  Write-Host "$($_.MinerName) Failed To Launch" -ForegroundColor Darkred
 }
else
 {
  $_.Status = "Running"
  Write-Host "$($_.MinerName) Is Running!" -ForegroundColor Green
 }
Write-Host "
        
              //\\  _______
             //  \\//~//.--|
             Y   /\\~~//_  |
            _L  |_((_|___L_|
           (/\)(____(_______)        
        
  Waiting 20 Seconds For Miners To Fully Load

   " 
   Start-Sleep -s 20
}

    }
   }
  }

function Get-MinerHashRate {
  $BestActiveMiners | Foreach {
   if($null -eq $_.Xprocess -or $_.XProcess.HasExited){$_.Status = "Failed"}
   $Miner_HashRates = Get-HashRate -Type $_.Type
	 $GetDayStat = Get-Stat "$($_.Name)_$($_.Algo)_HashRate"
   $DayStat = "$($GetDayStat.Day)"
   $MinerPrevious = "$($DayStat | ConvertTo-Hash)"
	 $ScreenHash = "$($Miner_HashRates | ConvertTo-Hash)"
   Write-Host "[$(Get-Date)]:" -foreground yellow -nonewline
   Write-Host " $($_.Type) is currently" -foreground green -nonewline
   if($_.Status -eq "Running"){$MinerStatus = Write-Host " Running: " -ForegroundColor green -nonewline}
   if($_.Status -eq "Failed"){$MinerStatus = Write-Host " Not Running: " -ForegroundColor darkred -nonewline} 
   $MinerStatus
	 Write-Host "$($_.Name) current hashrate for $($_.Coins) is" -nonewline
	 Write-Host " $ScreenHash/s" -foreground green
   Write-Host "$($_.Type) is currently mining on $($_.MinerPool)" -foregroundcolor Cyan
	 Start-Sleep -S 2
	 Write-Host "$($_.Type) previous hashrates for $($_.Coins) is" -nonewline
	 Write-Host " $MinerPrevious/s" -foreground yellow
 }
}

##Function To Adjust/Set Countdown On Screen
function Set-Countdown {
$Countdown = ([math]::Round(($MinerInterval-20) - $MinerWatch.Elapsed.TotalSeconds))
$CountMessage = "Time Left Until Database Starts: $($Countdown)"
Write-Host $CountMessage -foreground Gray
}

function Restart-Database {
$Restart = "No"
$BestActiveMiners | foreach {
if($null -eq $_.XProcess -or $_.XProcess.HasExited)
{
 $_.Status = "Failed"
 $Restart = "Yes"
}
else
{
 $Miner_HashRates = Get-HashRate -Type $_.Type
 $ScreenHash = "$($Miner_HashRates | ConvertTo-Hash)"
 if($ScreenHash -eq "0.00PH" -or $ScreenHash -eq '')
 {
 if($BenchmarkMode -eq $false)
  {
   $_.Status = "Failed"
   $Restart = "Yes"
    }
   }
  }
 }
$Restart
}

##Remove Old Jobs From Memory
Get-Job -State Completed | Remove-Job
[GC]::Collect()
[GC]::WaitForPendingFinalizers()
[GC]::Collect()

function Get-VM {
  ps powershell* | Select *memory* | ft -auto `
  @{Name='Virtual Memory Size (MB)';Expression={($_.VirtualMemorySize64)/1MB}; Align='center'}, `
  @{Name='Private Memory Size (MB)';Expression={(  $_.PrivateMemorySize64)/1MB}; Align='center'},
  @{Name='Memory Used This Session (MB)';Expression={([System.gc]::gettotalmemory("forcefullcollection") /1MB)}; Align='center'}
 }

##Miner Loop Linux
if($Platform -eq "linux")
{
Do{

  Set-Countdown
  Get-MinerHashRate
  Start-Sleep -s 15
  if($MinerWatch.Elapsed.TotalSeconds -ge ($MinerInterval-20)){break}
  Set-Countdown
  Get-MinerHashRate
  Start-Sleep -s 15
  if($MinerWatch.Elapsed.TotalSeconds -ge ($MinerInterval-20)){break}
  Set-Countdown
  Restart-Miner
  Write-Host "

      Type 'stats' in another terminal to view miner statistics- This IS a remote command!
      https://github.com/MaynardMiner/Swarm/wiki/HiveOS-management >> Right Click 'Open URL In Browser'

  " -foreground Magenta
  Get-MinerHashRate
  Start-Sleep -s 15
  if($MinerWatch.Elapsed.TotalSeconds -ge ($MinerInterval-20)){break}
  Set-Countdown
  Get-MinerHashRate
  Start-Sleep -s 15
  if($MinerWatch.Elapsed.TotalSeconds -ge ($MinerInterval-20)){break}
  Set-Countdown
  Restart-Miner
  Get-MinerHashRate
  Start-Sleep -s 15
  if($MinerWatch.Elapsed.TotalSeconds -ge ($MinerInterval-20)){break}
  Set-Countdown
  Write-Host "

      Type 'active' in another terminal to view active/previous miners- this IS a remote command!
      https://github.com/MaynardMiner/Swarm/wiki/HiveOS-management >> Right Click 'Open URL In Browser'

  " -foreground Magenta
  Get-MinerHashRate
  Start-Sleep -s 15
  if($MinerWatch.Elapsed.TotalSeconds -ge ($MinerInterval-20)){break}
  $RestartData = Restart-Database
  if($RestartData -eq "Yes"){break}

}While($MinerWatch.Elapsed.TotalSeconds -lt ($MinerInterval-20))
}
else
{
Do{
   Clear-Host
   Get-MinerActive | Out-Host
   Get-MinerStatus | Out-Host
   Get-VM | Out-Host
   Restart-Miner
   $Countdown = ([math]::Round(($MinerInterval-20) - $MinerWatch.Elapsed.TotalSeconds))
   Write-Host "Time Left Until Database Starts: $($Countdown)" -foreground Gray
   Get-MinerHashRate
   if($MinerWatch.Elapsed.TotalSeconds -ge ($MinerInterval-20)){break}
   Start-Sleep -s 30
   if($MinerWatch.Elapsed.TotalSeconds -ge ($MinerInterval-20)){break}
}While($MinerWatch.Elapsed.TotalSeconds -lt ($MinerInterval-20))
}

##Get-Power
if($Platform -eq "linux" -and $WattOMeter -eq "Yes")
 {
Write-Host "

Starting Watt-O-Meter
     __________
    |   ____   |
    |  /    \  |
    | | .''. | |
    | |   /  | |
    |==========|
    |   WATT   |
    |__________|
  
" -foregroundcolor yellow
Get-Power -PwrType $Type
Set-Location (Split-Path $script:MyInvocation.MyCommand.Path)
}

##Benchmarking/Timeout      
$BestActiveMiners | foreach {
if($_.BestMiner -eq $true)
 {
 if($null -eq $_.XProcess -or $_.XProcess.HasExited)
  {
   $_.Status = "Failed"
   $_.WasBenchMarked = $False
  }
  else
   { 
   if($TimeDeviation -ne 0)
    {
     $_.HashRate = 0
     $_.WasBenchmarked = $False
     $Miner_HashRates = Get-HashRate -Type $_.Type
     $_.Timeout = 0
     $_.HashRate = $Miner_HashRates
     $WasActive = [math]::Round(((Get-Date)-$_.XProcess.StartTime).TotalSeconds)
     if($WasActive -ge $StatsInterval)
      {
	     Write-Host "$($_.Name) $($_.Coins) Was Active for $WasActive Seconds"
	     Write-Host "Attempting to record hashrate for $($_.Name) $($_.Coins)" -foregroundcolor "Cyan"
       for($i=0; $i -lt 4; $i++)
        {
        if($_.WasBenchmarked -eq $False)
         {
         if(-not (Test-Path "backup")){New-Item "backup" -ItemType "directory" | Out-Null}
         Write-Host "$($_.Name) $($_.Coins) Starting Bench"
         $HashRateFilePath = Join-Path ".\stats" "$($_.Name)_$($_.Algo)_hashrate.txt"
	       $PowerFilePath = Join-Path ".\stats" "$($_.Name)_$($_.Algo)_power.txt"
         $NewHashrateFilePath = Join-Path ".\backup" "$($_.Name)_$($_.Algo)_hashrate.txt"
         $NewPowerFilePath = Join-Path ".\backup" "$($_.Name)_$($_.Algo)_power.txt"
         if($null -eq $Miner_HashRates -or $Miner_HashRates -eq 0)
          {
           $_.Timeout++
           Write-Host "Stat Attempt Yielded 0" -Foregroundcolor Red
           Start-Sleep -S .25
          }
         else
          {
           if(Test-Path ".\build\txt\powerup.txt")
            {
             if($($_.Devices) -ne $null){$GPUPower = Set-Power -PwrDevices $($_.Devices) -PwrType $Type}
             else{$GPUPower = Set-Power -PwrCount $GPU_Count -PwrType $Type}
            }
           else{$GPUPower = 1}
           if($WattOMeter -eq "yes" -and $_.Type -ne "CPU"){$Stat = Set-Stat -Name "$($_.Name)_$($_.Algo)_power" -Value $GPUPower}
           $Stat = Set-Stat -Name "$($_.Name)_$($_.Algo)_hashrate" -Value $Miner_HashRates
           Start-Sleep -s 1
           $GetLiveStat = Get-Stat "$($_.Name)_$($_.Algo)_hashrate"
           $StatCheck = "$($GetLiveStat.Live)"
           $ScreenCheck = "$($StatCheck | ConvertTo-Hash)"
           if($ScreenCheck -eq "0.00 PH" -or $null -eq $StatCheck)
            {
             $_.Timeout++
             $_.WasBenchmarked = $False
             Write-Host "Stat Failed Write To File" -Foregroundcolor Red
            }
           else
            {
             Write-Host "Recorded Hashrate For $($_.Name) $($_.Coins) Is $($ScreenCheck)" -foregroundcolor "magenta"
             if($WattOmeter -eq "Yes"){Write-Host "Watt-O-Meter scored $($_.Name) $($_.Coins) at $($GPUPower) Watts" -ForegroundColor magenta}
             if(-not (Test-Path $NewHashrateFilePath))
              {
               Copy-Item $HashrateFilePath -Destination $NewHashrateFilePath -force
               if($WattOMeter -eq "Yes" -and $_.Type -ne "CPU"){Copy-Item $PowerFilePath -Destination $NewPowerFilePath -force}
               Write-Host "$($_.Name) $($_.Coins) Was Benchmarked And Backed Up" -foregroundcolor yellow
              }
             $_.WasBenchmarked = $True
	           Write-Host "Stat Written" -foregroundcolor green
             $_.Timeout = 0
             $_.Bad_Benchmark = 0
            } 
           }
          }
         }
        }
       }
      }
		 

if($_.Timeout -gt 2 -or $null -eq $_.XProcess -or $_.XProcess.HasExited)
 {
  if($_.WasBenchmarked -eq $False)
   {
    if (-not (Test-Path ".\timeout")) {New-Item "timeout" -ItemType "directory" | Out-Null}
    $TimeoutFile = Join-Path ".\timeout" "$($_.Name)_$($_.Algo)_TIMEOUT.txt"
    $HashRateFilePath = Join-Path ".\stats" "$($_.Name)_$($_.Algo)_hashRate.txt"
    $_.Bad_Benchmark++
    if(-not (Test-Path $TimeoutFile)){"$($_.Name) $($_.Coins) Hashrate Check Timed Out $($_.Bad_Benchmark) Times" | Set-Content ".\timeout\$($_.Name)_$($_.Algo)_TIMEOUT.txt" -Force}
    $_.WasBenchmarked = $True
    $_.Timeout = 0
    Write-Host "$($_.Name) $($_.Coins) Hashrate Check Timed Out $($_.Bad_Benchmark) Times- It Was Noted In Timeout Folder" -foregroundcolor "darkred"
    if($_.Bad_Benchmark -ge 3)
     {
      $Stat = Set-Stat -Name "$($_.Name)_$($_.Algo)_hashrate" -Value 0
      Write-Host "Benchmarking Has Failed - Setting Stat To 0. Delete Stat In Stats Folder To Reset" -ForegroundColor DarkRed
     }
    }
   }
  }
 }
}
  #Stop the log
  Stop-Transcript
  Get-Date | Out-File ".\Build\Data\TimeTable.txt"

