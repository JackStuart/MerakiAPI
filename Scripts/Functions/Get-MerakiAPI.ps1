function Get-MerakiAPI {
    <#
    .SYNOPSIS
        Connects to v1 of the Meraki API

    .DESCRIPTION
        Gives a "base" connection to the Meraki API and deals with all of the error handling that's required from Meraki's docs.
        https://developer.cisco.com/meraki/api-v1/#!errors

    .PARAMETER apiKey
        The apiKey. Typically stored in $env:apiKey

    .PARAMETER baseURL
        The Base URL of all API calls. Will usually be https://api.meraki.com/api/v1/ but can be manually entered

    .PARAMETER path
        The path that you wish to call. It will be prepended onto the baseURL

    .EXAMPLE
        Get-MerakiAPI -path "organizations"
        Get-MerakiAPI -path "organizations" -apiKey "123456"

    .LINK
        https://developer.cisco.com/meraki/api-v1/#!getting-started
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [validateNotNullorEmpty()]
        [string]$apiKey,

        [Parameter(Position = 1)]
        [validateNotNullorEmpty()]
        [string]$baseURL = "https://api.meraki.com/api/v1/",

        [Parameter(Mandatory = $true, Position = 2)]
        [validateNotNullorEmpty()]
        [string]$path
    )

    begin {
        $uri = $baseurl + $path
        $headers = @{
            "Content-Type"           = "application/json"
            "X-Cisco-Meraki-API-Key" = $apiKey
        }
    }

    process {
        Write-Verbose "Connecting to Meraki API - $($uri)"
        $response = Invoke-RestMethod -Method GET -Uri $uri -headers $headers -StatusCodeVariable scv -ResponseHeadersVariable responseheaders -SkipHttpErrorCheck

        if ($scv -eq 200) {
            Write-Verbose "200 - JSON recieved successfully"
        }
        elseif ($scv -eq 400) {
            Write-Error "400 - Bad Request"
            Write-Error $response.errors
        }
        elseif ($scv -eq 401) {
            $response = Write-Error "401 - Bad API Key"
        }
        elseif ($scv -eq 403) {
            $response = Write-Error "403 - Incorrect Permissions"
        }
        elseif ($scv -eq 404) {
            $response = Write-Error "404 - Page not found"
        }
        elseif ($scv -eq 429) {
            Write-Verbose "429 - API Backoff"
            Start-Sleep -seconds 1
            while ($scv -eq 429) {
                $response = Invoke-RestMethod -Method GET -Uri $uri -headers $headers -StatusCodeVariable scv -ResponseHeadersVariable responseheaders -SkipHttpErrorCheck
            }
        }

        else {
            $response = Write-Error "$($scv) - $($response.error)"
        }
    }

    end {
        return $response
    }
}