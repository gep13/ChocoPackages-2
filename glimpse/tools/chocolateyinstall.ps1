
$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = "https://github.com/glimpse-editor/Glimpse/releases/download/v$($env:chocolateyPackageVersion)/glimpse-$($env:chocolateyPackageVersion).msi"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  url            = $url

  softwareName   = 'glimpse*'

  checksum       = '99C3DF2884310CB74C39A15FB63E93FBF2112F581DC5325B37123467618D89E8'
  checksumType   = 'sha256'

  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs










    








