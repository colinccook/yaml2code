# Import-Module powershell-yaml

[string[]]$fileContent = Get-Content "code.yaml"
$content = ''
foreach ($line in $fileContent) { $content = $content + "`n" + $line }
$yaml = ConvertFrom-YAML $content

Write-Debug $yaml

$solution = $yaml["Solution"]

mkdir $solution

$yaml["Projects"] | ForEach-Object {
    dotnet new classlib -o "$solution/$_.name"
}