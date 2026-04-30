using module ./Cmdlets.psm1

"Running the test suite..."
Invoke-DotNetTest -Settings "$PSScriptRoot/../.runsettings"
pwsh -Command { Import-Module Pester; Invoke-Pester test; exit $LASTEXITCODE }
