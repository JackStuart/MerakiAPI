$Functions = Get-ChildItem .\Scripts\Functions\

foreach ($Function in $Functions){
    try {
        . $Function.FullName
    }
    catch {
        Write-Error -Message "Failed to import function $($Function.FullName): $_"
    }
    Export-ModuleMember $Functions.BaseName -Alias *
}