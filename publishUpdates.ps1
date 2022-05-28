param($ApiKey)
choco find --source updatedPackages -r | ConvertFrom-Csv -Delimiter '|' -Header Name, Version | ForEach-Object {
    $existing = choco find $_.Name --source https://community.chocolatey.org/api/v2/ --version $_.Version --exact -r
    if ([string]::IsNullOrWhiteSpace($existing)) {
        choco push "updatedPackages/$($_.Name)" --source https://push.chocolatey.org/ --key $ApiKey
    } else {
        Write-Host "$($_.Name) is already published to Community Repository, it's likely not yet approved."
    }
}