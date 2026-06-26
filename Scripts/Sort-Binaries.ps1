Push-Location D:\Programs

$folders = @{
    "video" = ".\Video"
    "audio" = ".\Audio"
    "image" = ".\Image"
    "others" = ".\Others"
    "ffmpeg" = ".\Video\ffmpeg"
}

$categories = @{
    "video" = "aomenc.exe", "av1an.exe", "mediainfo.exe", "SvtAv1EncApp.exe", "vpxenc.exe"
    "image" = "avifenc.exe", "cjxl.exe", "cwebp.exe","gifski.exe", "mozjpeg.exe"
    "others" = "croc.exe", "qpdf.exe", "qpdf30.dll"
    "ffmpeg" = "ffmpeg.exe", "ffplay.exe", "ffprobe.exe",
               "avcodec-63.dll", "avfilter-12.dll", "avformat-63.dll", "avutil-61.dll",
               "avdevice-63.dll", "swresample-7.dll", "swscale-10.dll"
}

Get-ChildItem -Path * -Include "*.exe", "*.dll" | ForEach-Object {
    $file = $_.Name
    try {
        $category = ($categories.GetEnumerator() | Where-Object Value -contains $file).Name
        $folder = $folders.$category
        Write-Host "$file is categorised as $category, moving to $folder." -ForegroundColor Blue
        Move-Item $file -Destination $folder -Force
    }
    catch {
        Write-Warning "$file does not belong in any categories."
    }
}

Pop-Location
