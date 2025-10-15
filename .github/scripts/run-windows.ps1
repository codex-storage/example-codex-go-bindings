param(
    [string]$BinaryName = "example.exe"
)

$env:PATH = "$PWD\libs;" + $env:PATH
& ".\$BinaryName"