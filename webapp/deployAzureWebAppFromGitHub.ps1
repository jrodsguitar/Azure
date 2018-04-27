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
$json="https://raw.githubusercontent.com/jrodsguitar/Azure/master/webapp/deployWebApp.json"


$webappname = "josewebapp$(Get-Random)"
$appplanname = "appplanname$(Get-Random)"
$repourl = "https://github.com/jrodsguitar/jrodsguitar-app-service-web-dotnet-get-started-master.git"
$branch = "master"
$pidguid = new-guid


        $params =  @{
        'TemplateURI' = "$json";
        "webappname" = "$webappname";
        "appplanname" = "$appplanname";
        "repoURL" = "$repoURL";
        "branch" = "$branch";
        "pidguid" = "$pidguid";
    
        }


#Deploy

#test-AzureRmResourceGroupDeployment @params -ResourceGroupName $resourcegroup -ApiVersion 2014-04-01

New-AzureRmResourceGroupDeployment  @params -ResourceGroupName $resourcegroup -ApiVersion 2014-01-01 -Force

#$getwebappinfo = Get-AzureRmResource -ResourceGroupName $resourcegroup

#Remove-AzureRmResource -ResourceGroupName $resourcegroup -ResourceType $getwebappinfo.ResourceType -ResourceName $resourcename-ApiVersion 2015-08-01 -Force

    