Import-Module PSScriptAnalyzer

"Performing the static analysis of source code..."
$PSScriptRoot, "test" | Invoke-ScriptAnalyzer -Recurse
Test-ModuleManifest PhpMinifier.psd1 | Out-Null
