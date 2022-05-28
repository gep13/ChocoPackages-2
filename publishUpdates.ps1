param($ApiKey)
$ExitCode = 0
Remove-Item $env:ChocolateyInstall/logs/chocolatey.log
Get-ChildItem updatedPackages/*.nupkg | ForEach-Object {
    Write-Host "updatedPackages/$($_.Name)"
    choco push "updatedPackages/$($_.Name)" --source https://push.chocolatey.org/ --key $ApiKey
    $ExitCode += $LASTEXITCODE
}
if ($ExitCode -ne 0) {
    Get-Content $env:ChocolateyInstall/logs/chocolatey.log
    exit $ExitCode
}