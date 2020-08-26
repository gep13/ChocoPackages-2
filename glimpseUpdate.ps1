$Latest = Invoke-RestMethod 'https://api.github.com/repos/glimpse-editor/Glimpse/releases/latest'
$Current = choco list glimpse --exact -r | ConvertFrom-Csv -Delimiter '|' -Header 'Name', 'Version'

$latestVersion = [version]($Latest.tag_name -replace 'v', '')

if($null -eq $Current) {
	$Current = [pscustomobject]@{Version = '0.0.0'}
}
if([version]($Current.Version) -lt $latestVersion) {
	$toolsDir = Join-Path $PSScriptRoot 'glimpse'
	$nuspec = Get-ChildItem $toolsDir -Recurse -Filter '*.nuspec' | Select-Object -ExpandProperty FullName
	$install = Get-ChildItem $toolsDir -Recurse -Filter 'chocolateyinstall.ps1' | Select-Object -ExpandProperty FullName
	$checksums = Invoke-RestMethod ($latest.assets | Where-Object name -eq 'sha256.txt').browser_download_url | ConvertFrom-Csv -Delimiter ' ' -Header 'checksum', 'filename'
	$replacements = @(
		@{
			toReplace = '[[VERSION]]'
			replaceWith = $latestVersion
			file = $nuspec
		},
		@{
			toReplace = '[[URL]]'
			replaceWith = $($Latest.assets | Where-Object name -like '*i686*.msi' | Select-Object -ExpandProperty browser_download_url)
			file = $install
		},
		@{
			toReplace = '[[URL64]]'
			replaceWith = $($Latest.assets | Where-Object name -like '*x64*.msi' | Select-Object -ExpandProperty browser_download_url)
			file = $install
		},
		@{
			toReplace = '[[CHECKSUM]]'
			replaceWith = $($checksums | Where-Object filename -like '*i686*.msi' | Select-Object -ExpandProperty checksum)
			file = $install
		},
		@{
			toReplace = '[[CHECKSUM64]]'
			replaceWith = $($checksums | Where-Object filename -like '*x64*.msi' | Select-Object -ExpandProperty checksum)
			file = $install
		}
	)
	foreach($currReplacement in $replacements){
		(Get-Content $currReplacement.file).Replace($currReplacement.toReplace, $currReplacement.replaceWith) | Set-Content $currReplacement.file
	}
	choco pack $nuspec --output-directory "'$($env:TEMP)'"
	choco push $((Get-ChildItem $env:TEMP -Filter glimpse.*.nupkg).FullName) -s https://push.chocolatey.org
