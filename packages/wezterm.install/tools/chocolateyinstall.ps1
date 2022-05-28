$ErrorActionPreference = 'Stop'
if([version](Get-CimInstance Win32_OperatingSystem).Version -lt [version]"10.0.17763") {
  throw "This requires Windows 10 version 10.0.17763 at a minimum"
}
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir 'wezterm.install.exe'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  file         = $fileLocation
  softwareName  = 'wezterm*'
  checksum      = '[[CHECKSUM]]'
  checksumType  = 'sha256'
  validExitCodes= @(0, 3010, 1641)
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
}

Install-ChocolateyPackage @packageArgs