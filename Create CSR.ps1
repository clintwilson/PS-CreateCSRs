#Get to OpenSSL directory
$openssl = "C:\Users\clint.wilson\Google Drive\Open2SSL-Win64\bin"
cd $openssl
$ErrorActionPreference = "SilentlyContinue"

#Set up a results file path
$dir = [environment]::GetFolderPath("MyDocuments")
#openssl.exe 2>&1 $null

$n = Read-Host -Prompt 'How many key pairs to generate?'
#$n=1

for ($k=1; $k -le $n; $k++)
    {
        #openssl ecparam -out 1.pkey -name secp256k1 -genkey
        openssl req -new -newkey rsa:2048 -nodes -out 1.csr -keyout 1.pkey -subj "/C=US/ST=Alabama/L=a/O=a/OU=a/CN=a" -config "C:\Users\clint.wilson\Google Drive\Open2SSL-Win64\bin\openssl.cfg"
        #openssl req -new -key 1.pkey -nodes -out 1.csr -subj "/C=US/ST=Alabama/L=a/O=a/OU=a/CN=a" -config "C:\Users\clint.wilson\Google Drive\Open2SSL-Win64\bin\openssl.cfg"
        Move-Item "C:\Users\clint.wilson\Google Drive\Open2SSL-Win64\bin\1.pkey" $dir\CIS\Keys\$k.pkey -force
        Move-Item "C:\Users\clint.wilson\Google Drive\Open2SSL-Win64\bin\1.csr" $dir\CIS\CSRs\$k.csr -force
    }

