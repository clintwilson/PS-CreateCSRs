#Get to cURL directory
$curl = "C:\Users\clint.wilson\AppData\Local\Apps\cURL\bin"
cd $curl

#Set up a results file path
$dir = [environment]::GetFolderPath("MyDocuments")

#Set up scan results Array
#$ids = New-Object System.Collections.ArrayList

Get-ChildItem "$dir\CIS\CSRs\" -Filter *.csr | ForEach-Object {
    $csr = Get-Content $_.FullName
    $csr = [string]::join("",$csr)    
    $fn = $_.BaseName     
    $name = "wilsonovi.com"
    $email = "clint@wilsonovi.com"
    $OU = "deviceID"
    $date = Get-Date -f o        
    $json = @"
{\"profile_name\":\"test_client_auth\",\"common_name\":\"$name\",\"emails\":[\"$email\"], \"csr\":\"$csr\",\"signature_hash\":\"sha256\",\"validity\":{\"days\":3},\"organization\":{\"name\":\"Clint Wilson\",\"units\":[\"$OU\"]}}
"@
    #write $json
    $ar = curl.exe -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'X-DC-DEVKEY: BAKFH5LRRPYKS6DNRFA35QJWBH4CK5DKGQJ7NWW2DMN72HVOKNXR6PDLNY7UWQJAFEU7HHQRO2CIPHH3V' -X POST -d $json https://www.digicert.com/platform/cis/certificate | ConvertFrom-Json    
    #write $ar   
    $id = $ar.id
    write $id    
    curl.exe -H 'X-DC-DEVKEY: BAKFH5LRRPYKS6DNRFA35QJWBH4CK5DKGQJ7NWW2DMN72HVOKNXR6PDLNY7UWQJAFEU7HHQRO2CIPHH3V' -X GET https://www.digicert.com/platform/cis/certificate/$id > $dir\CIS\Certs\"$fn"_"$id".crt
    $ids = $date + "," + "$fn" + "," + $ar.id + "," + $name + "," + $email + "," + $OU + "," + $csr
    Add-Content $dir\CIS\certID.txt "`n$ids"    
    }