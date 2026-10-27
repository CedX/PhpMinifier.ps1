using module PSScriptAnalyzer

Write-Information "Performing the static analysis of source code..."
Invoke-ScriptAnalyzer $PSScriptRoot, "test" -Recurse
Test-ModuleManifest PhpMinifier.psd1 | Out-Null
