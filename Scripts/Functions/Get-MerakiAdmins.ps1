#Requires -version 7.0
function Get-MerakiAdmins {
    <#
    .SYNOPSIS
        Connects to v1 of the Meraki API and get's admins of a network

    .PARAMETER apiKey
        The apiKey. Typically stored in $env:apiKey

    .PARAMETER networkID
        The Meraki orgID

    .EXAMPLE
        Get-MerakiAdmins -apiKey $apiKey -networkID "123456"

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
        [string]$orgID
    )

    $response = Get-MerakiAPI -apiKey $apiKey -path "organizations/$($orgID)/admins"
    return $response
}