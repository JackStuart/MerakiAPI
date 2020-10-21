#Requires -version 7.0
function Get-MerakiOrgID {
    <#
    .SYNOPSIS
        Get's the OrgID that your apiKey has access to 

    .PARAMETER apiKey
        The apiKey. Typically stored in $env:apiKey

    .EXAMPLE
        Get-MerakiOrgID -apiKey $apiKey

    .LINK
        https://developer.cisco.com/meraki/api-v1/#!getting-started
    #>
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [validateNotNullorEmpty()]
        [string]$apiKey
    )

    $response = Get-MerakiAPI -apiKey $apiKey -path "organizations"
    return $response
}