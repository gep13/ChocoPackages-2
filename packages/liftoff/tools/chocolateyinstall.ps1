$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

foreach ($folder in $foldersToRemove) {
    Remove-Item $folder.FullName -Force -Recurse -ErrorAction Ignore
}

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    unzipLocation = $toolsDir
    url           = '[[URL]]'

    softwareName  = 'liftoff*'
    checksum      = '[[CHECKSUM]]'
    checksumType  = 'sha256'
}
Install-ChocolateyZipPackage @packageArgs
