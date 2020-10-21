
$apiKey = ""
$path = "" #File Path - e.g. C:\temp

$orgID = Get-MerakiAPI -apiKey $apiKey -path "organizations"
$networks = Get-MerakiAPI -apiKey $apiKey -path ("organizations/" + $orgID.id + "/networks") | Where-Object {$_.productTypes -contains "appliance"}

foreach($network in $networks){
    $1ToMany = Get-MerakiAPI -apiKey $apiKey -path ("networks/" + $network.id + "/appliance/firewall/oneToManyNatRules")
    $1To1 = Get-MerakiAPI -apiKey $apiKey -path ("networks/" + $network.id + "/appliance/firewall/oneToOneNatRules")
    $PortForward = Get-MerakiAPI -apiKey $apiKey -path ("networks/" + $network.id + "/appliance/firewall/portForwardingRules")

    $1ToMany | ConvertTo-Json | Out-File -FilePath "$($path)\$($network.name)-1ToMany.json"
    $1To1 | ConvertTo-Json | Out-File -FilePath "$($path)\$($network.name)-1To1.json"
    $PortForward | ConvertTo-Json | Out-File -FilePath "$($path)\$($network.name)-PortForward.json"
}
