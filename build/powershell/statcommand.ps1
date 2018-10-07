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

function get-stats {
param(
[Parameter(Mandatory=$true)]
[String]$Timeouts
)

if($Timeouts -eq "No")
{ 
$GetStats = [PSCustomObject]@{}
if(Test-Path "stats"){Get-ChildItemContent "stats" | ForEach {$GetStats | Add-Member $_.Name $_.Content}}
$GetStats
}

if($TimeOuts -eq "Yes")
 {
  $GetStats = if(Test-Path "./stats"){Get-ChildItemContent "./stats"}
  $GetStats | ForEach-Object{
    if($_.Content.Live -eq 0)
     {
      $Removed = Join-Path "./stats" "$($_.Name).txt"
      $Change = $($_.Name) -replace "hashrate","TIMEOUT"
      if(Test-Path (Join-Path "./timeout" "$($Change).txt")){Remove-Item (Join-Path "./timeout" "$($Change).txt") -Force}
	  Remove-Item $Removed -Force
      Write-Host "$($_.Name) Hashrate and Timeout Notification was Removed"
     }
   }
   Write-Host "Cleared Timeouts" -ForegroundColor Red
}

}

function Set-Stat {
  param(
      [Parameter(Mandatory=$true)]
      [String]$Name, 
      [Parameter(Mandatory=$true)]
      [Double]$Value, 
      [Parameter(Mandatory=$false)]
      [DateTime]$Date = (Get-Date)
  )

  $Path = "stats\$Name.txt"
  $Date = $Date.ToUniversalTime()
  $SmallestValue = 1E-20

  $Stat = [PSCustomObject]@{
      Live = $Value
      Minute = $Value
      Minute_Fluctuation = 1/2
      Minute_5 = $Value
      Minute_5_Fluctuation = 1/2
      Minute_10 = $Value
      Minute_10_Fluctuation = 1/2
      Hour = $Value
      Hour_Fluctuation = 1/2
      Day = $Value
      Day_Fluctuation = 1/2
      Week = $Value
      Week_Fluctuation = 1/2
      Updated = $Date
  }

  if(Test-Path $Path){$Stat = Get-Content $Path | ConvertFrom-Json}

  $Stat = [PSCustomObject]@{
      Live = [Double]$Stat.Live
      Minute = [Double]$Stat.Minute
      Minute_Fluctuation = [Double]$Stat.Minute_Fluctuation
      Minute_5 = [Double]$Stat.Minute_5
      Minute_5_Fluctuation = [Double]$Stat.Minute_5_Fluctuation
      Minute_10 = [Double]$Stat.Minute_10
      Minute_10_Fluctuation = [Double]$Stat.Minute_10_Fluctuation
      Hour = [Double]$Stat.Hour
      Hour_Fluctuation = [Double]$Stat.Hour_Fluctuation
      Day = [Double]$Stat.Day
      Day_Fluctuation = [Double]$Stat.Day_Fluctuation
      Week = [Double]$Stat.Week
      Week_Fluctuation = [Double]$Stat.Week_Fluctuation
      Updated = [DateTime]$Stat.Updated
  }
  
  $Span_Minute = [Math]::Min(($Date-$Stat.Updated).TotalMinutes,1)
  $Span_Minute_5 = [Math]::Min((($Date-$Stat.Updated).TotalMinutes/5),1)
  $Span_Minute_10 = [Math]::Min((($Date-$Stat.Updated).TotalMinutes/10),1)
  $Span_Hour = [Math]::Min(($Date-$Stat.Updated).TotalHours,1)
  $Span_Day = [Math]::Min(($Date-$Stat.Updated).TotalDays,1)
  $Span_Week = [Math]::Min((($Date-$Stat.Updated).TotalDays/7),1)

  $Stat = [PSCustomObject]@{
      Live = $Value
      Minute = ((1-$Span_Minute)*$Stat.Minute)+($Span_Minute*$Value)
      Minute_Fluctuation = ((1-$Span_Minute)*$Stat.Minute_Fluctuation)+
          ($Span_Minute*([Math]::Abs($Value-$Stat.Minute)/[Math]::Max([Math]::Abs($Stat.Minute),$SmallestValue)))
      Minute_5 = ((1-$Span_Minute_5)*$Stat.Minute_5)+($Span_Minute_5*$Value)
      Minute_5_Fluctuation = ((1-$Span_Minute_5)*$Stat.Minute_5_Fluctuation)+
          ($Span_Minute_5*([Math]::Abs($Value-$Stat.Minute_5)/[Math]::Max([Math]::Abs($Stat.Minute_5),$SmallestValue)))
      Minute_10 = ((1-$Span_Minute_10)*$Stat.Minute_10)+($Span_Minute_10*$Value)
      Minute_10_Fluctuation = ((1-$Span_Minute_10)*$Stat.Minute_10_Fluctuation)+
          ($Span_Minute_10*([Math]::Abs($Value-$Stat.Minute_10)/[Math]::Max([Math]::Abs($Stat.Minute_10),$SmallestValue)))
      Hour = ((1-$Span_Hour)*$Stat.Hour)+($Span_Hour*$Value)
      Hour_Fluctuation = ((1-$Span_Hour)*$Stat.Hour_Fluctuation)+
          ($Span_Hour*([Math]::Abs($Value-$Stat.Hour)/[Math]::Max([Math]::Abs($Stat.Hour),$SmallestValue)))
      Day = ((1-$Span_Day)*$Stat.Day)+($Span_Day*$Value)
      Day_Fluctuation = ((1-$Span_Day)*$Stat.Day_Fluctuation)+
          ($Span_Day*([Math]::Abs($Value-$Stat.Day)/[Math]::Max([Math]::Abs($Stat.Day),$SmallestValue)))
      Week = ((1-$Span_Week)*$Stat.Week)+($Span_Week*$Value)
      Week_Fluctuation = ((1-$Span_Week)*$Stat.Week_Fluctuation)+
          ($Span_Week*([Math]::Abs($Value-$Stat.Week)/[Math]::Max([Math]::Abs($Stat.Week),$SmallestValue)))
      Updated = $Date
  }

  if(-not (Test-Path "stats")){New-Item "stats" -ItemType "directory"}
  [PSCustomObject]@{
      Live = [Decimal]$Stat.Live
      Minute = [Decimal]$Stat.Minute
      Minute_Fluctuation = [Double]$Stat.Minute_Fluctuation
      Minute_5 = [Decimal]$Stat.Minute_5
      Minute_5_Fluctuation = [Double]$Stat.Minute_5_Fluctuation
      Minute_10 = [Decimal]$Stat.Minute_10
      Minute_10_Fluctuation = [Double]$Stat.Minute_10_Fluctuation
      Hour = [Decimal]$Stat.Hour
      Hour_Fluctuation = [Double]$Stat.Hour_Fluctuation
      Day = [Decimal]$Stat.Day
      Day_Fluctuation = [Double]$Stat.Day_Fluctuation
      Week = [Decimal]$Stat.Week
      Week_Fluctuation = [Double]$Stat.Week_Fluctuation
      Updated = [DateTime]$Stat.Updated
  } | ConvertTo-Json | Set-Content $Path 

  $Stat
}

function Get-Stat {
  param(
      [Parameter(Mandatory=$true)]
      [String]$Name
  )

  if(-not (Test-Path "stats")){New-Item "stats" -ItemType "directory"}
  Get-ChildItem "stats" | Where-Object Extension -NE ".ps1" | Where-Object BaseName -EQ $Name | Get-Content | ConvertFrom-Json
}

function Remove-Stat {
  param(
        [Parameter(Mandatory=$true)]
  [String]$Name
 )

   $Remove = Join-Path ".\stats" "$Name"
   if(Test-Path $Remove)
    {
Remove-Item -path $Remove
    }
}

