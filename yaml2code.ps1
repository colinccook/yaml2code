# Import-Module powershell-yaml

[string[]]$fileContent = Get-Content "code.yaml"
$content = ''
foreach ($line in $fileContent) { $content = $content + "`n" + $line }
$yaml = ConvertFrom-YAML $content

$solution = $yaml["solution"]
$projects = $yaml["projects"]

$projects

mkdir $solution

$projects | ForEach-Object {
    $project = $_.name
    dotnet new classlib -o "$solution/$project"
}

Remove-Item –path $solution –recurse