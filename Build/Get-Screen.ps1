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
     