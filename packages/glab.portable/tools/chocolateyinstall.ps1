$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = "[[URL]]"
$url64 = "[[URL64]]"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  url64bit      = $url64
  checksum      = '[[CHECKSUM]]'
  checksumType  = 'sha256'
  checksum64    = '[[CHECKSUM64]]'
  checksumType64= 'sha256'
}
Install-ChocolateyZipPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateyzippackage

# Remove any zip files from previous installs
Remove-Item $toolsDir/*.zip -ErrorAction SilentlyContinue
