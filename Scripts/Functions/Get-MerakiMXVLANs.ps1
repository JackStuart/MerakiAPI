#Requires -version 7.0
function Get-MerakiMXVLANs {
    <#
    .SYNOPSIS
        Connects to v1 of the Meraki API and get's the port settings for a given network

    .PARAMETER apiKey
        The apiKey. Typically stored in $env:apiKey

    .PARAMETER networkID
        The Meraki NetworkID. Please note only MX devices will work with this API call 

    .EXAMPLE
        Get-MerakiMXVLANs -apiKey $apiKey -networkID "123456"

    .LINK
        https://developer.cisco.com/meraki/api-v1/#!getting-started
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [validateNotNullorEmpty()]
        [string]$apiKey,

        [Parameter(Mandatory = $true, Position = 1)]
        [validateNotNullorEmpty()]
        [string]$networkID
    )

    #Confirm an MX actually exists in the network and doesn't just have the "appliance type"
    $devices = Get-MerakiAPI -apiKey $apiKey -path "networks/$($networkID)/devices" | Where-Object { $_.model -like "MX*" }
    if ($null -ne $devices) {
        $response = Get-MerakiAPI -apiKey $apiKey -path "networks/$($networkID)/appliance/vlans"
        return $response
    }
}