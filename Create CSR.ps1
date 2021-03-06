#Get to OpenSSL directory

$openssl = Read-Host 'Enter full path to "OpenSSL\bin" folder. Please note: "openssl.cfg" must be present in this folder.'
cd $openssl


#Set up storage files paths
$dir = [environment]::GetFolderPath("MyDocuments")
$papa = New-Item -ItemType Directory -Force -Path "$dir\CIS"
$certi = New-Item -ItemType Directory -Force -Path "$papa\Certs"
$keys = New-Item -ItemType Directory -Force -Path "$papa\Keys"
$csr = New-Item -ItemType Directory -Force -Path "$papa\CSRs"

#How many key pairs?
do {
    try {
        $isint = $true
        [int]$n = Read-Host -Prompt 'How many key pairs to generate?'
        } #end try
    catch {$isint = $false}
    } #end do
until ($n -ge 0 -and $isint)


#EC or RSA  
$ec = Read-Host 'EC certs? (y/n)'
while("y","n" -notcontains $ec)
{
    $ec = Read-Host 'EC certs (y/n'
}


#EC
if ($ec -eq "y")
{    
    for ($k=1; $k -le $n; $k++)
        {
            $name = "secp256k1"
            Invoke-Expression "openssl ecparam -out 1.pkey -name $name -genkey" 
            Invoke-Expression "openssl req -new -key 1.pkey -nodes -out 1.csr -batch -config `"C:\Users\clint.wilson\Google Drive\Open2SSL-Win64\bin\openssl.cfg`""
            Move-Item $openssl\1.pkey $keys\$k.pkey -force
            Move-Item $openssl\1.csr $csr\$k.csr -force
        }
}

#RSA
elseif ($ec -eq "n")
{
    #Get KeySize
    do  
    {
        try {
        $isint = $true
        [int]$keysize = Read-Host -Prompt 'RSA Keysize? (2048[recommended], 4096, or 8192)'
        } #end try
        catch {$isint = $false}
    } #end do
    until ((($keysize -eq "2048") -or ($keysize -eq "4096") -or ($keysize -eq "8192")) -and $isint)

    #Generate keypairs
    for ($k=1; $k -le $n; $k++)
    {      
        Invoke-Expression "openssl req -new -newkey rsa:$keysize -nodes -out 1.csr -keyout 1.pkey -batch -config `"$openssl\openssl.cfg`""            
        Move-Item $openssl\1.pkey $keys\$k.pkey -force
        Move-Item $openssl\1.csr $csr\$k.csr -force
    }
}

#WTF
else
{
    Write-Host "Wow, what'd you do"
}
