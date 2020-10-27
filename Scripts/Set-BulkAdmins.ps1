$apiKey = ""
$path = "" #File Path of your admins
$domain = "" #Your's orgs domain.

$adminsToCreate = (Get-Content -raw -Path $path | ConvertFrom-Json)
$orgIDs = Get-MerakiOrgID -apiKey $apiKey

#Loops through all Org's
foreach($orgID in $orgIDs){
    $currentAdmins = Get-MerakiAdmins -apiKey $apiKey -orgID $orgID.id

    foreach($admin in $adminsToCreate){
        #Matches on all existing users
        $exists = $currentAdmins | Where-Object {$_.email -eq $admin.email}
        $unmanaged = $currentAdmins | Where-Object {$_.email -ne $admin.email -and $_.email -like "*$($domain)"}

        if($exists -ne $null){
            Write-Output "On the Organization $($orgID.name) we need to create the below admins"
            $exists
        }

        if($unmanaged -ne $null){
            Write-Warning "These users are unmanaged $($unmanaged.name) on $($orgID.name)"
        }
    }
}