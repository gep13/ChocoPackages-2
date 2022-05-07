$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://api.github.com/repos/microsoft/Microsoft-Win32-Content-Prep-Tool/zipball/1.8.3'
# Remove any prior installations.
$foldersToRemove = Get-ChildItem -Path $toolsDir\microsoft-Microsoft-Win32-Content-Prep-Tool-* -Directory
foreach ($folder in $foldersToRemove) {
  Remove-Item $folder.FullName -Force -Recurse -ErrorAction Ignore
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  softwareName  = 'intunewinapputil*' 
  checksum      = '6D4D2A51145AFA77559344ABBFBB30E1FE3C08CB9739BDD9B8883935A9111832'
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
