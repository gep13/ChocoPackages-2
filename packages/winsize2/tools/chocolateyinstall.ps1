
$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir "winsize2_$($env:chocolateyPackageVersion).zip"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  file           = $fileLocation

  softwareName   = 'winsize2*'

  checksum       = '6A0BF6CC75A3A92B7BC41BDCFD2D528A230F13C629EF5FE83E273075431EA1CE'

  checksumType   = 'sha256'

}

Install-ChocolateyZipPackage @packageArgs










    








