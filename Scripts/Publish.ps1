using module ./Tools.psm1

if ($Release) { & "$PSScriptRoot/Default.ps1" }
else { Write-Error "The ""-Release"" switch must be set!"; exit 1 }

Write-Information "Tagging the repository..."
$version = Get-Version
git tag "v$version"
git push origin "v$version"

Write-Information "Publishing the package..."
$manifest = Get-Manifest
$module = Get-Manifest -AsHashtable

$output = "Temp/PSModule"
New-Item $output/Binaries -ItemType Directory | Out-Null
Copy-Item *.md $output
Copy-Item $manifest $output/Belin.$($manifest.Name)
Copy-Item $module.RootModule $output/Binaries

$output = "Temp/PSGallery"
New-Item $output -ItemType Directory | Out-Null
Compress-PSResource Temp/PSModule $output

$apiKey = $Env:PSGALLERY_API_KEY
Get-ChildItem $output -File -Filter *.nupkg
| ForEach-Object { Publish-PSResource -ApiKey $apiKey -NupkgPath $_ -Repository PSGallery }
