
$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName 
 
 
 $ahashpool_Request = [PSCustomObject]@{} 
 
 if($Auto_Algo -eq "Yes")
  {
   if($Poolname -eq $Name)
    {
 try { 
     $ahashpool_Request = Invoke-RestMethod "https://www.ahashpool.com/api/status" -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop 
 } 
 catch { 
     Write-Warning "MM.Hash contacted ($Name) for a failed API. "
     return 
 }
 
 if (($ahashpool_Request | Get-Member -MemberType NoteProperty -ErrorAction Ignore | Measure-Object Name).Count -le 1) { 
     Write-Warning "MM.Hash contacted ($Name) but ($Name) Pool API had issues. " 
     return 
 } 
  
$Location = "US"

$ahashpool_Request | Get-Member -MemberType NoteProperty -ErrorAction Ignore | Select-Object -ExpandProperty Name | Where-Object {$ahashpool_Request.$_.hashrate -gt 0} | ForEach-Object {
    $ahashpool_Host = "$_.mine.ahashpool.com"
    $ahashpool_Port = $ahashpool_Request.$_.port
    $ahashpool_Algorithm = Get-Algorithm $ahashpool_Request.$_.name
    $ahashpool_Fees = $ahashpool_Request.$_.fees
    $Divisor = (1000000*$ahashpool_Request.$_.mbtc_mh_factor)


 if($Algorithm -eq $ahashpool_Algorithm)
      {
    if((Get-Stat -Name "$($Name)_$($ahashpool_Algorithm)_Profit") -eq $null){$Stat = Set-Stat -Name "$($Name)_$($ahashpool_Algorithm)_Profit" -Value ([Double]$ahashpool_Request.$_.estimate_current/$Divisor*(1-($ahashpool_Request.$_.fees/100)))}
    else{$Stat = Set-Stat -Name "$($Name)_$($ahashpool_Algorithm)_Profit" -Value ([Double]$ahashpool_Request.$_.estimate_current/$Divisor *(1-($ahashpool_Request.$_.fees/100)))}
     }
      
       if($Wallet)
	    {
        [PSCustomObject]@{
            Coin = "No"
            Symbol = $ahashpool_Algorithm
            Mining = $ahashpool_Algorithm
            Algorithm = $ahashpool_Algorithm
            Price = $Stat.Live
            Fees = $ahashpool_Fees
            Workers = $ahashpool_Workers
            StablePrice = $Stat.Week
            MarginOfError = $Stat.Fluctuation
            Protocol = "stratum+tcp"
            Host = $ahashpool_Host
            Port = $ahashpool_Port
            User1 = $Wallet1
	       User2 = $Wallet2
            User3 = $Wallet3
            CPUser = $CPUWallet
            CPUPass = "c=$CPUcurrency,ID=$Rigname1"
            Pass1 = "c=$Passwordcurrency1,ID=$Rigname1"
            Pass2 = "c=$Passwordcurrency2,ID=$Rigname2"
	    Pass3 = "c=$Passwordcurrency3,ID=$Rigname3"
            Location = $Location
            SSL = $false
        }
      }
     }
    }
   }