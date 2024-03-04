$chocoPackage = ''
$chocoSource = 'https://community.chocolatey.org/api/v2/'
$GitHubUser = ""
$GitHubRepo = ""
$AssetPattern = ""
$assetExtension = "msi"

$Latest = Invoke-RestMethod "https://api.github.com/repos/$GitHubUser/$GitHubRepo/releases/latest"
$Current = choco search $chocoPackage --exact -r --source $chocoSource | ConvertFrom-Csv -Delimiter '|' -Header 'Name', 'Version'

$latestVersion = [version]($Latest.tag_name -replace 'v', '')

if ($null -eq $Current) {
    $Current = [pscustomobject]@{Version = '0.0.0' }
}
if ([version]($Current.Version) -lt $latestVersion) {
    $toolsDir = Join-Path $PSScriptRoot "packages\$chocoPackage"
    $latestAsset = $latest.assets | Where-Object name -Match $AssetPattern
    [System.Net.WebClient]::new().DownloadFile($latestAsset.browser_download_url, "$toolsDir\tools\$chocoPackage.$assetExtension")
    $nuspec = Get-ChildItem $toolsDir -Recurse -Filter '*.nuspec' | Select-Object -ExpandProperty FullName
    $install = Get-ChildItem $toolsDir -Recurse -Filter 'chocolateyinstall.ps1' | Select-Object -ExpandProperty FullName
    $checksums = Get-FileHash "$toolsDir\tools\$chocoPackage.$assetExtension" -Algorithm SHA256
    $replacements = @(
        @{
            toReplace   = '[[ID]]'
            replaceWith = $chocoPackage
            file        = $nuspec
        }
        @{
            toReplace   = '[[TITLE]]'
            replaceWith = ''
            file        = $nuspec
        }
        @{
            toReplace   = '[[AUTHOR]]'
            replaceWith = $GitHubUser
            file        = $nuspec
        }
        @{
            toReplace   = '[[PROJECT_URL]]'
            replaceWith = ''
            file        = $nuspec
        }
        @{
            toReplace   = '[[LICENSE_URL]]'
            replaceWith = ''
            file        = $nuspec
        }
        @{
            toReplace   = '[[PROJECT_SOURCE_URL]]'
            replaceWith = ''
            file        = $nuspec
        }
        @{
            toReplace   = '[[RELEASE_NOTES]]'
            replaceWith = ''
            file        = $nuspec
        }
        @{
            toReplace   = '[[TAGS]]'
            replaceWith = ''
            file        = $nuspec
        }
        @{
            toReplace   = '[[SUMMARY]]'
            replaceWith = ''
            file        = $nuspec
        }
        @{
            toReplace   = '[[DESCRIPTION]]'
            replaceWith = ''
            file        = $nuspec
        }
        @{
            toReplace   = '[[VERSION]]'
            replaceWith = $latestVersion
            file        = $nuspec
        }
        @{
            toReplace   = '[[URL]]'
            replaceWith = $LatestAsset.browser_download_url
            file        = $install
        }
        @{
            toReplace   = '[[CHECKSUM]]'
            replaceWith = ($checksums | Where-Object algorithm -EQ SHA256).hash
            file        = $install
        }
    )
    foreach ($currReplacement in $replacements) {
        (Get-Content $currReplacement.file).Replace($currReplacement.toReplace, $currReplacement.replaceWith) | Set-Content $currReplacement.file
    }

    choco pack $nuspec --output-directory "'$PSScriptRoot\updatedPackages'"
}
