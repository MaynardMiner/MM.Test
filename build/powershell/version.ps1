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
    [parameter(Mandatory=$false)]
    [String]$Name,
    [parameter(Mandatory=$false)]
    [String]$Uri,
    [parameter(Mandatory=$false)]
    [String]$EXE,
    [parameter(Mandatory=$false)]
    [String]$Version,
    [parameter(Mandatory=$false)]
    [String]$Command
)
Set-Location (Split-Path (Split-Path (Split-Path $script:MyInvocation.MyCommand.Path)))

if($Command -eq "!"){Write-Host "No Command Given. Try version query"}
else{$CommandQuery = $Command -replace("!","")
Write-Host "Executing Command: $CommandQuery"
Write-Host "                   " }
$CudaVersion = Get-Content ".\build\txt\cuda.txt"
if($CudaVersion -eq "9.1"){$miner_update_nvidia = Get-Content ".\config\update\nvidia9.1-linux.conf" | ConvertFrom-Json}
if($CudaVersion -eq "9.2"){$miner_update_nvidia = Get-Content ".\config\update\nvidia9.2-linux.conf" | ConvertFrom-Json}
$miner_update_amd = Get-Content ".\config\update\amd-linux.conf" | ConvertFrom-Json
$miner_update_cpu = Get-Content ".\config\update\cpu-linux.conf" | ConvertFrom-Json

$nvidia = [PSCustomObject]@{}
$amd = [PSCustomObject]@{}
$cpu = [PSCustomObject]@{}

$miner_update_nvidia | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {$nvidia | Add-Member $miner_update_nvidia.$_.Name $miner_update_nvidia.$_}
$miner_update_amd | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {$amd | Add-Member $miner_update_amd.$_.Name $miner_update_amd.$_}
$miner_update_cpu | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {$cpu | Add-Member $miner_update_cpu.$_.Name $miner_update_cpu.$_}

$nvidiatable = @()
$amdtable = @()
$cputable = @()

$nvidia | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {
    $nvidiatable += [PSCustomObject]@{
     Name = $nvidia.$_.Name
     Type = $nvidia.$_.Type
     MinerName = $nvidia.$_.MinerName
     Version = $nvidia.$_.version
    }
}

$amd | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {
    $amdtable += [PSCustomObject]@{
     Name = $amd.$_.Name
     Type = $amd.$_.Type
     MinerName = $amd.$_.MinerName
     Version = $amd.$_.version
    }
}

$cpu | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {
    $cputable += [PSCustomObject]@{
     Name = $cpu.$_.Name
     Type = $cpu.$_.Type
     MinerName = $cpu.$_.MinerName
     Version = $cpu.$_.version
    }
}



if($Command -eq "!query")
 {
    $nvidiatable | Sort-Object -Property Type,Name | Format-Table (
        @{Label = "Name"; Expression={$($_.Name)}},
        @{Label = "Type"; Expression={$($_.Type)}},
        @{Label = "Executable"; Expression={$($_.MinerName)}},
        @{Label = "Version"; Expression={$($_.Version)}}
    ) | Out-Host
    $amdtable | Sort-Object -Property Type,Name | Format-Table (
        @{Label = "Name"; Expression={$($_.Name)}},
        @{Label = "Type"; Expression={$($_.Type)}},
        @{Label = "Executable"; Expression={$($_.MinerName)}},
        @{Label = "Version"; Expression={$($_.Version)}}
    ) | Out-Host
    $cputable | Sort-Object -Property Type,Name | Format-Table (
        @{Label = "Name"; Expression={$($_.Name)}},
        @{Label = "Type"; Expression={$($_.Type)}},
        @{Label = "Executable"; Expression={$($_.MinerName)}},
        @{Label = "Version"; Expression={$($_.Version)}}
    ) | Out-Host
}

if($Command -eq "!update")
 {
    $Name = $Name -replace ("!","")
    Write-Host "Stopping Miner & Waiting 5 Seconds"
    miner stop
    Start-Sleep -S 5
    $newEXE = $EXE -replace("!","")
    $newVersion = $Version -replace("!","")
    $newURI = $uri -replace("!","")
    $nvidiaupdate = $false
    $amdupdate = $false
    $cpuupdate = $false

    $nvidia | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {
     if($Name -eq $nvidia.$_.name)
      {
       $nvidia.$_.minername = $newEXE 
       $nvidia.$_.version = $newversion
       $nvidia.$_.uri = $newuri 
       Write-Host "$Name new executable is $newEXE"
       Write-Host "$Name new uri is $newuri"
       Write-Host "$Name new version is $newversion"
       if(Test-Path ".\bin\*$Name*"){Remove-Item ".\bin\*$Name*" -Recurse -Force}
       if($CudaVersion -eq "9.1"){$nvidia | ConvertTo-Json | Set-Content ".\config\update\nvidia9.1-linux.conf" -Force}
       if($CudaVersion -eq "9.2"){$nvidia | ConvertTo-Json | Set-Content ".\config\update\nvidia9.2-linux.conf" -Force}
      }
    }

     if($nvidiaupdate -eq $true)
     { 
        $newupdate = @()
        $nvidia | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {$nvidia.$_ | foreach {$newupdate += $_}}
        $newupdate | ConvertTo-Json | Out-File ".\config\update\nvidia-linux.conf"
     }

    $amd | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {
     if($Name -eq $amd.$_.name)
      {
       $amd.$_.minername = $newEXE
       $amd.$_.version = $newVersion
       $amd.$_.uri = $newuri
       Write-Host "$Name new executable is $newexe"
       Write-Host "$Name new uri is $newuri"
       Write-Host "$Name new version is $newversion"
       if(Test-Path ".\bin\*$Name*"){Remove-Item ".\bin\*$Name*" -Recurse -Force}
       $amdupdate = $true
       $amd | ConvertTo-Json | Set-Content ".\config\update\amd-linux.conf" -Force
      }
    }

    if($amdupdate -eq $true)
    { 
       $newupdate = @()
       $amd | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {$amd.$_ | foreach {$newupdate += $_}}
       $newupdate | ConvertTo-Json | Out-File ".\config\update\amd-linux.conf"
    }

    $cpu | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {
     if($Name -eq $cpu.$_.name)
      {
       $cpu.$_.minername = $newEXE
       $cpu.$_.version = $newVersion
       $cpu.$_.uri = $newuri
       Write-Host "$Name new executable is $newexe"
       Write-Host "$Name new uri is $newuri"
       Write-Host "$Name new version is $newversion"
       if(Test-Path ".\bin\*$Name*"){Remove-Item ".\bin\*$cpu*" -Recurse -Force}
       $cpu | ConvertTo-Json | Set-Content ".\config\update\cpu-linux.conf" -Force
       $cpuupdate = $true
      }
    }

    if($cpuupdate -eq $true)
    { 
       $newupdate = @()
       $cpu | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {$cpu.$_ | foreach {$newupdate += $_}}
       $newupdate | ConvertTo-Json | Out-File ".\config\update\cpu-linux.conf"
    }

    Write-Host "Miner Was Updated" -ForegroundColor Green
    Write-Host "Restarting Miner With New Settings"
    miner start
}
