dotnet add "$solution/$projectName/$projectName.csproj" package CommandQuery

$queries = $feature.Values.ToArray()

$queryTemplate = Invoke-WebRequest -URI https://raw.githubusercontent.com/hlaueriksson/CommandQuery/master/samples/CommandQuery.Sample.Contracts/Queries/BarQuery.cs
$queryTemplate = $queryTemplate.Content.Replace("CommandQuery.Sample.Contracts", "$projectName")

mkdir "$solution/$projectName/Queries/"

foreach ($query in $queries) {
    $queryCode = $queryTemplate.Replace("Bar", $query);
    New-Item -Path "$solution/$projectName/Queries/$($query)Query.cs"
    Add-Content -Path "$solution/$projectName/Queries/$($query)Query.cs" -Value "using CommandQuery;`r`n`r`n$queryCode"
}