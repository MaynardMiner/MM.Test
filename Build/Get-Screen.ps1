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
        [String]$Type
     )

     $Dir = (Split-Path $script:MyInvocation.MyCommand.Path)
     $LogStart = Join-Path (Split-Path $Dir) "Logs"
     Set-Location $LogStart
     if(Test-Path "$($Type).log"){$Log = Get-Content "$($Type).log"}
     if($Type -eq "miner"){if(Test-Path "*Active*"){$Log = Get-Content "*Active.log"}}
     $Log | Select -Last 100
     