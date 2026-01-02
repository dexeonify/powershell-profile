Push-Location "D:\Programs"

function Test-NeedUpdate {
    <#
    .SYNOPSIS
        Checks for the latest version of release and decide if updating is needed.

    .DESCRIPTION
        Compares the current version of the program to the latest version on GitHub.
        Returns True or False for $NeedUpdate.

    .PARAMETER arg
        Specify the command line arguments to output the version of the program.

    .PARAMETER customtag
        Determine whether to compare to the original tag or custom tag.
        Usually, the same tag is used to identify the releases' version.
        Eg: If the tag is "v4.0.3", the release format would be "release-v4.0.3.zip"
        However, some GitHub repos uses a different tag (that's still derived
        from the original tag) for their releases.
        Eg: The tag is "v9.4.2", but the release format is "release-9.4.2.zip"
    #>
    param ($arg, $customtag)

    if ($customtag) {
        $script:Version = $Tag -replace $customtag
    } else {
        $script:Version = $Tag
    }
    return (Invoke-Expression $arg | Out-String) -notmatch $Version
}

function Get-LatestRelease {
    <#
    .SYNOPSIS
        Downloads the latest release based on the naming format.
    #>
    param ($format)

    Write-Host "Dowloading latest release of $RepoName…" -ForegroundColor Green
    $download = "https://github.com/$Repo/releases/download/$Tag/$format"
    aria2c --console-log-level=warn --allow-overwrite=true $download
}

function Invoke-7z {
    <#
    .SYNOPSIS
        Run 7-zip to extract and filter specific file(s).
    #>
    param ($file, $filter)

    Write-Host "Extracting $file" -ForegroundColor DarkGreen
    7z e -y -bso0 $file $filter
}

function Remove-Release {
    <#
    .SYNOPSIS
        Removes file, if $AutoRemove is True.
    #>
    param ($file)

    if ($AutoRemove -eq "Y") {
        Write-Host "Removing $file archive" -ForegroundColor Magenta
        Remove-Item $file | Out-Null
    }
}

function Read-KeyOrTimeout ($prompt, $key) {
    $seconds = 9
    $startTime = Get-Date
    $timeOut = New-TimeSpan -Seconds $seconds

    # Flush unwanted buffer prior to ReadKey()
    $HOST.UI.RawUI.Flushinputbuffer()

    Write-Host "$prompt " -ForegroundColor Green

    # Basic progress bar
    [Console]::CursorLeft = 0
    [Console]::Write("[")
    [Console]::CursorLeft = $seconds + 2
    [Console]::Write("]")
    [Console]::CursorLeft = 1

    while (-not [System.Console]::KeyAvailable) {
        $currentTime = Get-Date
        Start-Sleep -s 1
        Write-Host "█" -NoNewline
        if ($currentTime -gt $startTime + $timeOut) {
            Break
        }
    }
    if ([System.Console]::KeyAvailable) {
        $response = [System.Console]::ReadKey($true).Key
    }
    else {
        $response = $key
    }
    return $response.ToString()

    # Flush again
    $HOST.UI.RawUI.Flushinputbuffer()
}


$Repos = "qpdf/qpdf", "schollz/croc", "ImageOptim/gifski", "master-of-zen/Av1an", "BtbN/FFmpeg-Builds"
$AutoRemove = Read-KeyOrTimeout "Automatically remove downloaded packages? [Y/n] (default=Y)" "Y"
Write-Host ""

foreach ($Repo in $Repos) {
    $Releases = "https://api.github.com/repos/$Repo/releases"
    $RepoName = $Repo.Split("/")[1]

    Write-Host "`nChecking updates for $RepoName" -ForegroundColor Blue
    $Tag = (Invoke-WebRequest $Releases | ConvertFrom-Json)[0].tag_name
    Write-Host "Latest release: $Tag" -ForegroundColor DarkBlue

    switch ($RepoName) {
        "croc" {
            $NeedUpdate = Test-NeedUpdate -arg "croc --version"
            $FileFormat = "croc_$Version`_Windows-64bit.zip"
        }
        "qpdf" {
            $NeedUpdate = Test-NeedUpdate -arg "qpdf --version" -customtag ".*v"
            $FileFormat = "qpdf-$Version-msvc64.zip"
        }
        "gifski" {
            $NeedUpdate = Test-NeedUpdate -arg "gifski --version"
            $FileFormat = "gifski-$Version.tar.xz"
        }
        "av1an" {
            Get-LatestRelease -format "av1an.exe"
        }
        "FFmpeg-Builds" {
            $urls = (Invoke-WebRequest $Releases | ConvertFrom-Json)[0].assets.browser_download_url
            $download = $urls | Select-String "win64-gpl-shared.zip" -NoEmphasis
            $archive = Split-Path $download -Leaf
            Write-Host "Dowloading latest release of ffmpeg…" -ForegroundColor Green
            aria2c --console-log-level warn $download
            Invoke-7z -file $archive -filter @("*\bin\*.exe", "*\bin\*.dll")
            Remove-Release -file $archive
        }
    }

    switch ($RepoName) {
        {$NeedUpdate -and $_ -eq "croc"} {
            Get-LatestRelease -format $FileFormat
            Invoke-7z -file $FileFormat -filter "croc.exe"
            Remove-Release -file $FileFormat
        }
        {$NeedUpdate -and $_ -eq "qpdf"} {
            Get-LatestRelease -format $FileFormat
            Invoke-7z -file $FileFormat -filter "*\bin\qpdf*"
            Remove-Release -file $FileFormat
        }
        {$NeedUpdate -and $_ -eq "gifski"} {
            Get-LatestRelease -format $FileFormat
            cmd /c "7z x $FileFormat -so | 7z e -aoa -si -ttar win/gifski.exe" | Out-Null
            Remove-Release -file $FileFormat
        }
        Default {
            Write-Host "$RepoName updated!" -ForegroundColor Green
        }
    }
}

Pop-Location
