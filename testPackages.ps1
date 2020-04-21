if (Test-Path $PSScriptRoot\chocotests) {
    Push-Location $PSScriptRoot\chocotests
    git pull
    vagrant snapshot restore fresh
    vagrant reload --provision
    vagrant snapshot delete fresh
    vagrant snapshot save fresh
}
else {
    Push-Location $PSScriptRoot
    git clone --depth 1 https://github.com/chocolatey/chocolatey-test-environment chocotests
    Pop-Location
    Push-Location $PSScriptRoot\chocotests
    vagrant up
    vagrant snapshot save fresh
}
Remove-Item $PSScriptRoot\chocotests\packages\* -Recurse

$packages = get-childitem -Include *.nuspec -Recurse -Path $PSScriptRoot | Where-Object { $PSItem.directoryname -notlike '*builds*' }
$output = @()
foreach($pack in $packages) {
    choco pack "$($pack.FullName)" --outputdirectory "$PSScriptRoot\chocotests\packages"
    $chocoOutput = vagrant winrm -e -c "choco install -fdvy $($pack.BaseName) --source c:\\packages"
    $output += [pscustomobject]@{
        package = $pack.BaseName
        Installed = $LASTEXITCODE -eq 0 ? $true : $LASTEXITCODE
        Output = $chocoOutput
    }
}
$output | select package,Installed
Pop-Location