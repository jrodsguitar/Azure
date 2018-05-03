param(
$pass,
$resourcegroup,
$aduser
)

$json="https://raw.githubusercontent.com/jrodsguitar/Azure/master/webapp/deployWebAppAAD.json"

$random = $(get-random)
$webappname = "josewebapp$($random)"
$appplanname = "joseappplanname$($random)"
$repourl = "https://github.com/jrodsguitar/dotnetcore-sqldb-tutorial-aadauth.git"
$branch = "master"

$dbname ="josedb$($random)"
$sqlserverAdminLogin = "sqladmin"

$sqlservername = "josedbserv$($random)"


$AADAdminLogin  = Get-AzureRmADUser -SearchString "$aduser" -Verbose
Write-Output $aadminlogin
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
write-output "New-AzureRmResourceGroupDeployment @params -ResourceGroupName $resourcegroup -ApiVersion 2014-01-01 -Force -Verbose"

New-AzureRmResourceGroupDeployment @params -ResourceGroupName $resourcegroup -ApiVersion 2014-01-01 -Force -Verbose
    