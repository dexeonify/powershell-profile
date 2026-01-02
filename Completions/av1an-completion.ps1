
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName 'av1an' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'av1an'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-') -or
                $element.Value -eq $wordToComplete) {
                break
        }
        $element.Value
    }) -join ';'

    $completions = @(switch ($command) {
        'av1an' {
            [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Input file to encode')
            [CompletionResult]::new('--proxy', '--proxy', [CompletionResultType]::ParameterName, 'Input proxy file for Scene Detection and Target Quality')
            [CompletionResult]::new('-o', '-o', [CompletionResultType]::ParameterName, 'Video output file')
            [CompletionResult]::new('--temp', '--temp', [CompletionResultType]::ParameterName, 'Temporary directory to use')
            [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, 'Log file location under ./logs [default: ./logs/av1an.log]')
            [CompletionResult]::new('--log-file', '--log-file', [CompletionResultType]::ParameterName, 'Log file location under ./logs [default: ./logs/av1an.log]')
            [CompletionResult]::new('--log-level', '--log-level', [CompletionResultType]::ParameterName, 'Set log level for log file (does not affect command-line log level)')
            [CompletionResult]::new('--completions', '--completions', [CompletionResultType]::ParameterName, 'Generate shell completions for the specified shell and exit')
            [CompletionResult]::new('--max-tries', '--max-tries', [CompletionResultType]::ParameterName, 'Maximum number of chunk restarts for an encode')
            [CompletionResult]::new('-w', '-w', [CompletionResultType]::ParameterName, 'Number of workers to spawn [0 = automatic]')
            [CompletionResult]::new('--workers', '--workers', [CompletionResultType]::ParameterName, 'Number of workers to spawn [0 = automatic]')
            [CompletionResult]::new('--set-thread-affinity', '--set-thread-affinity', [CompletionResultType]::ParameterName, 'Pin each worker to a specific set of threads of this size (disabled by default)')
            [CompletionResult]::new('--scaler', '--scaler', [CompletionResultType]::ParameterName, 'Scaler used for scene detection (if --sc-downscale-height XXXX is used) and VMAF calculation')
            [CompletionResult]::new('--vspipe-args', '--vspipe-args', [CompletionResultType]::ParameterName, 'Pass python argument(s) to the script environment --vspipe-args "message=fluffy kittens" "head=empty"')
            [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'File location for scenes')
            [CompletionResult]::new('--scenes', '--scenes', [CompletionResultType]::ParameterName, 'File location for scenes')
            [CompletionResult]::new('--split-method', '--split-method', [CompletionResultType]::ParameterName, 'Method used to determine chunk boundaries')
            [CompletionResult]::new('--sc-method', '--sc-method', [CompletionResultType]::ParameterName, 'Scene detection algorithm to use for av-scenechange')
            [CompletionResult]::new('--sc-downscale-height', '--sc-downscale-height', [CompletionResultType]::ParameterName, 'Optional downscaling for scene detection')
            [CompletionResult]::new('--sc-pix-format', '--sc-pix-format', [CompletionResultType]::ParameterName, 'Perform scene detection with this pixel format')
            [CompletionResult]::new('-x', '-x', [CompletionResultType]::ParameterName, 'Maximum scene length')
            [CompletionResult]::new('--extra-split', '--extra-split', [CompletionResultType]::ParameterName, 'Maximum scene length')
            [CompletionResult]::new('--extra-split-sec', '--extra-split-sec', [CompletionResultType]::ParameterName, 'Maximum scene length, in seconds')
            [CompletionResult]::new('--min-scene-len', '--min-scene-len', [CompletionResultType]::ParameterName, 'Minimum number of frames for a scenecut')
            [CompletionResult]::new('--force-keyframes', '--force-keyframes', [CompletionResultType]::ParameterName, 'Comma-separated list of frames to force as keyframes')
            [CompletionResult]::new('-e', '-e', [CompletionResultType]::ParameterName, 'Video encoder to use')
            [CompletionResult]::new('--encoder', '--encoder', [CompletionResultType]::ParameterName, 'Video encoder to use')
            [CompletionResult]::new('-v', '-v', [CompletionResultType]::ParameterName, 'Parameters for video encoder')
            [CompletionResult]::new('--video-params', '--video-params', [CompletionResultType]::ParameterName, 'Parameters for video encoder')
            [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Number of encoder passes')
            [CompletionResult]::new('--passes', '--passes', [CompletionResultType]::ParameterName, 'Number of encoder passes')
            [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'FFmpeg filter options')
            [CompletionResult]::new('--ffmpeg', '--ffmpeg', [CompletionResultType]::ParameterName, 'FFmpeg filter options')
            [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'Audio encoding parameters (ffmpeg syntax)')
            [CompletionResult]::new('--audio-params', '--audio-params', [CompletionResultType]::ParameterName, 'Audio encoding parameters (ffmpeg syntax)')
            [CompletionResult]::new('-m', '-m', [CompletionResultType]::ParameterName, 'Method used for piping exact ranges of frames to the encoder')
            [CompletionResult]::new('--chunk-method', '--chunk-method', [CompletionResultType]::ParameterName, 'Method used for piping exact ranges of frames to the encoder')
            [CompletionResult]::new('--chunk-order', '--chunk-order', [CompletionResultType]::ParameterName, 'The order in which av1an will encode chunks')
            [CompletionResult]::new('--photon-noise', '--photon-noise', [CompletionResultType]::ParameterName, 'Generates a photon noise table and applies it using grain synthesis [strength: 0-64] (disabled by default)')
            [CompletionResult]::new('--photon-noise-width', '--photon-noise-width', [CompletionResultType]::ParameterName, 'Manually set the width for the photon noise table')
            [CompletionResult]::new('--photon-noise-height', '--photon-noise-height', [CompletionResultType]::ParameterName, 'Manually set the height for the photon noise table')
            [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'Determines method used for concatenating encoded chunks and audio into output file')
            [CompletionResult]::new('--concat', '--concat', [CompletionResultType]::ParameterName, 'Determines method used for concatenating encoded chunks and audio into output file')
            [CompletionResult]::new('--pix-format', '--pix-format', [CompletionResultType]::ParameterName, 'FFmpeg pixel format')
            [CompletionResult]::new('--zones', '--zones', [CompletionResultType]::ParameterName, 'Path to a file specifying zones within the video with differing encoder settings.')
            [CompletionResult]::new('--vmaf-path', '--vmaf-path', [CompletionResultType]::ParameterName, 'Path to VMAF model (used by --vmaf and --target-quality)')
            [CompletionResult]::new('--vmaf-res', '--vmaf-res', [CompletionResultType]::ParameterName, 'Resolution used for VMAF calculation')
            [CompletionResult]::new('--probe-res', '--probe-res', [CompletionResultType]::ParameterName, 'Resolution used for Target Quality metric calculation in the form of `widthxheight` where width and height are positive integers')
            [CompletionResult]::new('--vmaf-threads', '--vmaf-threads', [CompletionResultType]::ParameterName, 'Number of threads to use for target quality VMAF calculation')
            [CompletionResult]::new('--vmaf-filter', '--vmaf-filter', [CompletionResultType]::ParameterName, 'Filter applied to source at VMAF calcualation')
            [CompletionResult]::new('--target-quality', '--target-quality', [CompletionResultType]::ParameterName, 'Target a metric score range for encoding (disabled by default)')
            [CompletionResult]::new('--qp-range', '--qp-range', [CompletionResultType]::ParameterName, 'Quantizer range bounds for target quality search (disabled by default)')
            [CompletionResult]::new('--interp-method', '--interp-method', [CompletionResultType]::ParameterName, 'Interpolation methods for target quality probing')
            [CompletionResult]::new('--target-metric', '--target-metric', [CompletionResultType]::ParameterName, 'The metric used for Target Quality mode')
            [CompletionResult]::new('--probes', '--probes', [CompletionResultType]::ParameterName, 'Maximum number of probes allowed for target quality')
            [CompletionResult]::new('--probing-rate', '--probing-rate', [CompletionResultType]::ParameterName, 'Only use every nth frame for VMAF calculation, while probing')
            [CompletionResult]::new('--probing-speed', '--probing-speed', [CompletionResultType]::ParameterName, 'Speed for probes. Lower speed for higher quality and accuracy')
            [CompletionResult]::new('--probing-vmaf-features', '--probing-vmaf-features', [CompletionResultType]::ParameterName, 'VMAF calculation features for target quality probing')
            [CompletionResult]::new('--probing-stat', '--probing-stat', [CompletionResultType]::ParameterName, 'Statistical method for calculating target quality from sorted probe scores')
            [CompletionResult]::new('-q', '-q', [CompletionResultType]::ParameterName, 'Disable printing progress to the terminal')
            [CompletionResult]::new('--quiet', '--quiet', [CompletionResultType]::ParameterName, 'Disable printing progress to the terminal')
            [CompletionResult]::new('--verbose', '--verbose', [CompletionResultType]::ParameterName, 'Print extra progress info and stats to terminal')
            [CompletionResult]::new('-r', '-r', [CompletionResultType]::ParameterName, 'Resume previous session from temporary directory')
            [CompletionResult]::new('--resume', '--resume', [CompletionResultType]::ParameterName, 'Resume previous session from temporary directory')
            [CompletionResult]::new('-k', '-k', [CompletionResultType]::ParameterName, 'Do not delete the temporary folder after encoding has finished')
            [CompletionResult]::new('--keep', '--keep', [CompletionResultType]::ParameterName, 'Do not delete the temporary folder after encoding has finished')
            [CompletionResult]::new('--force', '--force', [CompletionResultType]::ParameterName, 'Do not check if the encoder arguments specified by -v/--video-params are valid')
            [CompletionResult]::new('--no-defaults', '--no-defaults', [CompletionResultType]::ParameterName, 'Do not include Av1an''s default set of encoder parameters')
            [CompletionResult]::new('-y', '-y', [CompletionResultType]::ParameterName, 'Overwrite output file, without confirmation')
            [CompletionResult]::new('-n', '-n', [CompletionResultType]::ParameterName, 'Never overwrite output file, without confirmation')
            [CompletionResult]::new('--sc-only', '--sc-only', [CompletionResultType]::ParameterName, 'Run the scene detection only before exiting')
            [CompletionResult]::new('--tile-auto', '--tile-auto', [CompletionResultType]::ParameterName, 'Estimate tile count from source')
            [CompletionResult]::new('--ignore-frame-mismatch', '--ignore-frame-mismatch', [CompletionResultType]::ParameterName, 'Ignore any detected mismatch between scene frame count and encoder frame count')
            [CompletionResult]::new('--chroma-noise', '--chroma-noise', [CompletionResultType]::ParameterName, 'Adds chroma grain synthesis to the grain table generated by `--photon-noise`. (Default: false)')
            [CompletionResult]::new('--vmaf', '--vmaf', [CompletionResultType]::ParameterName, 'Plot an SVG of the VMAF for the encode')
            [CompletionResult]::new('--probe-slow', '--probe-slow', [CompletionResultType]::ParameterName, 'Use encoding settings for probes specified by --video-params rather than faster, less accurate settings')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            [CompletionResult]::new('-V', '-V ', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('--version', '--version', [CompletionResultType]::ParameterName, 'Print version')
            break
        }
    })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}
