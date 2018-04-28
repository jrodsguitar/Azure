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

    if($azad -eq $null){
    $azad = Connect-AzureAD
    }





    
Function runSQLQuery()
{
    param
    ($queryInput, 
    $connectionString)

$connection = New-Object -TypeName System.Data.SqlClient.SqlConnection($connectionString)
$query = $QueryInput
$command = New-Object -TypeName System.Data.SqlClient.SqlCommand($query, $connection)
$connection.Open()
$command.ExecuteNonQuery()
$result = $command.ExecuteReader()
$table = new-object “System.Data.DataTable”
$table.clear()
$table.Load($result)
return $table
$connection.Close()

}



$user = "$($azcred.GetNetworkCredential().UserName)@answerfinancial.com"
# Replace the following URL with a public GitHub repo URL
$json="https://raw.githubusercontent.com/jrodsguitar/Azure/master/webapp/deployWebAppAAD.json"


$webappname = "josewebapp$(Get-Random)"
$appplanname = "joseappplanname$(Get-Random)"
$repourl = "https://github.com/jrodsguitar/dotnetcore-sqldb-tutorial-aadauth.git"
$branch = "master"

$dbname ="josedb$(Get-Random)"
$sqlserverAdminLogin = "sqladmin"

$password = Read-Host -assecurestring "Set DB password. Enter a password."
$sqlserverAdminPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
$sqlservername = "josedbserv$(Get-Random)"




$AADAdminLogin = Get-AzureADUser -SearchString $secure.aaduser
$AADAdminObjectID = $AADAdminLogin.objectid


        $params =  @{
        'TemplateURI' = "$json";
        "webappname" = "$webappname";
        "appplanname" = "$appplanname";
        "repoURL" = "$repoURL";
        "branch" = "$branch";
        "databaseName" = "$dbname";
        "sqlserverAdminLogin" = "$sqlserverAdminLogin";
        "sqlserverAdminPassword" = "$sqlserverAdminPassword";
        "sqlserverName" = "$sqlserverName";
        "AADAdminLogin" = "$($AADAdminLogin.userprincipalname)"
        "AADAdminObjectID" =  "$AADAdminObjectID"
    
        }


#Deploy

#test-AzureRmResourceGroupDeployment @params -ResourceGroupName $resourcegroup -ApiVersion 2014-04-01

New-AzureRmResourceGroupDeployment  @params -ResourceGroupName $resourcegroup -ApiVersion 2014-01-01 -Force

$getdb = Get-AzureRmSqlDatabase -ResourceGroupName $resourcegroup -ServerName $sqlservername -DatabaseName $dbname

$connectionstring = "Server=tcp:$($getdb.servername).database.windows.net,1433;Initial Catalog=$($getdb.databasename);Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Authentication='Active Directory Integrated';"

$query = ("

select * from master

"
)
runSQLQuery -queryInput $queryinput -connectionString $connectionstring

#$getwebappinfo = Get-AzureRmResource -ResourceGroupName $resourcegroup

#Remove-AzureRmResource -ResourceGroupName $resourcegroup -ResourceType $getwebappinfo.ResourceType -ResourceName $resourcename-ApiVersion 2015-08-01 -Force

    