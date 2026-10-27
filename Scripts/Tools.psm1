<#
.SYNOPSIS
	The cached contents of the module manifest.
#>
[hashtable] $Script:Manifest = $null

<#
.SYNOPSIS
	Gets the path, or the contents, of the module manifest.
.OUTPUTS
	[string] The path to the module manifest.
.OUTPUTS
	[hashtable] The contents of the module manifest.
#>
function Get-Manifest {
	[CmdletBinding(DefaultParameterSetName = "Default")]
	[OutputType([hashtable], [string])]
	param (
		# Value indicating whether to return the module data instead of its path.
		[Parameter(ParameterSetName = "AsHashtable")]
		[switch] $AsHashtable
	)

	if ($null -eq $Script:Manifest) {
		$path =
			Get-ChildItem (Join-Path $PSScriptRoot ..) -File -Filter *.psd1
			| Where-Object BaseName -NotIn "PSModules", "PSScriptAnalyzerSettings"
			| Select-Object -ExpandProperty FullName -First 1

		$Script:Manifest = @{
			Data = Import-PowerShellDataFile $path
			Path = $path
		}
	}

	$AsHashtable ? $Script:Manifest.Data : $Script:Manifest.Path
}

<#
.SYNOPSIS
	Gets the path to the solution file.
.OUTPUTS
	The path to the solution file.
#>
function Get-Solution {
	[CmdletBinding()]
	[OutputType([string])]
	param ()

	Get-ChildItem (Join-Path $PSScriptRoot ..) -File -Filter *.slnx
	| Select-Object -ExpandProperty FullName -First 1
}

<#
.SYNOPSIS
	Gets the project version number.
.OUTPUTS
	The project version number.
#>
function Get-Version {
	[CmdletBinding()]
	[OutputType([version])]
	param ()

	[version]::Parse((Get-Manifest -AsHashtable).ModuleVersion)
}

<#
.SYNOPSIS
	Publishes the project package to the PowerShell Gallery registry.
#>
function Publish-PSGalleryModule {
	$root = Join-Path $PSScriptRoot .. -Resolve
	$module = Import-PowerShellDataFile $root/PhpMinifier.psd1

	$output = "$root/Temp/PSModule"
	New-Item $output/Binaries -ItemType Directory | Out-Null
	Copy-Item $root/PhpMinifier.psd1 $output/Belin.PhpMinifier.psd1
	Copy-Item $root/*.md $output
	Copy-Item $root/Sources $output -Recurse
	Remove-Item $output/Sources/*.cs*, $output/Sources/obj -Recurse
	$module.RequiredAssemblies | ForEach-Object { "$root/$_" } | Copy-Item -Destination $output/Binaries

	$output = "$root/Temp/PSGallery"
	New-Item $output -ItemType Directory | Out-Null
	Compress-PSResource $root/Temp/PSModule $output
	Get-Item $output/*.nupkg | ForEach-Object { Publish-PSResource -ApiKey $Env:PSGALLERY_API_KEY -NupkgPath $_ -Repository PSGallery }
}

<#
.SYNOPSIS
	Checks whether an update is available for the specified PowerShell module.
.INPUTS
	The PowerShell module to be checked.
.OUTPUTS
	An object providing the current and the latest version of the specified module if an update is available, otherwise none.
#>
function Test-PSResourceUpdate {
	[CmdletBinding()]
	[OutputType([psobject])]
	param (
		# The PowerShell module to be checked.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline)]
		[Microsoft.PowerShell.PSResourceGet.UtilClasses.PSResourceInfo] $InputObject
	)

	process {
		if ($InputObject.Repository -ne "PSGallery") { return }

		$url = "https://www.powershellgallery.com/packages/$($InputObject.Name)"
		$response = Invoke-WebRequest $url -Method Head -MaximumRedirection 0 -SkipHttpErrorCheck -ErrorAction Ignore
		$latestVersion = [semver] (Split-Path $response.Headers.Location -Leaf)

		$module = [pscustomobject]@{ ModuleName = $InputObject.Name; CurrentVersion = $InputObject.Version; LatestVersion = $latestVersion }
		if ($module.LatestVersion -gt $module.CurrentVersion) { $module }
	}
}
