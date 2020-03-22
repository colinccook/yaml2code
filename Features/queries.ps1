dotnet add "$solution/$projectName/$projectName.csproj" package CommandQuery

$queries = $feature.Values.ToArray()

$queryTemplate = Invoke-WebRequest -URI https://raw.githubusercontent.com/hlaueriksson/CommandQuery/master/samples/CommandQuery.Sample.Contracts/Queries/BarQuery.cs
$queryTemplate = $queryTemplate.Content.Replace("CommandQuery.Sample.Contracts", "$projectName")

$queryHandlerTemplate = Invoke-WebRequest -URI https://raw.githubusercontent.com/hlaueriksson/CommandQuery/master/samples/CommandQuery.Sample.Handlers/Queries/BarQueryHandler.cs
# Fix namespace
$queryHandlerTemplate = $queryHandlerTemplate.Content.Replace("CommandQuery.Sample.Handlers", "$projectName")
$queryHandlerTemplate = $queryHandlerTemplate.Replace("using CommandQuery.Sample.Contracts.Queries;", "")

# Remove IDateTimeProxy example
$queryHandlerTemplate = $queryHandlerTemplate.Replace("private readonly IDateTimeProxy _dateTime;", "")
$queryHandlerTemplate = $queryHandlerTemplate.Replace("IDateTimeProxy dateTime", "")
$queryHandlerTemplate = $queryHandlerTemplate.Replace("_dateTime = dateTime;", "")
$queryHandlerTemplate = $queryHandlerTemplate.Replace("_dateTime.Now.ToString(""F"")", """ReturnMessage""")

mkdir "$solution/$projectName/Queries/"

foreach ($query in $queries) {
    $queryCode = $queryTemplate.Replace("Bar", $query);
    New-Item -Path "$solution/$projectName/Queries/$($query)Query.cs"
    Add-Content -Path "$solution/$projectName/Queries/$($query)Query.cs" -Value "using CommandQuery;`r`n`r`n$queryCode"

    $queryHandlerCode = $queryHandlerTemplate.Replace("Bar", $query);
    New-Item -Path "$solution/$projectName/Queries/$($query)QueryHandler.cs"
    Add-Content -Path "$solution/$projectName/Queries/$($query)QueryHandler.cs" -Value "using CommandQuery;`r`n`r`n$queryHandlerCode"
}