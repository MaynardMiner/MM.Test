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
function Get-GPUCount {
    param (
        [Parameter(Mandatory=$true)]
        [Array]$DeviceType,
        [Parameter(Mandatory=$true)]
        [String]$CmdDir,
        [Parameter(Mandatory=$false)]
        [String]$CPUThreads,
        [Parameter(Mandatory=$false)]
        [String]$Platforms
    )

    $GPU_Count = 0
    $nvidiacounted = $false
    $amdcounted = $false
    $DeviceType | foreach{
    if($Platforms -eq "Linux")
      {
       if($_ -like "*NVIDIA*" -and $nvidiacounted -eq $false)
        {
       $nvidiacounted = $true
       Write-Host "Getting NVIDIA GPU Count" -foregroundcolor cyan
       lspci | Tee-Object ".\build\txt\gpucount.txt" | Out-Null
       $GCount = Get-Content ".\build\txt\gpucount.txt" -Force
       $AttachedGPU = $GCount | Select-String "VGA","3d" | Select-String "NVIDIA"   
       [int]$GPU_Count += $AttachedGPU.Count
       }
      if($_ -like "*AMD*" -and $amdcounted -eq $false)
       {
         $amdcounted = $true
         Write-Host "Getting AMD GPU Count" -foregroundcolor cyan
         lspci | Tee-Object ".\build\txt\gpucount.txt" | Out-Null
         $GCount = Get-Content ".\build\txt\gpucount.txt" -Force
         $AttachedGPU = $GCount | Select-String "VGA" | Select-String "AMD"   
         [int]$GPU_Count += $AttachedGPU.Count
       }
      }
    if($Platforms -eq "Windows")
     {
      if($_ -like "*NVIDIA*" -and $nvidiacounted -eq $false)
      {
        $nvidiacounted = $true
       $GPU_Count += ((Get-WMIObject Win32_VideoController).Name | Select-String "NVIDIA").count
      }
      if($_ -like "*AMD*" -and $amdcounted -eq $false)
      {
        $amdcounted = $true
        $GPU_Count += ((Get-WMIObject Win32_VideoController).Name | Select-String "AMD").count       
      }
     }
   }
    
    $GPU_Count  
}
