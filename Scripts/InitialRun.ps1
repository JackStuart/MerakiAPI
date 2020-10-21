#Requires -version 7.0
<#
    .SYNOPSIS
        This script should be run when you want to have a "fresh start". It will get all config AS IS from the Meraki Portal and remove all old content 

    .PARAMETER apiKey
        The apiKey. Typically stored in $env:apiKey

    .EXAMPLE
        .\InitialRun.ps1

    .LINK
        https://developer.cisco.com/meraki/api-v1/#!getting-started
    #>

$apiKey = ""

$orgID = Get-MerakiOrgID -apiKey $apiKey
$networks = Get-MerakiNetworks -apiKey $apiKey -orgID $orgID.id | sort name

#Clean's all old items
Remove-Item .\Deployment\* -Recurse -Force

#Creates Directory Paths
foreach ($network in $networks) {
    New-Item -Path ".\Deployment\Networks\$($network.name)" -ItemType Directory

    if ($network.productTypes -contains "appliance") {
        New-Item -path ".\Deployment\Networks\$($network.name)\appliance" -ItemType Directory

        #If the network contains an appliance. Return all information about it
        (Get-MerakiL3FWRules -apiKey $apiKey -networkID $network.id) | ConvertTo-Json -Depth 10 | Out-File -FilePath ".\Deployment\Networks\$($network.name)\appliance\L3Rules.json"
        (Get-Meraki1toManyNAT -apiKey $apiKey -networkID $network.id) | ConvertTo-Json -Depth 10 | Out-File -FilePath ".\Deployment\Networks\$($network.name)\appliance\1toManyNAT.json"
        (Get-Meraki1to1NAT -apiKey $apiKey -networkID $network.id) | ConvertTo-Json -Depth 10 | Out-File -FilePath ".\Deployment\Networks\$($network.name)\appliance\1to1NAT.json"
        (Get-MerakiPortForwards -apiKey $apiKey -networkID $network.id) | ConvertTo-Json -Depth 10| Out-File -FilePath ".\Deployment\Networks\$($network.name)\appliance\Portforwards.json"
        (Get-MerakiContentFiltering -apiKey $apiKey -networkID $network.id) | ConvertTo-Json -Depth 10| Out-File -FilePath ".\Deployment\Networks\$($network.name)\appliance\MerakiContentFiltering.json"
        (Get-MerakiMXPorts -apiKey $apiKey -networkID $network.id) | ConvertTo-Json -Depth 10| Out-File -FilePath ".\Deployment\Networks\$($network.name)\appliance\MerakiMXPorts.json"
        (Get-MerakiMXTrafficShaping -apiKey $apiKey -networkID $network.id) | ConvertTo-Json -Depth 10| Out-File -FilePath ".\Deployment\Networks\$($network.name)\appliance\MerakiMXTrafficShaping.json"
        (Get-MerakiMXVLANs -apiKey $apiKey -networkID $network.id) | ConvertTo-Json -Depth 10| Out-File -FilePath ".\Deployment\Networks\$($network.name)\appliance\MerakiMXVLANs.json"

    }

    if ($network.productTypes -contains "camera") {
        New-Item -path ".\Deployment\Networks\$($network.name)\camera" -ItemType Directory
    }

    if ($network.productTypes -contains "switch") {
        New-Item -path ".\Deployment\Networks\$($network.name)\switch" -ItemType Directory
    }

    if ($network.productTypes -contains "wireless") {
        New-Item -path ".\Deployment\Networks\$($network.name)\wireless" -ItemType Directory
    }
}