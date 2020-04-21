Remove-Item $PSScriptRoot\builds -Recurse -Force -ErrorAction SilentlyContinue
New-Item $PSScriptRoot\builds\packages -ItemType Directory -Force
$nuspecFiles = Get-ChildItem -Path $PSScriptRoot -Include *.nuspec -Recurse
foreach($nuspec in $nuspecFiles){
    Copy-Item -Recurse -Path $nuspec.DirectoryName -Destination "$PSScriptRoot\builds\$(split-path $nuspec.Directory -Leaf)" -Force
}
$ps1Files = Get-ChildItem -Path $PSScriptRoot\builds -Include *.ps1 -Recurse
foreach($file in $ps1Files) {
    $contents = Get-Content $file | Where-Object {$PSItem -notmatch "^\s*#"} | ForEach-Object {$PSItem -replace '(^.*?)\s*?[^``]#.*','$1'}
    $contents | Out-File $file -Encoding utf8
}
$nuspecFiles = Get-ChildItem -Path $PSScriptRoot\builds -Include *.nuspec -Recurse
foreach($nuspec in $nuspecFiles){
    $tempFile = New-TemporaryFile
    (Get-Content $nuspec -raw) -replace "\<!--[\s\S]*?--\>","" | out-file $tempFile
    Get-Content $tempFile | Where-Object {$_ -notmatch "^\s*$"} | out-file $nuspec -Encoding utf8
    Remove-Item $tempFile
    choco.exe pack "$($nuspec.FullName)" --outputdirectory $PSScriptRoot\builds\packages
}