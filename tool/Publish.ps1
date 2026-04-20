if ($Release) { & "$PSScriptRoot/Default.ps1" }
else {
	"The ""-Release"" switch must be set!"
	exit 1
}

"Publishing the package..."
$module = Import-PowerShellDataFile PhpMinifier.psd1
$version = $module.ModuleVersion
git tag "v$version"
git push origin "v$version"

$output = "var/NuGet"
dotnet pack --no-build --output $output
Get-Item "$output/*.nupkg" | ForEach-Object { dotnet nuget push $_ --api-key $Env:NUGET_API_KEY --source NuGet }

$output = "var/PSModule"
New-Item $output/bin, $output/src -ItemType Directory | Out-Null
Copy-Item PhpMinifier.psd1 $output/Belin.PhpMinifier.psd1
Copy-Item *.md $output
Copy-Item src/Cmdlets $output/src -Recurse
$module.RequiredAssemblies | Copy-Item -Destination $output/bin

$output = "var/PSGallery"
New-Item $output -ItemType Directory | Out-Null
Compress-PSResource var/PSModule $output
Get-Item "$output/*.nupkg" | ForEach-Object { Publish-PSResource -ApiKey $Env:PSGALLERY_API_KEY -NupkgPath $_ -Repository PSGallery }
