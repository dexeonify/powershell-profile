param ($Path)

$File = Get-Item $Path
$Dir = $File.DirectoryName
$Backup = $File.Name + ".bak"
$Xml = Join-Path $Dir "$($File.BaseName).xml"
$Xopp = Join-Path $Dir "$($File.BaseName).xopp"

Write-Host "Extract xopp (gzipped XML file)" -ForegroundColor Green
7z.exe e $File -so | Out-File -FilePath $Xml

Write-Host "Backup original xopp file" -ForegroundColor Green
Rename-Item $File $Backup

Write-Host "Parse XML and correct absolute paths" -ForegroundColor Green
[xml]$XmlDoc = Get-Content $Xml
$Node = $XmlDoc.SelectSingleNode('//background[@filename]')
$Node.filename = $File.BaseName + ".pdf"
$XmlDoc.Save($Xml)

Write-Host "Repack XML to xopp file" -ForegroundColor Green
7z.exe a -tgzip -mx9 $Xopp $Xml
