function Get-Power {
    param(
    [Parameter(Mandatory=$false)]
    [Array]$PwrType="none"
    )

    if($PwrType -ne "none")
     {
      if($PwrType -like "*NVIDIA*")
       {
        $CardPower = ".\build\txt\powerup.txt"
        if(Test-Path $CardPower){Clear-Content $CardPower}
        Start-Process ".\build\bash\nvidia.sh" -Wait
       }

      elseif($PwrType -like "*AMD*")
       {
        $CardPower = ".\build\txt\powerup.txt"
        if(Test-Path $CardPower){Clear-Content $CardPower}
        Start-Process ".\build\bash\rocm.sh" -Wait
       }
     }
}

function Set-Power {
    param(
    [Parameter(Mandatory=$false)]
    [String]$PwrDevices = "none",
    [Parameter(Mandatory=$false)]
    [String]$PwrCount,
    [Parameter(Mandatory=$false)]
    [array]$PwrType
    ) 

if($PwrType -like "*NVIDIA*")
 {
if($PwrDevices -ne "none")
 {
$PwrDevices = $PwrDevices -replace (","," ")
if($PwrDevices -match " "){$NewDevices = $PwrDevices -split " "}else{$NewDevices = $PwrDevices -split ""}
$NewDevices = Switch($NewDevices){"a"{"10"};"b"{"11"};"c"{"12"};"e"{"13"};"f"{"14"};"g"{"15"};"h"{"16"};"i"{"17"};"j"{"18"};"k"{"19"};"l"{"20"};default{"$_"};}
if($PwrDevices -match " "){$PwrGPU = $NewDevices}else{$PwrGPU = $NewDevices | ? {$_.trim() -ne ""}}
$PwrGPU = $PwrGPU | % {iex $_}
}
else{
 $PwrGPU = @()
 $GetDevices = 0
 for($i=0;$i -lt $PwrCount;$i++){$PwrGPU += $GetDevices++}
}

  $GetPower = Get-Content ".\build\txt\powerup.txt"
  $PowerUp = $GetPower | Select-String "MiB" | Select-String "W"
  $PowerUp = $PowerUp -split "MiB" | Select-String "W"
  $PowerUp = $PowerUp | foreach{$_ -split "/" | Select -First 1}
  $PowerUP = $PowerUp -split " "
  $PowerUp = $PowerUp | foreach { if($_ -like "*W*"){$_}; if($_ -like "*N*"){$_} }
  $PowerUp = $PowerUP -replace ("W","")
  $PowerUp = $PowerUp -replace ("N","75")
 
  $PowerArray = @()
  
for($i=0;$i -lt $PwrGPU.Count; $i++){$Selected = $PwrGPU | Select -skip $i | Select -first 1;$Watts = $PowerUp | Select -skip $Selected | Select -first 1;$PowerArray += $Watts}
$TotalPower = 0
$PowerArray | foreach{$TotalPower += $_}
$TotalPower
 }

if($PwrType -like "*AMD*")
 {
 if($PwrDevices -ne "none")
  {
   $PwrDevices = $PwrDevices -replace (","," ")
   if($PwrDevices -match " "){$NewDevices = $PwrDevices -split " "}else{$NewDevices = $PwrDevices -split ""}
   $NewDevices = Switch($NewDevices){"a"{"10"};"b"{"11"};"c"{"12"};"e"{"13"};"f"{"14"};"g"{"15"};"h"{"16"};"i"{"17"};"j"{"18"};"k"{"19"};"l"{"20"};default{"$_"};}
   if($PwrDevices -match " "){$PwrGPU = $NewDevices}else{$PwrGPU = $NewDevices | ? {$_.trim() -ne ""}}
   $PwrGPU = $PwrGPU | % {iex $_}
  }
  else{
    $PwrGPU = @()
    $GetDevices = 0
    for($i=0;$i -lt $PwrCount;$i++){$PwrGPU += $GetDevices++}
   }

   $GetPower = Get-Content ".\build\txt\powerup.txt"
   $PowerUp = $GetPower | Select-String "W" | Select-String "%" | Foreach {$_ -replace (" ","")} |
   foreach {$_ -split "c" | Select -Last 1} | foreach { $_ -split "W" | Select -First 1}

   $PowerArray = @()
  
   for($i=0;$i -lt $PwrGPU.Count; $i++){$Selected = $PwrGPU | Select -skip $i | Select -first 1;$Watts = $PowerUp | Select -skip $Selected | Select -first 1;$PowerArray += $Watts}
   $TotalPower = 0
   $PowerArray | foreach{$TotalPower += $_}
   $TotalPower
 }
}