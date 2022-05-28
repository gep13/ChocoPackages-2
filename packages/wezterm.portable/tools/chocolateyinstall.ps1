$ErrorActionPreference = 'Stop'
if([version](Get-CimInstance Win32_OperatingSystem).Version -lt [version]"10.0.17763") {
  throw "This requires Windows 10 version 10.0.17763 at a minimum"
}
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# Remove any prior installations.
$foldersToRemove = Get-ChildItem -Path $toolsDir\WezTerm-windows* -Directory

foreach ($folder in $foldersToRemove) {
  Remove-Item $folder.FullName -Force -Recurse -ErrorAction Ignore
}

$fileLocation = Join-Path $toolsDir 'wezterm.portable.zip'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  file         = $fileLocation

  softwareName  = 'wezterm.portable*'
  checksum      = '[[CHECKSUM]]'
  checksumType  = 'sha256'
}
Install-ChocolateyZipPackage @packageArgs