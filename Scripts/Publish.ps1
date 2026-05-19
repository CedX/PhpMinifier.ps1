using module ./Cmdlets.psm1

if ($Release) { & "$PSScriptRoot/Default.ps1" }
else {
	"The ""-Release"" switch must be set!"
	exit 1
}

"Publishing the package..."
$version = (Import-PowerShellDataFile PhpMinifier.psd1).ModuleVersion
New-GitTag "v$version"
Publish-NuGetPackage -NoBuild

$output = "Temp/PSModule"
New-Item $output/Binaries, $output/Sources -ItemType Directory | Out-Null
Copy-Item PhpMinifier.psd1 $output/Belin.PhpMinifier.psd1
Copy-Item *.md $output
Copy-Item Sources/Cmdlets $output/Sources -Recurse

$output = "Temp/PSGallery"
New-Item $output -ItemType Directory | Out-Null
Compress-PSResource Temp/PSModule $output
Get-Item "$output/*.nupkg" | ForEach-Object { Publish-PSResource -ApiKey $Env:PSGALLERY_API_KEY -NupkgPath $_ -Repository PSGallery }
