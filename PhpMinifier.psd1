@{
	DefaultCommandPrefix = "Php"
	ModuleVersion = "2.0.0"
	PowerShellVersion = "7.6"
	RootModule = "Sources/Main.psm1"

	Author = "Cédric Belin <cedx@outlook.com>"
	CompanyName = "Cedric-Belin.fr"
	Copyright = "© Cédric Belin"
	Description = "Minify PHP source code by removing comments and whitespace."
	GUID = "bcbf1848-7f0f-4eac-83c7-c83390f4265c"

	AliasesToExport = @()
	FunctionsToExport = @()
	VariablesToExport = @()

	CmdletsToExport = @(
		"Compress-Script"
		"New-Transformer"
	)

	PrivateData = @{
		PSData = @{
			LicenseUri = "https://github.com/CedX/PhpMinifier.ps1/blob/main/License.md"
			ProjectUri = "https://github.com/CedX/PhpMinifier.ps1"
			ReleaseNotes = "https://github.com/CedX/PhpMinifier.ps1/releases"
			Tags = "ci", "compress", "minify", "php"
		}
	}
}
