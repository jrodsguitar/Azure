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
$json="https://github.com/jrodsguitar/Azure/blob/master/webapp/deployDB.json"
$resourcename="JoseResource$(Get-Random)"
$location="West US"

    
  
        $params =  @{
        'TemplateURI' = $json
    
        }
        

#Deploy

                
                 
# DELETE SB-JoseVM
#Remove-AzureRmResource -ResourceGroupName SANDBOX_SRV_SERVERS -ResourceType Microsoft.Compute/virtualMachines -ResourceName "SB-JoseVM" -ApiVersion 2017-12-01 -Force
    
# DELETE SB-JoseVMNic
#Remove-AzureRmResource -ResourceGroupName SANDBOX_SRV_SERVERS -ResourceType Microsoft.Network/networkInterfaces -ResourceName "SB-JoseVMNic" -ApiVersion 2017-03-01 -Force
    



New-AzureRmResourceGroupDeployment @params -ResourceGroupName $resourcegroup -Name $resourcename -ApiVersion 2014-04-01 -Force


#$getwebappinfo = Get-AzureRmResource -ResourceGroupName $resourcegroup -ResourceName $resourcename

#Remove-AzureRmResource -ResourceGroupName $resourcegroup -ResourceType $getwebappinfo.ResourceType -ResourceName $resourcename-ApiVersion 2015-08-01 -Force

    