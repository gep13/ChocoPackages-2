
$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir "winsize2_$($env:chocolateyPackageVersion).zip"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  file           = $fileLocation

  softwareName   = 'winsize2*'

  checksum       = '7D12D3613AC5190EF2C5258461347AE564EC1604EFDCF4B01AA69978CB9EC72C'
  checksumType   = 'sha256'

}

Install-ChocolateyZipPackage @packageArgs










    








