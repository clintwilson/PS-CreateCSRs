#Get to OpenSSL directory
$openssl = "C:\Users\clint.wilson\Google Drive\Open2SSL-Win64\bin"
cd $openssl

#Set up a results file path
$dir = [environment]::GetFolderPath("MyDocuments")

do {
    try {
        $isint = $true
        [int]$n = Read-Host -Prompt 'How many key pairs to generate?'
        } #end try
    catch {$isint = $false}
    } #end do
until ($n -ge 0 -and $isint)
  
$ec = Read-Host 'EC certs? (y/n)'

while("y","n" -notcontains $ec)
{
    $ec = Read-Host 'EC certs (y/n'
}



if ($ec -eq "y")
{    
    for ($k=1; $k -le $n; $k++)
        {
            openssl ecparam -out 1.pkey -name secp256k1 -genkey            
            openssl req -new -key 1.pkey -nodes -out 1.csr -subj "/C=US/ST=Alabama/L=a/O=a/OU=a/CN=a" -config "C:\Users\clint.wilson\Google Drive\Open2SSL-Win64\bin\openssl.cfg"
            Move-Item $openssl\1.pkey $dir\CIS\Keys\$k.pkey -force
            Move-Item $openssl\1.csr $dir\CIS\CSRs\$k.csr -force
        }
}

elseif ($ec -eq "n")
{
  

    for ($k=1; $k -le $n; $k++)
        {
            openssl req -new -newkey rsa:2048 -nodes -out 1.csr -keyout 1.pkey -batch -config "C:\Users\clint.wilson\Google Drive\Open2SSL-Win64\bin\openssl.cfg"            
            Move-Item $openssl\1.pkey $dir\CIS\Keys\$k.pkey -force
            Move-Item $openssl\1.csr $dir\CIS\CSRs\$k.csr -force
        }
}
else
{
Write-Host "Wow, what'd you do"
}
