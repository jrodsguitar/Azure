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
$gitrepo="https://github.com/Azure-Samples/app-service-web-dotnet-get-started.git"
$webappname="JoseWebApp$(Get-Random)"
$location="West US"
$appserviceplan = 'Default1'   


# Create a web app.
New-AzureRmWebApp -Name $webappname -Location $location -AppServicePlan $appserviceplan -ResourceGroupName $resourcegroup

# Configure GitHub deployment from your GitHub repo and deploy once.
$PropertiesObject = @{
    repoUrl = "$gitrepo";
    branch = "master";
    isManualIntegration = "true";
}
Set-AzureRmResource -PropertyObject $PropertiesObject -ResourceGroupName $resourcegroup -ResourceType Microsoft.Web/sites/sourcecontrols -ResourceName $webappname/web -ApiVersion 2015-08-01 -Force

$getwebappinfo = Get-AzureRmResource -ResourceGroupName $resourcegroup -ResourceName $webappname

Remove-AzureRmResource -ResourceGroupName $resourcegroup -ResourceType $getwebappinfo.ResourceType -ResourceName $webappname/web -ApiVersion 2015-08-01 -Force

    