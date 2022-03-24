$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir 'glab_1.22.0_Windows_i386.zip'
$fileLocation64 = Join-Path $toolsDir 'glab_1.22.0_Windows_x86_64.zip'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  file         = $fileLocation
  file64         = $fileLocation64
  checksum      = '43e86b78e919ec0a1947157c1eeaf62fa8bc03087f09affb28293af939ac4389'
  checksumType  = 'sha256'
  checksum64    = '1b07931cbd9547fdf33bc5c636a5e70bc01d7ef68768cff13f9655623ce411d8'
  checksumType64= 'sha256'
}
Install-ChocolateyZipPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateyzippackage