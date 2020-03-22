dotnet add "$solution/$projectName/$projectName.csproj" package CommandQuery

$commands = $feature.Values.ToArray()

$commandTemplate = Invoke-WebRequest -URI https://raw.githubusercontent.com/hlaueriksson/CommandQuery/master/samples/CommandQuery.Sample.Contracts/Commands/BazCommand.cs
# Fix namespace
$commandTemplate = $commandTemplate.Content.Replace("CommandQuery.Sample.Contracts", "$projectName")

$commandHandlerTemplate = Invoke-WebRequest -URI https://raw.githubusercontent.com/hlaueriksson/CommandQuery/master/samples/CommandQuery.Sample.Handlers/Commands/BazCommandHandler.cs
# Fix namespace
$commandHandlerTemplate = $commandHandlerTemplate.Content.Replace("CommandQuery.Sample.Handlers", "$projectName")
$commandHandlerTemplate = $commandHandlerTemplate.Replace("using CommandQuery.Sample.Contracts.Commands;", "")
# Remove ICultureService example
$commandHandlerTemplate = $commandHandlerTemplate.Replace("        private readonly ICultureService _cultureService;", "")
$commandHandlerTemplate = $commandHandlerTemplate.Replace("ICultureService cultureService", "")
$commandHandlerTemplate = $commandHandlerTemplate.Replace("            _cultureService = cultureService;", "")
$commandHandlerTemplate = $commandHandlerTemplate.Replace("_cultureService.SetCurrentCulture(command.Value);", "")


mkdir "$solution/$projectName/Commands/"

foreach ($command in $commands) {
    $commandCode = $commandTemplate.Replace("Baz", $command);
    New-Item -Path "$solution/$projectName/Commands/$($command)Command.cs"
    Add-Content -Path "$solution/$projectName/Commands/$($command)Command.cs" -Value "using CommandQuery;`r`n`r`n$commandCode"

    $commandHandlerCode = $commandHandlerTemplate.Replace("Baz", $command);
    New-Item -Path "$solution/$projectName/Commands/$($command)CommandHandler.cs"
    Add-Content -Path "$solution/$projectName/Commands/$($command)CommandHandler.cs" -Value "using CommandQuery;`r`n`r`n$commandHandlerCode"
}