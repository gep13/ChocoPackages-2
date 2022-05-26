$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://api.github.com/repos/microsoft/Microsoft-Win32-Content-Prep-Tool/zipball/v1.8.4'
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
  checksum      = '7A0F8AB079CBC6008B49C6316B5316D027658B1A75317F95F99DCD2DBFE67FBF'
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
