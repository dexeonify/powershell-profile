# Set oh-my-posh theme
oh-my-posh.exe init pwsh --config m365princess | Invoke-Expression

# Enable shell integration
$Global:OriginalPrompt = $function:Prompt
function Global:Get-LastExitCode {
    if ($? -eq $true) { return 0 }
    $LastHistoryEntry = $(Get-History -Count 1)
    $IsPowerShellError = $Error[0].InvocationInfo.HistoryId -eq $LastHistoryEntry.Id
    if ($IsPowerShellError) { return -1 }
    return $LastExitCode
}
function prompt {
    $gle = $(Get-LastExitCode);
    $LastHistoryEntry = $(Get-History -Count 1)
    if ($Global:LastHistoryId -ne -1) {
        if ($LastHistoryEntry.Id -eq $Global:LastHistoryId) {
            $out += "`e]133;D`a"
        } else {
            $out += "`e]133;D;$gle`a"
        }
    }
    $loc = $($executionContext.SessionState.Path.CurrentLocation);
    $out += "`e]133;A$([char]07)";
    $out += "`e]9;9;`"$loc`"$([char]07)";
    $out += $Global:OriginalPrompt.Invoke(); # <-- This line adds the original prompt back
    $out += "`e]133;B$([char]07)";
    $Global:LastHistoryId = $LastHistoryEntry.Id
    return $out
}

# Load tab completions
$CompletionDir = Join-Path $(Split-Path -Parent $PROFILE.CurrentUserAllHosts) "Completions"
$CompletionCmd = "av1an", "mpv", "rclone", "rustic", "uv", "winget"
foreach ($cmd in $CompletionCmd) {
    . "$CompletionDir\$cmd-completion.ps1"
}
