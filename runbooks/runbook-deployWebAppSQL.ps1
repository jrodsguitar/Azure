param(


$namePrefix,


$pass,

$resourcegroup = 'NAME_OF_RESOURCE_GROUP',

$aduser = 'ADUSER_WHO_YOU_WANT_TO_MANAGE_DB'
)
$namePrefix = $namePrefix.ToLower()
$pass = $pass.ToLower()
# Authenticate to Azure if running from Azure Automation
$ServicePrincipalConnection = Get-AutomationConnection -Name "AzureRunAsConnection"
Login-AzureRmAccount `
    -ServicePrincipal `
    -TenantId $ServicePrincipalConnection.TenantId `
    -ApplicationId $ServicePrincipalConnection.ApplicationId `
    -CertificateThumbprint $ServicePrincipalConnection.CertificateThumbprint | Write-Verbose
    
$json="https://raw.githubusercontent.com/jrodsguitar/Azure/master/webapp/deployWebAppAAD.json"

$random = $(Get-Random)
$webappname = "$($namePrefix)webapp$($random)"
$appplanname = "$($namePrefix)appplanname$($random)"
$repourl = "https://github.com/jrodsguitar/dotnetcore-sqldb-tutorial-aadauth.git"
$branch = "master"

$dbname ="$($namePrefix)db$($random)"
$sqlserverAdminLogin = "sqladmin"

#$password = Read-Host -assecurestring "Set DB password. Enter a password."
#$sqlserverAdminPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
$sqlservername = "$($namePrefix)dbserv$($random)"


$AADAdminLogin  = Get-AzureRmADUser -SearchString "$aduser" -Verbose
Write-Output $aadminlogin
#$AADAdminLogin = Get-AzureADUser -SearchString $aduser
$AADAdminObjectID = $AADAdminLogin.id


        $params =  @{
        'TemplateURI' = "$json";
        "webappname" = "$webappname";
        "appplanname" = "$appplanname";
        "repoURL" = "$repoURL";
        "branch" = "$branch";
        "databaseName" = "$dbname";
        "sqlserverAdminLogin" = "$sqlserverAdminLogin";
        "sqlserverAdminPassword" = "$pass";
        "sqlserverName" = "$sqlserverName";
        "AADAdminLogin" = "$($AADAdminLogin.userprincipalname)"
        "AADAdminObjectID" =  "$AADAdminObjectID"
    
        }

#Deploy

#test-AzureRmResourceGroupDeployment @params -ResourceGroupName $resourcegroup -ApiVersion 2014-04-01
write-output "New-AzureRmResourceGroupDeployment @params -ResourceGroupName $resourcegroup -ApiVersion 2014-01-01 -Force -Verbose"

New-AzureRmResourceGroupDeployment @params -ResourceGroupName $resourcegroup -ApiVersion 2014-01-01 -Force -Verbose

#$getwebappinfo = Get-AzureRmResource -ResourceGroupName $resourcegroup

#Remove-AzureRmResource -ResourceGroupName $resourcegroup -ResourceType $getwebappinfo.ResourceType -ResourceName $resourcename-ApiVersion 2015-08-01 -Force

    