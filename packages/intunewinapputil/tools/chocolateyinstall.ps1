$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://api.github.com/repos/microsoft/Microsoft-Win32-Content-Prep-Tool/zipball/v1.8.2'
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
  checksum      = '2F8BD2D89C7FB84EEE9A27DE38E984BA72EC9A01A6E1E84420783F80E2A07E08'
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
