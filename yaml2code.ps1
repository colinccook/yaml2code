# Import-Module powershell-yaml

Remove-Item –path $solution –recurse

[string[]]$fileContent = Get-Content "code.yaml"
$content = ''
foreach ($line in $fileContent) { $content = $content + "`n" + $line }
$yaml = ConvertFrom-YAML $content

$solution = $yaml["solution"]
$projects = $yaml["projects"]

mkdir $solution

dotnet new sln -o "$solution"

$projects | ForEach-Object {
    $project = $_.name
    dotnet new classlib --no-restore -o "$solution/$project"
    dotnet sln "$solution/$solution.sln" add "$solution/$project/$project.csproj"
}

Remove-Item –path $solution –recurse