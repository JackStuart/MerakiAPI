#Requires -version 7.0
function Get-MerakiNetworks {
    <#
    .SYNOPSIS
        Get's the networks inside of a specific OrgID

    .PARAMETER apiKey
        The apiKey. Typically stored in $env:apiKey

    .PARAMETER orgID
        Your OrgID

    .EXAMPLE
        Get-MerakiNetworks -apiKey $apiKey -orgID "12345"

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

    $response = Get-MerakiAPI -apiKey $apiKey -path "organizations/$($orgID)/networks"
    return $response
}