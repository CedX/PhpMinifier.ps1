"Watching for file changes..."
$configuration = $Release ? "Release" : "Debug"
Start-Process dotnet -ArgumentList "watch", "build", "--configuration", $configuration -NoNewWindow -Wait -WorkingDirectory src/PhpMinifier.Cmdlets
