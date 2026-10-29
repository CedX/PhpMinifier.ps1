@{
	DefaultCommandPrefix = "Php"
	ModuleVersion = "2026.10.0"
	PowerShellVersion = "7.6"
	RootModule = "Binaries/Belin.PhpMinifier.dll"

	Author = "Cédric Belin <cedx@outlook.com>"
	CompanyName = "Cedric-Belin.fr"
	Copyright = "© Cédric Belin"
	Description = "Minify PHP source code by removing comments and whitespace."
	GUID = "80e95460-facb-4517-87b0-6406f72e030d"

	AliasesToExport = @()
	FunctionsToExport = @()
	VariablesToExport = @()

	CmdletsToExport = @(
		"Compress-Script"
		"New-Transformer"
	)

	RequiredModules = @(
		@{ ModuleName = "Belin.FSharp"; ModuleVersion = "10.1.403" }
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
