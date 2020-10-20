$apiKey = ""
$path = ""

$orgID = Get-MerakiAPI -apiKey $apiKey -path "organizations"
$networks = Get-MerakiAPI -apiKey $apiKey -path ("organizations/" + $orgID.id + "/networks") | Where-Object {$_.productTypes -contains "appliance"}

foreach($network in $networks){
    $L3Rules = Get-MerakiAPI -apiKey $apiKey -path ("networks/" + $network.id + "/appliance/firewall/l3FirewallRules")
    $L3Rules | ConvertTo-Json | Out-File -FilePath "$($path)\$($network.name).json"
}