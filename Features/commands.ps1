dotnet add "$solution/$projectName/$projectName.csproj" package CommandQuery

$commands = $feature.Values.ToArray()

$commandTemplate = Invoke-WebRequest -URI https://raw.githubusercontent.com/hlaueriksson/CommandQuery/master/samples/CommandQuery.Sample.Contracts/Commands/BazCommand.cs
$commandTemplate = $commandTemplate.Content.Replace("CommandQuery.Sample.Contracts", "$projectName")

mkdir "$solution/$projectName/Commands/"

foreach ($command in $commands) {
    $commandCode = $commandTemplate.Replace("Baz", $command);
    New-Item -Path "$solution/$projectName/Commands/$($command)Command.cs"
    Add-Content -Path "$solution/$projectName/Commands/$($command)Command.cs" -Value "using CommandQuery;`r`n`r`n$commandCode"
}