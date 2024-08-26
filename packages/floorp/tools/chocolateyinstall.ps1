$ErrorActionPreference = 'Stop'

$fileLocation64 = '[[URL64]]'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  url64         = $fileLocation64
  softwareName  = 'floorp*'
  checksum64      = '[[CHECKSUM64]]'
  checksumType  = 'sha256'
  validExitCodes= @(0, 3010, 1641)
  silentArgs   = '/S' # Inno Setup
}

Install-ChocolateyPackage @packageArgs
