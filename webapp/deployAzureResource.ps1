$secure = Import-Csv C:\me\github\secure\secure.csv


if($azcred -eq $null){
    $azcred = Get-Credential
    }

    $azTenId    = $secure.azTenId
    $subscrname   = $secure.subscrname
    $resourcegroup = $secure.resourcegroup
    
    if($azacct -eq $null){
    $azacct = Login-AzureRmAccount -Subscription $subscrname
    }
    



# Replace the following URL with a public GitHub repo URL
$json="https://raw.githubusercontent.com/jrodsguitar/Azure/master/webapp/deployDB.json"


$dbname ="josedb$(Get-Random)"
$sqlserverAdminLogin = "sqladmin"

$password = Read-Host -assecurestring "Set DB password. Enter a password."
$sqlserverAdminPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
$sqlservername = "josedbserv$(Get-Random)"


        $params =  @{
        'TemplateURI' = "$json";
        "databaseName" = "$dbname";
        "sqlserverAdminLogin" = "$sqlserverAdminLogin";
        "sqlserverAdminPassword" = "$sqlserverAdminPassword";
        "sqlserverName" = "$sqlserverName";
    
        }
        

#Deploy

                
                 
# DELETE SB-JoseVM
#Remove-AzureRmResource -ResourceGroupName SANDBOX_SRV_SERVERS -ResourceType Microsoft.Compute/virtualMachines -ResourceName "SB-JoseVM" -ApiVersion 2017-12-01 -Force
    
# DELETE SB-JoseVMNic
#Remove-AzureRmResource -ResourceGroupName SANDBOX_SRV_SERVERS -ResourceType Microsoft.Network/networkInterfaces -ResourceName "SB-JoseVMNic" -ApiVersion 2017-03-01 -Force
    

#test-AzureRmResourceGroupDeployment @params -ResourceGroupName $resourcegroup -ApiVersion 2014-04-01


New-AzureRmResourceGroupDeployment  @params -ResourceGroupName $resourcegroup -ApiVersion 2014-01-01 -Force


#$getwebappinfo = Get-AzureRmResource -ResourceGroupName $resourcegroup -ResourceName $resourcename

#Remove-AzureRmResource -ResourceGroupName $resourcegroup -ResourceType $getwebappinfo.ResourceType -ResourceName $resourcename-ApiVersion 2015-08-01 -Force

    