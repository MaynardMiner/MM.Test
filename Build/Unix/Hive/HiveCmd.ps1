function Get-GPUCount {
    param (
        [Parameter(Mandatory=$true)]
        [Array]$DeviceType,
        [Parameter(Mandatory=$true)]
        [String]$CmdDir
    )
    Set-Location "/"
    Set-Location $CmdDir

    $DeviceType | foreach{
     if($_ -like "*NVIDIA*")
      {
       Write-Host "Getting NVIDIA GPU Count" -foregroundcolor cyan
        nvidia-smi -a | Tee-Object ".\GPUCount.txt" | Out-Null
        $GCount = Get-Content ".\GPUCount.txt" 
        $AttachedGPU = $GCount | Select-String "Attached GPUS"   
        [int]$GPU_Count = $AttachedGPU -split ": " | Select -Last 1
         }
      if($_ -like "*AMD*")
       {
         Write-Host "Getting AMD GPU Count" -foregroundcolor cyan
         lspci | Tee-Object ".\GPUCount.txt" | Out-Null
         $GCount = Get-Content ".\GPUCount.txt" 
         $AttachedGPU = $GCount | Select-String "VGA" | Select-String "AMD"   
         [int]$GPU_Count = $AttachedGPU.Count
       }
    }
             
    $GPU_Count  
}

function Get-Data {
    param (
    [Parameter(Mandatory=$true)]
    [String]$CmdDir
    )

    Set-Location "/"
    Set-Location $CmdDir

    if(Test-Path ".\dir.sh")
     {
      Copy-Item ".\dir.sh" -Destination "/usr/bin" -force | Out-Null
      Set-Location "/usr/bin"
      Start-Process "chmod" -ArgumentList "+x dir.sh"
      Set-Location "/"
      Set-Location $CmdDir
     }

    if(Test-Path ".\stats")
    {
         Copy-Item ".\stats" -Destination "/usr/bin" -force | Out-Null
         Set-Location "/usr/bin"
         Start-Process "chmod" -ArgumentList "+x stats"
         Set-Location "/"
         Set-Location $CmdDir     
    }
   
   if(Test-Path ".\active")
    {
       Copy-Item ".\active" -Destination "/usr/bin" -force | Out-Null
       Set-Location "/usr/bin"
       Start-Process "chmod" -ArgumentList "+x active"
       Set-Location "/"
       Set-Location $CmdDir
       }
    
       if(Test-Path ".\get-screen")
    {
       Copy-Item ".\get-screen" -Destination "/usr/bin" -force | Out-Null
       Set-Location "/usr/bin"
       Start-Process "chmod" -ArgumentList "+x get-screen"
       Set-Location "/"
       Set-Location $CmdDir
       }
   
   if(Test-Path ".\mine")
    {
       Copy-Item ".\mine" -Destination "/usr/bin" -force | Out-Null
       Set-Location "/usr/bin"
       Start-Process "chmod" -ArgumentList "+x mine"
       Set-Location "/"
       Set-Location $CmdDir
       }
   
   if(Test-Path ".\logdata")
    {
       Copy-Item ".\logdata" -Destination "/usr/bin" -force | Out-Null
       Set-Location "/usr/bin"
       Start-Process "chmod" -ArgumentList "+x logdata"
       Set-Location "/"
       Set-Location $CmdDir
       }
   
   if(Test-Path ".\pidinfo")
    {
       Copy-Item ".\pidinfo" -Destination "/usr/bin" -force | Out-Null
       Set-Location "/usr/bin"
       Start-Process "chmod" -ArgumentList "+x pidinfo"
       Set-Location "/"
       Set-Location $CmdDir
       }
    

    if((Get-Item ".\Data\Info.txt" -ErrorAction SilentlyContinue) -eq $null)
    {New-Item -Path ".\Data" -Name "Info.txt"  | Out-Null}
   if((Get-Item ".\Data\System.txt" -ErrorAction SilentlyContinue) -eq $null)
    {New-Item -Path ".\Data" -Name "System.txt"  | Out-Null}
   if((Get-Item ".\Data\TimeTable.txt" -ErrorAction SilentlyContinue) -eq $null)
    {New-Item -Path ".\Data" -Name "TimeTable.txt"  | Out-Null}
    if((Get-Item ".\Data\Error.txt" -ErrorAction SilentlyContinue) -eq $null)
    {New-Item -Path ".\Data" -Name "Error.txt"  | Out-Null}
    $TimeoutClear = Get-Content ".\Data\Error.txt" | Out-Null
    if(Test-Path ".\PID"){Remove-Item ".\PID\*" -Force | Out-Null}
    else{New-Item -Path "." -Name "PID" -ItemType "Directory" | Out-Null}   
    if($TimeoutClear -ne "")
     {
      Clear-Content ".\Data\System.txt"
      Get-Date | Out-File ".\Data\Error.txt" | Out-Null
     } 

    $DonationClear = Get-Content ".\Data\Info.txt" | Out-String
    if($DonationClear -ne "")
    {Clear-Content ".\Data\Info.txt"} 
    Set-Location (Split-Path $script:MyInvocation.MyCommand.Path)
}

