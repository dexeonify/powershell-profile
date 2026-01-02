<#
    .SYNOPSIS
        Command-to-Script Mapping Hash Table.
    .DESCRIPTION
        This file contains the necessary mappings which map commands and
        programs to their corresponding shell completion scripts or modules.

        It is used in order to implement a lazy-loading mechanism for
        importing completion scripts.
    .NOTES
        - The key is the command name.
        - The value is the path to the completion script or module.
    .LINK
        https://blog.noclocks.dev/lazy-loading-tab-completion-scripts-in-powershell
#>

$CompletionDir = Join-Path $(Split-Path -Parent $PROFILE.CurrentUserAllHosts) "Completions"
$CompletionScripts = @{
    "av1an"  = "$CompletionDir\av1an-completion.ps1"
    "mpv"    = "$CompletionDir\mpv-completion.ps1"
    "rclone" = "$CompletionDir\rclone-completion.ps1"
    "uv"     = "$CompletionDir\uv-completion.ps1"
    "winget" = "$CompletionDir\winget-completion.ps1"
}

Function Import-Completion {
    <#
    .SYNOPSIS
        Load the completion script for the specified command.
    .DESCRIPTION
        This function loads the completion script for the specified command by
        dot-sourcing the script file.

        The function checks if the completion script for the specified command
        exists in the `$CompletionScripts` hash table and if it has not already
        been loaded. If both conditions are met, the function dot-sources the
        completion script defined in the hash table and sets the
        `$Script:CompletionLoaded` hash table entry for the specified command
        to `$true` (for the current session).
    .PARAMETER CommandName
        The name of the command for which to load the completion script.
        This parameter is mandatory and accepts input from the pipeline.
        The value of this parameter is validated against the keys in the
        `$CompletionScripts` hash table defined in the `Completions.psd1` file.
   .NOTES
       This function is used to implement a lazy-loading mechanism for importing completion scripts.
    .EXAMPLE
        # Load the completion script for the `mpv` command.
        Load-Completion -CommandName "mpv"
        # Check if Loaded
        $Script:CompletionLoaded["mpv"]
    #>
    [CmdletBinding(
        SupportsShouldProcess = $false,
        ConfirmImpact = "None"
    )]
    Param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [ValidateScript({ $CompletionScripts.ContainsKey($_) })]
        [String]$CommandName
    )

    If ($CompletionScripts.ContainsKey($CommandName) -and -not $Script:CompletionLoaded[$CommandName]) {
        . $CompletionScripts[$CommandName]
        $Script:CompletionLoaded[$CommandName] = $true
    }
}

Register-ArgumentCompleter -Native -CommandName * -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    # Try to load the completion script for the typed command
    Import-Completion -CommandName $commandName

    # Returning nothing here; the actual completion is handled by the script if it exists
    return $null
}

# Hashtable to track which completions have been loaded
$script:CompletionLoaded = @{}
