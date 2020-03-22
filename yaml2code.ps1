# Import-Module powershell-yaml

param
(
  $yamlFile = "cqrs.yaml"
)

[string[]]$fileContent = Get-Content $yamlFile
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

    foreach ($feature in $project.features) {
        $featureName = "Features/$($feature.keys[0]).ps1"
        Invoke-Expression -Command $featureName
    }
}