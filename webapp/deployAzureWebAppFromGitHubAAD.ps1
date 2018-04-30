param(
$pass,
$resourcegroup,
$aduser,
$appid,
$certname,
$certpass,
$certthumb,
$aztenid,
$certpath
)

#Install-packageprovider -name nuget -force -scope CurrentUser

#install-module -name AzureAD -force -verbose -Scope CurrentUser

#$secure = Import-Csv C:\me\github\secure\secure.csv

<# if($azcred -eq $null){
    $azcred = Get-Credential
    }

    $subscrname   = $secure.subscrname
    $resourcegroup = $secure.resourcegroup
    
    if($azacct -eq $null){
    $azacct = Login-AzureRmAccount -Subscription $subscrname
    }
 #>
   # if($azad -eq $null){
    #$azad = Connect-AzureAD -AccountId $azaccountid -AadAccessToken $azaccesstoken -TenantId $azTenId

    #}

# Replace the following URL with a public GitHub repo URL
Get-AzureRmADUser -SearchString "$aduser" -Verbose
$cert = "$($env:System_DefaultWorkingDirectory)" + '\' + "$certname"

#Write-host "certutil -addstore -user -f 'My' $cert"
#certutil -addstore -user -f "My" $cert

certutil -f -user -p $certpass -importpfx $cert NoRoot

Write-Output "Login-AzureRmAccount -ApplicationId $appid -CertificateThumbprint $certthumb -ServicePrincipal -TenantId $aztenid"
Login-AzureRmAccount -ApplicationId $appid -CertificateThumbprint $certthumb -ServicePrincipal -TenantId $aztenid -Verbose

$json="https://raw.githubusercontent.com/jrodsguitar/Azure/master/webapp/deployWebAppAAD.json"

$webappname = "josewebapp$(Get-Random)"
$appplanname = "joseappplanname$(Get-Random)"
$repourl = "https://github.com/jrodsguitar/dotnetcore-sqldb-tutorial-aadauth.git"
$branch = "master"

$dbname ="josedb$(Get-Random)"
$sqlserverAdminLogin = "sqladmin"

#$password = Read-Host -assecurestring "Set DB password. Enter a password."
#$sqlserverAdminPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
$sqlservername = "josedbserv$(Get-Random)"


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

    