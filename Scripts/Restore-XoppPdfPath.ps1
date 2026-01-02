<#
    .SYNOPSIS
    A script to convert the absolute PDF path in old Xournal++ documents to
    relative path, so that they can be opened directly without going through a
    dialog. It can even prevent crashes in later versions of Xournal++!
#>

param ($Path)

$File = Get-Item $Path
$Dir = $File.DirectoryName

Write-Host "Extract xopp file (gzipped XML)" -ForegroundColor Green
$Xml = Join-Path $Dir "$($File.BaseName).xml"
# Specifiy filename when extracting using 7zip
# https://stackoverflow.com/a/62881726/16689935
7z.exe e $File -so > $Xml

Write-Host "Backup original xopp file" -ForegroundColor Green
$Backup = $File.Name + ".bak"
Rename-Item $File $Backup

Write-Host "Parse XML and correct absolute paths" -ForegroundColor Green
[xml]$XmlDoc = Get-Content $Xml
$Node = $XmlDoc.SelectSingleNode('//background[@filename]')
$Node.filename = $File.BaseName + ".pdf"
$XmlDoc.Save($Xml)

Write-Host "Repack XML to xopp file" -ForegroundColor Green
$Xopp = Join-Path $Dir "$($File.BaseName).xopp"
7z.exe a -tgzip -mx9 $Xopp $Xml
