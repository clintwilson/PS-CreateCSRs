$dir = [environment]::GetFolderPath("MyDocuments")
Remove-Item $dir\CIS\CSRs\*
Remove-Item $dir\CIS\Keys\*
Remove-Item $dir\CIS\Certs\*
Remove-Item $dir\CIS\certID.txt