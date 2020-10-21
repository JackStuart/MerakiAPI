#Requires -version 7.0
function Get-MerakiMXTrafficShaping {
    <#
    .SYNOPSIS
        Connects to v1 of the Meraki API and get's the port settings for a given network

    .PARAMETER apiKey
        The apiKey. Typically stored in $env:apiKey

    .PARAMETER networkID
        The Meraki NetworkID. Please note only MX devices will work with this API call 

    .EXAMPLE
        Get-MerakiMXTrafficShaping -apiKey $apiKey -networkID "123456"

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

    $response = Get-MerakiAPI -apiKey $apiKey -path "networks/$($networkID)/appliance/trafficShaping"
    return $response
}