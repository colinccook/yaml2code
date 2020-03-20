# Import-Module powershell-yaml

[string[]]$fileContent = Get-Content "code.yaml"
$content = ''
foreach ($line in $fileContent) { $content = $content + "`n" + $line }
$yaml = ConvertFrom-YAML $content

$guid = New-Guid
$solution = $guid.Guid.ToString()
# $solution = $yaml["solution"] briefly commented this out to avoid the pain of rebuilding
$projects = $yaml["projects"]

mkdir $solution

dotnet new sln -o "$solution"

foreach ($project in $projects) {
    $projectName = $project.name
    $template = if ($null -eq $project.template) { "classlib" } else { $project.template } 
    dotnet new $template --no-restore -o "$solution/$projectName"
    dotnet sln "$solution/$solution.sln" add "$solution/$projectName/$projectName.csproj"

    foreach ($reference in $project.references) {
        dotnet add "$solution/$projectName/$projectName.csproj" reference "$solution/$reference/$reference.csproj"
    }

    foreach ($package in $project.packages) {
        dotnet add "$solution/$projectName/$projectName.csproj" package $package
    }
}