function Get-AlgorithmList {
    param (
        [Parameter(Mandatory=$true)]
        [Array]$DeviceType,
        [Parameter(Mandatory=$true)]
        [String]$CmdDir,
        [Parameter(Mandatory=$false)]
        [Array]$No_Algo
    )
    Set-Location "/"
    Set-Location $CmdDir

    $AlgorithmList = @()
    $GetAlgorithms = Get-Content ".\Config\get-pool.txt" | ConvertFrom-Json
    $PoolAlgorithms = @()
    $GetAlgorithms | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {
     $PoolAlgorithms += $_
    }
    
    if($No_Algo -ne $null)
     {
     $GetNoAlgo = Compare-Object $No_Algo $PoolAlgorithms
     $GetNoAlgo.InputObject | foreach{$AlgorithmList += $_}
     }
     else{$PoolAlgorithms | foreach { $AlgorithmList += $($_)} }
         
    $AlgorithmList
    Set-Location (Split-Path $script:MyInvocation.MyCommand.Path)
    }

 function Start-LaunchCode {
        param(
            [parameter(Mandatory=$true)]
            [String]$Type,
            [parameter(Mandatory=$true)]
            [String]$Name,
            [parameter(Mandatory=$false)]
            [String]$DeviceCall,
            [parameter(Mandatory=$false)]
            [String]$Devices='',
            [parameter(Mandatory=$true)]
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
            [String]$Delay
        )
    
        $MinerTimer = New-Object -TypeName System.Diagnostics.Stopwatch
        $Export = "/hive/ccminer/cuda"
	$ClayMinerDir = Join-path "$MinerDir" "$MinerName"
        
        Set-Location "/"
        Set-Location $CmdDir
        $PIDMiners = "$($Type)"
        if(Test-Path ".\PID\*$PIDMiners*"){Remove-Item ".\PID\*$PIDMiners*" -Force}

        if($Type -like '*NVIDIA*')
        {
        if($Devices -eq ''){$MinerArguments = "$($Arguments)"}
        else{
        if($DeviceCall -eq "ccminer"){$MinerArguments = "-d $($Devices) $($Arguments)"}
        if($DeviceCall -eq "ewbf"){$MinerArguments = "--cuda_devices $($Devices) $($Arguments)"}
        if($DeviceCall -eq "dstm"){$MinerArguments = "--dev $($Devices) $($Arguments)"}
        if($DeviceCall -eq "claymore"){$MinerArguments = "-di $($Devices) $($Arguments)"}
        if($DeviceCall -eq "trex"){$MinerArguments = "-d $($Devices) $($Arguments)"}
        if($DeviceCall -eq "bminer"){$MinerArgument = "-devices $($Devices) $($Arguments)"}
         }
        }
        if($Type -like '*AMD*')
        {
        if($Devices -eq ''){$MinerArguments = "$($Arguments)"}
        else{
          if($DeviceCall -eq "claymore"){$MinerArguments = "-di $($Devices) $($Arguments)"}
          if($DeviceCall -eq "sgminer"){$MinerArguments = "-d $($Devices) $($Arguments)"}
          if($DeviceCall -eq "tdxminer"){$MinerArguments = "-d $($Devices) $($Arguments)"}
         }
        }
        if($Type -like '*CPU*'){$MinerArguments = $Arguments}
        if($Type -like '*ASIC*'){$MinerArguments = $Arguments}
   	    $MinerConfig = "./$Minername $MinerArguments"
        $MinerConfig | Set-Content ".\Unix\Hive\config.sh"
        Start-Sleep -S 1
        Write-Host "
        
        
        
        Clearing Screen $($_.Type) & Tracking
    
    
    
        "
        Start-Process ".\Unix\Hive\killall.sh" -ArgumentList "$($Type)" -Wait    
        Start-Sleep $Delay #Wait to prevent BSOD
        $MiningId = Start-Process "screen" -ArgumentList "-S $($Type) -d -m"
        Start-Sleep -S 1
        if($Type  -like '*NVIDIA*'){$PreStart = Start-Process ".\Unix\Hive\pre-start.sh" -ArgumentList "$($Type) $Export" -Wait}
        if($Type -like '*AMD*'){$PreStart = Start-Process ".\Unix\Hive\pre-startamd.sh" -ArgumentList "$($Type)" -Wait}
	    Start-Sleep -S 1
        Write-Host "Starting $($Name) Mining $($Coins) on $($Type)" -ForegroundColor Cyan
	    $NewMiner = Start-Process ".\Unix\Hive\startup.sh" -ArgumentList "$MinerDir $($Type) $CmdDir/Unix/Hive $Logs"

        $MinerTimer.Restart()

        Do{
           Start-Sleep -S 1
           Write-Host "Getting Process ID for $MinerName"
           $MinerProcessId = Get-Process -Name "$($MinerName)" -ErrorAction SilentlyContinue
          }until($MinerProcessId -ne $null -or ($MinerTimer.Elapsed.TotalSeconds) -ge 10)  
        if($MinerProcessId -ne $null)
         {
            $MinerProcessId.Id | Out-File ".\PID\$($Name)_$($Coins)_$($Type)_PID.txt"
            Get-Date | Out-File ".\PID\$($Name)_$($Coins)_$($Type)_Date.txt"
            Start-Sleep -S 3
        }

        $MinerTimer.Stop()
        Set-Location (Split-Path $script:MyInvocation.MyCommand.Path)

    }

    function Get-Threads {
        param(
            [Parameter(Mandatory=$true)]
            [String]$API,
            [Parameter(Mandatory=$true)]
            [Int]$Port,
            [Parameter(Mandatory=$false)]
            [Object]$Parameters = @{},
            [Parameter(Mandatory=$false)]
            [Bool]$Safe = $false
        )
    

    $Server = "localhost"

    $Multiplier = 1000
    $Delta = 0.05
    $Interval = 5
    $HashRates = @()

    try
    {
        switch($API)
        {
            "sgminer-gm"
            {
                $Message = @{command="summary"; parameter=""} | ConvertTo-Json -Compress

                do
                {
                    $Client = New-Object System.Net.Sockets.TcpClient $server, $port
                    $Writer = New-Object System.IO.StreamWriter $Client.GetStream()
                    $Reader = New-Object System.IO.StreamReader $Client.GetStream()
                    $Writer.AutoFlush = $true

                    $Writer.WriteLine($Message)
                    $Request = $Reader.ReadLine()

                    $Data = $Request.Substring($Request.IndexOf("{"),$Request.LastIndexOf("}")-$Request.IndexOf("{")+1) -replace " ","_" | ConvertFrom-Json

                    $HashRate = if($Data.SUMMARY.HS_5s -ne $null){[Double]$Data.SUMMARY.HS_5s*[Math]::Pow($Multiplier,0)}
                        elseif($Data.SUMMARY.KHS_5s -ne $null){[Double]$Data.SUMMARY.KHS_5s*[Math]::Pow($Multiplier,1)}
                        elseif($Data.SUMMARY.MHS_5s -ne $null){[Double]$Data.SUMMARY.MHS_5s*[Math]::Pow($Multiplier,2)}
                        elseif($Data.SUMMARY.GHS_5s -ne $null){[Double]$Data.SUMMARY.GHS_5s*[Math]::Pow($Multiplier,3)}
                        elseif($Data.SUMMARY.THS_5s -ne $null){[Double]$Data.SUMMARY.THS_5s*[Math]::Pow($Multiplier,4)}
                        elseif($Data.SUMMARY.PHS_5s -ne $null){[Double]$Data.SUMMARY.PHS_5s*[Math]::Pow($Multiplier,5)}

                    if($HashRate -ne $null)
                    {
                        $HashRates += $HashRate
                        if(-not $Safe){break}
                    }

                    $HashRate = if($Data.SUMMARY.HS_av -ne $null){[Double]$Data.SUMMARY.HS_av*[Math]::Pow($Multiplier,0)}
                        elseif($Data.SUMMARY.KHS_av -ne $null){[Double]$Data.SUMMARY.KHS_av*[Math]::Pow($Multiplier,1)}
                        elseif($Data.SUMMARY.MHS_av -ne $null){[Double]$Data.SUMMARY.MHS_av*[Math]::Pow($Multiplier,2)}
                        elseif($Data.SUMMARY.GHS_av -ne $null){[Double]$Data.SUMMARY.GHS_av*[Math]::Pow($Multiplier,3)}
                        elseif($Data.SUMMARY.THS_av -ne $null){[Double]$Data.SUMMARY.THS_av*[Math]::Pow($Multiplier,4)}
                        elseif($Data.SUMMARY.PHS_av -ne $null){[Double]$Data.SUMMARY.PHS_av*[Math]::Pow($Multiplier,5)}

                    if($HashRate -eq $null){$HashRates = @(); break}
                    $HashRates += $HashRate
                    if(-not $Safe){break}

                    Start-sleep $Interval
                } while($HashRates.Count -lt 6)
            }
            "ccminer"
            {
                $Message = "summary"

                do
                {

                    for($i=0; $i -lt $Data.Count; $i++)
                    {
                     $B = $Data | Select -skip $i | Select -first 1
                     $C = $B -split ";"
                     $D = $C | Convertfrom-StringData
                     $GPUArray | Add-Member "GPU$($D)" $D
                    }  

                    if(-not $Safe){break}

                    Start-Sleep $Interval
                } while($HashRates.Count -lt 6)
            }
            "nicehashequihash"
            {
                $Message = "status"

                $Client = New-Object System.Net.Sockets.TcpClient $server, $port
                $Writer = New-Object System.IO.StreamWriter $Client.GetStream()
                $Reader = New-Object System.IO.StreamReader $Client.GetStream()
                $Writer.AutoFlush = $true

                do
                {
                    $Writer.WriteLine($Message)
                    $Request = $Reader.ReadLine()

                    $Data = $Request | ConvertFrom-Json

                    $HashRate = $Data.result.speed_hps

                    if($HashRate -eq $null){$HashRate = $Data.result.speed_sps}

                    if($HashRate -eq $null){$HashRates = @(); break}

                    $HashRates += [Double]$HashRate

                    if(-not $Safe){break}

                    Start-Sleep $Interval
                } while($HashRates.Count -lt 6)
            }
            "nicehash"
            {
                $Message = @{id = 1; method = "algorithm.list"; params = @()} | ConvertTo-Json -Compress

                $Client = New-Object System.Net.Sockets.TcpClient $server, $port
                $Writer = New-Object System.IO.StreamWriter $Client.GetStream()
                $Reader = New-Object System.IO.StreamReader $Client.GetStream()
                $Writer.AutoFlush = $true

                do
                {
                    $Writer.WriteLine($Message)
                    $Request = $Reader.ReadLine()

                    $Data = $Request | ConvertFrom-Json

                    $HashRate = $Data.algorithms.workers.speed

                    if($HashRate -eq $null){$HashRates = @(); break}

                    $HashRates += [Double]($HashRate | Measure-Object -Sum).Sum

                    if(-not $Safe){break}

                    Start-Sleep $Interval
                } while($HashRates.Count -lt 6)
            }
            "ewbf"
            {
                $Message = @{id = 1; method = "getstat"} | ConvertTo-Json -Compress

                $Client = New-Object System.Net.Sockets.TcpClient $server, $port
                $Writer = New-Object System.IO.StreamWriter $Client.GetStream()
                $Reader = New-Object System.IO.StreamReader $Client.GetStream()
                $Writer.AutoFlush = $true

                do
                {
                    $Writer.WriteLine($Message)
                    $Request = $Reader.ReadLine()

                    $Data = $Request | ConvertFrom-Json

                    $HashRate = $Data.result.speed_sps

                    if($HashRate -eq $null){$HashRates = @(); break}

                    $HashRates += [Double]($HashRate | Measure-Object -Sum).Sum

                    if(-not $Safe){break}

                    Start-Sleep $Interval
                } while($HashRates.Count -lt 6)
            }
          "claymore"
            {
                do
                {
                    $Request = Invoke-WebRequest "http://$($Server):$Port" -UseBasicParsing

                    $Data = $Request.Content.Substring($Request.Content.IndexOf("{"),$Request.Content.LastIndexOf("}")-$Request.Content.IndexOf("{")+1) | ConvertFrom-Json

                    $HashRate = $Data.result[2].Split(";")[0]
                    if($HashRate -eq $null){$HashRates = @()}
		    $HashRates += [Double]$HashRate*$Multiplier

                    if(-not $Safe){break}

		    Start-Sleep $Interval
                } while($HashRates.Count -lt 6)
            }
            "dstm" {
                $Message = "summary"

                do {
                    $Client = New-Object System.Net.Sockets.TcpClient $server, $port
                    $Writer = New-Object System.IO.StreamWriter $Client.GetStream()
                    $Reader = New-Object System.IO.StreamReader $Client.GetStream()
                    $Writer.AutoFlush = $true

                    $Writer.WriteLine($Message)

                    $Request = $Reader.ReadLine()

                    $Data = $Request | ConvertFrom-Json

                    $HashRate = [Double]($Data.result.sol_ps | Measure-Object -Sum).Sum
                    if (-not $HashRate) {$HashRate = [Double]($Data.result.speed_sps | Measure-Object -Sum).Sum} #ewbf fix
            
                    if ($HashRate -eq $null) {$HashRates = @(); break}
                    
                    $HashRates += [Double]$HashRate
                    
                    if (-not $Safe) {break}

                    Start-Sleep $Interval
                } while ($HashRates.Count -lt 6)
              }
              
            "fireice"
            {
                do
                {
                    $Request = Invoke-WebRequest "http://$($Server):$Port/h" -UseBasicParsing

                    $Data = $Request.Content -split "</tr>" -match "total*" -split "<td>" -replace "<[^>]*>",""

                    $HashRate = $Data[1]
                    if($HashRate -eq ""){$HashRate = $Data[2]}
                    if($HashRate -eq ""){$HashRate = $Data[3]}

                    if($HashRate -eq $null){$HashRates = @(); break}

                    $HashRates += [Double]$HashRate

                    if(-not $Safe){break}

                    Start-Sleep $Interval
               } while($HashRates.Count -lt 6)
            }
            "wrapper"
            {
                do
                {
                    $HashRate = Get-Content ".\Wrapper_$Port.txt"


                    if($HashRate -eq $null){$HashRates = @(); break}

                    $HashRates += [Double]$HashRate

                    if(-not $Safe){break}

		   Start-Sleep $Interval
                } while($HashRates.Count -lt 6)
            }
        }

        $HashRates_Info = $HashRates | Measure-Object -Maximum -Minimum -Average
        if($HashRates_Info.Maximum-$HashRates_Info.Minimum -le $HashRates_Info.Average*$Delta){$HashRates_Info.Maximum}

        $HashRates_Info_Dual = $HashRates_Dual | Measure-Object -Maximum -Minimum -Average
        if($HashRates_Info_Dual.Maximum-$HashRates_Info_Dual.Minimum -le $HashRates_Info_Dual.Average*$Delta){$HashRates_Info_Dual.Maximum}
    }
    catch
    {
    }
}
