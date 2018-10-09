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

function Tee-ObjectNoColor {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
        [string]$InputObject,

        [Parameter(Position=1, Mandatory=$true)]
        [string]$FilePath
    )

  process{
        $Logs = $InputObject -replace '\\[\d+(;\d+)?m'
        $Logs | Out-File $FilePath -Append
        $InputObject | Out-Host
         }
}

function Open-Colored([String] $Filename)
  {Write-Colored($Filename)}

function Write-Colored([String] $text)
  { # split text at ESC-char
    $split = $text.Split([char] 27)
    foreach ($line in $split)
      { if ($line[0] -ne '[')
          { Write-Host $line -NoNewline }
        else
          { if(($line[1] -eq '0') -and ($line[2] -eq 'm')) { Write-Host $line.Substring(3) -NoNewline }
            elseif(($line[1] -eq '0') -and ($line[2] -eq '1')) { Write-Host $line.Substring(3) -NoNewline -ForegroundColor White }           
            elseif (($line[1] -eq '3') -and ($line[3] -eq 'm'))
              { # normal color codes
                if     ($line[2] -eq '0') { Write-Host $line.Substring(4) -NoNewline -ForegroundColor Black       }
                elseif ($line[2] -eq '1') { Write-Host $line.Substring(4) -NoNewline -ForegroundColor DarkRed     }
                elseif ($line[2] -eq '2') { Write-Host $line.Substring(4) -NoNewline -ForegroundColor DarkGreen   }
                elseif ($line[2] -eq '3') { Write-Host $line.Substring(4) -NoNewline -ForegroundColor DarkYellow  }
                elseif ($line[2] -eq '4') { Write-Host $line.Substring(4) -NoNewline -ForegroundColor DarkBlue    }
                elseif ($line[2] -eq '5') { Write-Host $line.Substring(4) -NoNewline -ForegroundColor DarkMagenta }
                elseif ($line[2] -eq '6') { Write-Host $line.Substring(4) -NoNewline -ForegroundColor DarkCyan    }
                elseif ($line[2] -eq '7') { Write-Host $line.Substring(4) -NoNewline -ForegroundColor Gray        }
              }
            elseif (($line[1] -eq '3') -and ($line[3] -eq ';') -and ($line[5] -eq 'm'))
              { # bright color codes
                if     ($line[2] -eq '0') { Write-Host $line.Substring(6) -NoNewline -ForegroundColor DarkGray    }
                elseif ($line[2] -eq '1') { Write-Host $line.Substring(6) -NoNewline -ForegroundColor Red         }
                elseif ($line[2] -eq '2') { Write-Host $line.Substring(6) -NoNewline -ForegroundColor Gree        }
                elseif ($line[2] -eq '3') { Write-Host $line.Substring(6) -NoNewline -ForegroundColor Yellow      }
                elseif ($line[2] -eq '4') { Write-Host $line.Substring(6) -NoNewline -ForegroundColor Blue        }
                elseif ($line[2] -eq '5') { Write-Host $line.Substring(6) -NoNewline -ForegroundColor Magenta     }
                elseif ($line[2] -eq '6') { Write-Host $line.Substring(6) -NoNewline -ForegroundColor Cyan        }
                elseif ($line[2] -eq '7') { Write-Host $line.Substring(6) -NoNewline -ForegroundColor White       }
              }
          }
      }
  }
 
 function Start-LaunchCode {
        param(
            [parameter(Mandatory=$true)]
            [String]$OCType,
            [parameter(Mandatory=$true)]
            [String]$Name,
            [parameter(Mandatory=$false)]
            [String]$DeviceCall,
            [parameter(Mandatory=$false)]
            [String]$Devices='',
            [parameter(Mandatory=$false)]
            [String]$Arguments,
            [parameter(Mandatory=$true)]
            [String]$MinerName,
            [parameter(Mandatory=$true)]
            [String]$Path,
            [parameter(Mandatory=$true)]
            [String]$Coins,
            [parameter(Mandatory=$true)]
            [String]$CmdDir,
            [parameter(Mandatory=$true)]
            [String]$MinerDir,
	          [parameter(Mandatory=$true)]
            [String]$Logs,
            [parameter(Mandatory=$true)]
            [String]$Delay,
            [parameter(Mandatory=$true)]
            [string]$MinerInstance,
            [parameter(Mandatory=$true)]
            [string]$Algos,
            [parameter(Mandatory=$false)]
            [string]$GPUGroups,
            [parameter(Mandatory=$true)]
            [string]$APIs,
            [parameter(Mandatory=$true)]
            [string]$Ports,
            [parameter(Mandatory=$true)]
            [string]$MDir,
            [parameter(Mandatory=$false)]
            [string]$Username,                      
            [parameter(Mandatory=$false)]
            [string]$Connection,
            [parameter(Mandatory=$false)]
            [string]$Password,
            [parameter(Mandatory=$false)]
            [string]$jsonfile,
            [parameter(Mandatory=$false)]
            [string]$Platforms,
            [parameter(Mandatory=$false)]
            [string]$Number                                          
        )

 $BackgroundTimer = New-Object -TypeName System.Diagnostics.Stopwatch
 
 $PIDMiners = "$($OCType)"
 
 if(Test-Path ".\build\pid\*$PIDMiners*"){Remove-Item ".\build\pid\*$PIDMiners*" -Force}
 if($OCType -like '*NVIDIA*')
 {
 if($Devices -eq '')
 {
 $MinerArguments = "$($Arguments)"
 if($DeviceCall -eq "lolminer"){$MinerArguments = "-profile=miner -usercfg=$($jsonfile)"}
 }
 else
 {
 switch($DeviceCall)
 {
 "ccminer"{$MinerArguments = "-d $($Devices) $($Arguments)"}
 "ewbf"{$MinerArguments = "--cuda_devices $($Devices) $($Arguments)"}
 "dstm"{$MinerArguments = "--dev $($Devices) $($Arguments)"}
 "claymore"{$MinerArguments = "-di $($Devices) $($Arguments)"}
 "trex"{$MinerArguments = "-d $($Devices) $($Arguments)"}
 "lolminer"{$MinerArguments = "-devices=$($Devices) -profile=miner -usercfg=$($jsonfile)"}
  }
 }
}

if($OCType -like '*AMD*')
{
 if($Devices -eq ''){
 $MinerArguments = "$($Arguments)"
 if($DeviceCall -eq "lolamd"){$MinerArguments = "-profile=miner -usercfg=$($jsonfile)"}
 if($DeviceCall -eq "lyclminer"){
 $MinerArguments = ""
 Set-Location $MinerDir
 $ConfFile = Get-Content ".\lyclMiner.conf" -Force
 $NewLines = $ConfFile | ForEach {
 if($_ -like "*<Connection Url =*"){$_ = "<Connection Url = `"stratum+tcp://$Connection`""}
 if($_ -like "*Username =*"){$_ = "            Username = `"$Username`"    "}
 if($_ -like "*Password =*" ){$_ = "            Password = `"$Password`">    "}
 if($_ -notlike "*<Connection Url*" -or $_ -notlike "*Username*" -or $_ -notlike "*Password*"){$_}
 }
 Clear-Content ".\lyclMiner.conf" -force
 $NewLines | Set-Content ".\lyclMiner.conf"
 Set-Location $CmdDir
 }
}
 else{
 Switch($DeviceCall)
  {
  "claymore"{$MinerArguments = "-di $($Devices) $($Arguments)"}
  "sgminer"{$MinerArguments = "-d $($Devices) $($Arguments)"}
  "tdxminer"{$MinerArguments = "-d $($Devices) $($Arguments)"}
  "lolamd"{$MinerArguments = "-devices=$($Devices) -profile=miner -usercfg=$($jsonfile)"}
  "lyclminer"{
   $MinerArguments = ""
   Set-Location $MinerDir
   $ConfFile = Get-Content ".\lyclMiner.conf" -Force
   $NewLines = $ConfFile | ForEach {
   if($_ -like "*<Connection Url =*"){$_ = "<Connection Url = `"stratum+tcp://$Connection`""}
   if($_ -like "*Username =*"){$_ = "            Username = `"$Username`"    "}
   if($_ -like "*Password =*" ){$_ = "            Password = `"$Password`">    "}
   if($_ -notlike "*<Connection Url*" -or $_ -notlike "*Username*" -or $_ -notlike "*Password*"){$_}
   }
   Clear-Content ".\lyclMiner.conf" -force
   $NewLines | Set-Content ".\lyclMiner.conf"
   Set-Location $CmdDir
   }
  }
 }
}

if($OCType -like '*CPU*')
{
 if($Devices -eq ''){$MinerArguments = "$($Arguments)"}
 else{
 if($DeviceCall -eq "cpuminer-opt"){$MinerArguments = "-t $($Devices) $($Arguments)"}
 if($DeviceCall -eq "cryptozeny"){$MinerArguments = "-t $($Devices) $($Arguments)"}
 }
}

if($Platforms -eq "windows")
{
 Set-Location $MinerDir
 $script = @()
 $script += ". C:\Users\Mayna\Desktop\MM.Test\build\powershell\launchcode.ps1;"
 $script += "`$host.ui.RawUI.WindowTitle = `'$MinerName`';"
 if($DeviceCall -eq "ewbf"){$script += "Invoke-Expression `'.\$MinerName $MinerArguments --log 3 --logfile $Logs`'"}
 elseif($DeviceCall -eq "claymore"){$script += "Invoke-Expression `'.\$MinerName $MinerArguments`'"}
 else{$script += "Invoke-Expression `'.\$MinerName $MinerArguments`' | Tee-ObjectNoColor -FilePath `'$Logs`' -erroraction SilentlyContinue"}
 $script | Set-Content "swarm-start.ps1" -Force
 Start-Sleep -S 1
 $Command = start-process "CMD" -ArgumentList "/c ""powershell.exe -executionpolicy bypass -windowstyle minimized -command "".\swarm-start.ps1""" -PassThru | foreach {$_.Id} > "$dir\build\pid\$($MinerInstance)_pid.txt"
 Set-Location (Split-Path $script:MyInvocation.MyCommand.Path)
 $BackgroundTimer.Restart()
 do
 {
  Start-Sleep -S 1
  Write-Host "Getting Process ID for $MinerName"
  $ProcessId = if(Test-Path ".\build\pid\$($MinerInstance)_pid.txt"){Get-Content ".\build\pid\$($MinerInstance)_pid.txt"}
  if($ProcessId -ne $null){Get-Date | Set-Content ".\build\pid\$($MinerInstance)_date.txt"}
 }until($ProcessId -ne $null -or ($BackgroundTimer.Elapsed.TotalSeconds) -ge 10)  
  $BackgroundTimer.Stop()
}

if($Platforms -eq "linux")
{
  $MinerConfig = "./$MinerInstance $MinerArguments"
  $MinerConfig | Set-Content ".\build\bash\config.sh" -Force

  Write-Host "
         ______________
       /.----------..-'
-.     ||           \\
.----'-||-.          \\
|o _   || |           \\
| [_]  || |_...-----.._\\
| [_]  ||.'            ``-._ _
| [_]  '.O)_...-----....._ ``.\
/ [_]o .' _ _'''''''''_ _ `. ``.       __
|______/.'  _  ``.---.'  _  ``.\  ``._./  \Cl
|'''''/, .' _ '. . , .' _ '. .``. .o'|   \ear
``---..|; : (_) : ;-; : (_) : ;-'``--.|    \ing Screen $($OCType) & Tracking
       ' '. _ .' ' ' '. _ .' '      /     \
        ``._ _ _,'   ``._ _ _,'       ``._____\        
"

Start-Process ".\build\bash\killall.sh" -ArgumentList "$($OCType)" -Wait
Start-Sleep $Delay #Wait to prevent BSOD
Start-Sleep -S .25
Set-Location $MinerDIr
Start-Process "chmod" -ArgumentList "+x $MinerInstance" -Wait
Set-Location $MDir
Start-Sleep -S .25
Write-Host "Starting $($Name) Mining $($Coins) on $($OCType)" -ForegroundColor Cyan
if($OCType -like "*NVIDIA*"){Start-Process ".\build\bash\startupnvidia.sh" -ArgumentList "$MinerDir $($OCType) $Mdir/build/bash $Logs $Mdir/build/export" -Wait}
if($OCType -like "*AMD*"){Start-Process ".\build\bash\startupamd.sh" -ArgumentList "$MinerDir $($OCType) $Mdir/build/bash $Logs $Mdir/build/export" -Wait}
if($OCType -like "*CPU*"){Start-Process ".\build\bash\startupcpu.sh" -ArgumentList "$MinerDir $($OCType) $Mdir/build/bash $Logs" -Wait}
$BackgroundTimer.Restart()
$MinerProcessId = $null

Do{
  Start-Sleep -S 1
  Write-Host "Getting Process ID for $MinerName"           
  $MinerProcessId = Get-Process -Name "$($MinerInstance)" -ErrorAction SilentlyContinue
  }until($MinerProcessId -ne $null -or ($MinerTimer.Elapsed.TotalSeconds) -ge 10)  
if($MinerProcessId -ne $null)
 {
   $MinerProcessId.Id | Set-Content ".\build\pid\$($MinerInstance)_pid.txt" -Force
   Get-Date | Set-Content ".\build\pid\$($MinerInstance)_date.txt" -Force
   Start-Sleep -S 1
 }
$BackgroundTimer.Stop()
Rename-Item "$MinerDir\$($MinerInstance)" -NewName "$MinerName" -Force
Start-Sleep -S .25
}
}





