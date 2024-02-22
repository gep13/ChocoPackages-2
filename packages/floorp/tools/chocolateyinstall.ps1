$ErrorActionPreference = 'Stop'

$fileLocation64 = '[[URL64]]'
$fileLocation = '[[URL32]]'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  url         = $fileLocation
  url64         = $fileLocation64
  softwareName  = 'floorp*'
  checksum      = '[[CHECKSUM32]]'
  checksum64      = '[[CHECKSUM64]]'
  checksumType  = 'sha256'
  validExitCodes= @(0, 3010, 1641)
  silentArgs   = '/S' # Inno Setup
}

Install-ChocolateyPackage @packageArgs
