
$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName 
 
 
 $blockpool_Request = [PSCustomObject]@{} 
 
 if($Auto_Algo -eq "Yes")
  { 
  if($Poolname -eq $Name)
   {
 try { 
     $blockpool_Request = Invoke-RestMethod "http://blockmasters.co/api/status" -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop 
 } 
 catch { 
     Write-Warning "MM.Hash contacted ($Name) for a failed API check. " 
     return 
 }
 
 if (($blockpool_Request | Get-Member -MemberType NoteProperty -ErrorAction Ignore | Measure-Object Name).Count -le 1) { 
     Write-Warning "MM.Hash contacted ($Name) but ($Name) Pool API had issues. " 
     return 
 } 
  
$Location = "US"

$blockpool_Request | Get-Member -MemberType NoteProperty -ErrorAction Ignore | Select-Object -ExpandProperty Name | ForEach-Object {
    if($Algorithm -eq $_)
    {
    if($blockpool_Request.$_.hashrate -ne "0")
     {
      if($blockpool_Request.$_.estimate -ne "0.00000")
       {

    $blockpool_Algorithm = Get-Algorithm $blockpool_Request.$_.name
    $blockpool_Host = "blockmasters.co"
    $blockpool_Port = $blockpool_Request.$_.port
    $Divisor = (1000000*$blockpool_Request.$_.mbtc_mh_factor)

    $Stat = Set-Stat -Name "$($Name)_$($blockpool_Algorithm)_Profit" -Value ([Double]$blockpool_Request.$_.estimate_current/$Divisor *(1-($blockpool_Request.$_.fees/100)))

      if($Wallet)
       {
        If($BlockmastersWallet1 -ne ''){$blockWallet1 = $BlockmastersWallet1}
        else{$blockWallet1 = $Wallet1}
        if($BlockmastersWallet2 -ne ''){$blockWallet2 = $BlockmastersWallet2}
        else{$blockWallet2 = $Wallet2}
        if($BlockmastersWallet1 -ne ''){$blockWallet3 = $BlockmastersWallet3}
        else{$blockWallet3 = $Wallet3}
        if($Blockmasterspassword1 -ne ''){$blockpass1 = $Blockmasterspassword1}
        else{$blockpass1 = $Passwordcurrency1}
        if($Blockmasterspassword2 -ne ''){$blockpass2 = $Blockmasterspassword2}
        else{$blockpass2 = $Passwordcurrency2}
        if($Blockmasterspassword3 -ne ''){$blockpass3 = $Blockmasterspassword3}
        else{$blockpass3 = $Passwordcurrency3}
        [PSCustomObject]@{
            Coin = "No"
            Symbol = $blockpool_Algorithm
            Mining = $blockpool_Algorithm
            Algorithm = $blockpool_Algorithm
            Price = $Stat.$StatLevel
            StablePrice = $Stat.Week
            MarginOfError = $Stat.Fluctuation
            Protocol = "stratum+tcp"
            Host = $blockpool_Host
            Port = $blockpool_Port
            User1 = $blockwallet1
	        User2 = $blockwallet2
            User3 = $blockwallet3
            CPUser = $CPUWallet
            CPUPass = "c=$CPUcurrency,ID=$Rigname1"
            Pass1 = "c=$blockpass1,ID=$Rigname1"
            Pass2 = "c=$blockpass2,ID=$Rigname2"
	    Pass3 = "c=$blockpass3,ID=$Rigname3"
            Location = $Location
            SSL = $false
           }
          }
         }
        }
     }
    }
   }
 }
