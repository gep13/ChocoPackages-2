$chocoPackage = 'intunewinapputil'

$Latest = Invoke-RestMethod 'https://api.github.com/repos/microsoft/Microsoft-Win32-Content-Prep-Tool/releases/latest'
$Current = choco list intunewinapputil --exact -r | ConvertFrom-Csv -Delimiter '|' -Header 'Name', 'Version'

$latestVersion = [version]($Latest.tag_name -replace 'v', '')
Invoke-WebRequest $Latest.zipball_url -OutFile "$($env:TEMP)\$chocoPackage.zip"
$checksums = Get-FileHash "$($env:TEMP)\$chocoPackage.zip" -Algorithm SHA256

if ($null -eq $Current) {
    $Current = [pscustomobject]@{Version = '0.0.0' }
}
if ([version]($Current.Version) -lt $latestVersion) {
    $toolsDir = Join-Path $PSScriptRoot 'packages\intunewinapputil'
    $nuspec = Get-ChildItem $toolsDir -Recurse -Filter '*.nuspec' | Select-Object -ExpandProperty FullName
    $install = Get-ChildItem $toolsDir -Recurse -Filter 'chocolateyinstall.ps1' | Select-Object -ExpandProperty FullName
    $replacements = @(
        @{
            toReplace   = '[[VERSION]]'
            replaceWith = $latestVersion
            file        = $nuspec
        },
        @{
            toReplace   = '[[URL]]'
            replaceWith = $Latest.zipball_url
            file        = $install
        },
        @{
            toReplace   = '[[CHECKSUM]]'
            replaceWith = ($checksums | ? algorithm -eq SHA256).hash
            file        = $install
        }
    )
    foreach ($currReplacement in $replacements) {
        (Get-Content $currReplacement.file).Replace($currReplacement.toReplace, $currReplacement.replaceWith) | Set-Content $currReplacement.file
    }
    # choco pack $nuspec --output-directory "'$($env:TEMP)'"
    choco pack $nuspec --output-directory "'$PSScriptRoot\chocotests\packages'"
    # choco push $((Get-ChildItem $env:TEMP -Filter intunewinapputil.*.nupkg).FullName) -s https://push.chocolatey.org
}
