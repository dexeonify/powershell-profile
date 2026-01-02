# Set oh-my-posh theme
oh-my-posh.exe init pwsh --config "$env:POSH_THEMES_PATH/M365Princess.omp.json" | Invoke-Expression
# Disable automatic prompt change on activating venv when using oh-my-posh
$env:VIRTUAL_ENV_DISABLE_PROMPT=1
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

# Search MS Word documents for specific keywords
function Search-Docx {
    param ([ValidateSet("BM", "English")]$Path)

    Push-Location "D:\Documents\$Path"
    uv.exe run "D:\Scripts\search_docx.py"
    Pop-Location
}

# Switch between power plans, mostly used to keep the system awake
function Set-PowerPlan {
    param ([ValidateSet("Balanced", "HighPerformance")]$Plan)

    if ($Plan -eq "Balanced") {
        powercfg /SETACTIVE 381b4222-f694-41f0-9685-ff5bb260df2e
    }
    elseif ($Plan -eq "HighPerformance") {
        powercfg /SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    }
}

# Override system curl binary
New-Alias -Name curl -Value "C:\Program Files\Git\mingw64\bin\curl.exe"

# Load tab completions
$CompletionDir = Join-Path $(Split-Path -Parent $PROFILE.CurrentUserAllHosts) "Completions"
$CompletionCmd = "av1an", "mpv", "rclone", "rustic", "uv", "winget"
foreach ($cmd in $CompletionCmd) {
    . "$CompletionDir\$cmd-completion.ps1"
}
