$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = "https://gitlab.com/gitlab-org/cli/-/releases/v1.24.1/downloads/glab_1.24.1_Windows_i386.zip"
$url64 = "https://gitlab.com/gitlab-org/cli/-/releases/v1.24.1/downloads/glab_1.24.1_Windows_x86_64.zip"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  url64bit      = $url64
  checksum      = '85e9b4ee96337ebe48b040a552b2cb7327be86d235ff6e2c9d555be32c9fe56c'
  checksumType  = 'sha256'
  checksum64    = '6b553a556ba7011a0c9fcf8a5f947ab60c6aabfaada47391ea7ba5703b08392b'
  checksumType64= 'sha256'
}
Install-ChocolateyZipPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateyzippackage

# Remove any zip files from previous installs
Remove-Item $toolsDir/*.zip
