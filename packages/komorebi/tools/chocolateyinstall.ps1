
$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = "[[URL]]"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  url            = $url

  softwareName   = 'komorebi*'

  checksum       = '[[CHECKSUM]]'
  checksumType   = 'sha256'

  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs

# Create the needed LocalAppData directory. Without this komorebi will fail to launch.
New-Item -Path "$Env:LOCALAPPDATA\komorebi" -ItemType Directory -ErrorAction SilentlyContinue

Write-Host "komorebi is installed. If this is your first time using it, you may want to run 'komorebic quickstart' to download the quick start configurations."
