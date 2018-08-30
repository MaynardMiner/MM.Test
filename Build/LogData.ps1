param(
        [Parameter(Mandatory=$false)]
        [String]$DeviceCall,
        [Parameter(Mandatory=$false)]
        [String]$Type,
        [Parameter(Mandatory=$false)]
        [array]$GPUS,
        [Parameter(Mandatory=$false)]
        [String]$WorkingDir,
        [Parameter(Mandatory=$false)]
        [String]$Miner_Algo,
        [Parameter(Mandatory=$false)]
        [String]$API,
        [Parameter(Mandatory=$false)]
        [String]$Port
    )

 Set-Location $WorkingDir
 . .\Build\Unix\IncludeCoin.ps1
 While($true)
 {
 $MinerAlgo = "$($Miner_Algo)"
 $HashPath = Join-Path ".\Logs" "$($Type).log"
 switch($DeviceCall)
 {
  "TRex"
     {
     if(Test-Path $HashPath)
       {
        $Miner_HashRates = Get-HashRate $API $Port
        $TotalHashRate = ($Miner_HashRates/1000)
        $TotalHashRate | Out-File ".\Build\Unix\Hive\totalhash.sh"
        $Convert = [string]$GPUS -replace (","," ")
        $GPU = $Convert -split ' '
        $HashArray = @()
        $Hash = @()
	      $A = $null
        $A = Get-Content $HashPath
        for($i = 0; $i -lt $GPU.Count; $i++)
        {
           $Selected = $GPU | Select -skip $i | Select -First 1
           $B = $A | Select-String  "GPU #$($Selected):" | Select -Last 1
           if($B -ne $null)
            {
             if([regex]::match($B,"MH/s").success  -eq $true){$CHash = "MH/s"}
             else{$CHash = "kH/s"}
             if([regex]::match($B,"MH/s").success  -eq $true){$Hash += "MH/s"}
             else{$Hash += "kH/s"}
             $C = $B -replace (" ","") -split "-" -split "$CHash" | Select-String -SimpleMatch "."
             $C | foreach{$HashArray += $_}
            }
           else
            {
             $Hash += "kH/s"
             $HashArray += 0
            }
        }
        $J = $HashArray | % {iex $_}
        $K = @()
        for($i = 0; $i -lt $Hash.Count; $i++)
          {
           $SelectedHash = $Hash | Select -skip $i | Select -First 1
           $SelectedPattern = $J | Select -skip $i | Select -First 1
           $SelectedPattern | foreach { if ($SelectedHash -eq "MH/s"){$K += $($_)*1000}else{$K += $_}}
          }
        $K -join ' ' | Set-Content  ".\Build\Unix\Hive\hashrates.sh"
        Write-Host "Sending HashRates To Hive $($K)" -foregroundcolor green
        $KK = $A | Select-String "ms" | Select-String " OK " | Select -Last 1
        $LL = $KK -split "]" | Select-String "/"
        $MM = $LL -split " -" | Select -First 1
        $NN = $MM -replace (" ", "     ")
        $OO = $NN -split ("     ") | Select -Last 1
        [string]$Accepted = $OO -Split "/" | Select -First 1
        [string]$Rejected = $OO -Split "/" | Select -Last 1
        $Accepted | Set-Content  ".\Build\Unix\Hive\accepted.sh"
        $Rejected | Set-Content  ".\Build\Unix\Hive\rejected.sh"
        Write-Host "Sending Acc/Rejected to Hive $Accepted $Rejected"
          }
       else{$Hashrates = 0}
       Start-Sleep -S 1
       $MinerAlgo | Out-File ".\Build\Unix\Hive\algo.sh"
       Write-Host "Current Algorithm is $MinerAlgo"
       Start-Sleep -S 2
          }
    "ccminer"
      {
       Write-Host "Logging not needed for this miner" -foregroundcolor yellow
       Start-Sleep -S 10
      }
    "claymore"
      {
       Write-Host "Logging not needed for this miner" -foregroundcolor yellow
       Start-Sleep -S 10
      }
    "dstm"
      {
       Write-Host "Logging not needed for this miner" -foregroundcolor yellow
       Start-Sleep -S 10
      }
    "ewbf"
      {
       Write-Host "Logging not needed for this miner" -foregroundcolor yellow
       Start-Sleep -S 10
      }
      "sgminer-gm"
      {
       Write-Host "Logging not needed for this miner" -foregroundcolor yellow
       Start-Sleep -S 10
      }
      "tdxminer"
      {        
        $Convert = [string]$GPUS -replace (","," ")
        $GPU = $Convert -split ' '
        $HashArray = @()
        $Hash = @()
	      $A = $null
        $A = Get-Content $HashPath
        for($i = 0; $i -lt $GPU.Count; $i++)
        {
         $Selected = $GPU | Select -skip $i | Select -First 1
           $B = $A | Select-String "GPU $($Selected)" | Select-String "Stats" | Select -Last 1
           if($B -ne $null)
            {
             if([regex]::match($B,"Mh/s").success -eq $true){$CHash = "Mh/s"}
             else{$CHash = "Kh/s"}
             if([regex]::match($B,"Mh/s").success -eq $true){$Hash += "Mh/s"}
             else{$Hash += "Kh/s"}
             $D = $B -split ":" | Select-String "$CHash"
             $E = $D -replace (" ","")
             $F = $E -replace ("h/s\)","") | Select-String "$Chash"
             $G = $F -split "\(" | Select-String "$Chash"
             $H = $G -replace ("$Chash","")
             $H | foreach{$HashArray += $_}
            }
            else
            {
             $Hash += "Kh/s"
             $HashArray += 0
            }
        }
        $J = $HashArray | % {iex $_}
        $K = @()
        for($i = 0; $i -lt $Hash.Count; $i++)
          {
           $SelectedHash = $Hash | Select -skip $i | Select -First 1
           $SelectedPattern = $J | Select -skip $i | Select -First 1
           $SelectedPattern | foreach { if ($SelectedHash -eq "Mh/s"){$K += $_*1000}else{$K += $_}}
          }
        $K -join ' ' | Set-Content  ".\Build\Unix\Hive\hashrates.sh"
        Write-Host "Sending HashRates To Hive $($K)" -foregroundcolor green
        $Accepted = ($A | Select-String "accepted").Count
        $Rejected = ($A | Select-String "rejected").Count
        $Total = 0
        $TotalRaw = 0
        $K | foreach{
        if($SelectedHash -eq "Mh/s"){$TotalRaw += ($_*1000)}
        }
        $K | foreach{
          if($SelectedHash -eq "Mh/s"){$Total += ($_)}
          }
        $Total | Set-Content ".\Build\Unix\Hive\totalhash.sh"
        $TotalRaw | Set-Content ".\Build\Unix\Hive\totalhashraw.sh"
        Write-Host "Sending TotalHash To Hive $($Total)" -foregroundcolor green
        $Accepted | Set-Content  ".\Build\Unix\Hive\accepted.sh"
        $Rejected | Set-Content  ".\Build\Unix\Hive\rejected.sh"
        Write-Host "Sending Acc/Rejected to Hive $Accepted $Rejected"
        Start-Sleep -S 1
        $MinerAlgo | Out-File ".\Build\Unix\Hive\algo.sh"
        Write-Host "Current Algorithm is $MinerAlgo"  
       Start-Sleep -S 2
      }
    } 
  }
