 param(

 [string]$resourceGroupName,
 [string]$VaultName

 )

#get-rsvaultdisksizes.ps1 -resourceGroupName "nameofResourceGroup" -VaultName "nameOfVault"
#Jose Rodriguez - 2/22/2020
#Run this at your own damn risk
#Know what it does before blindly running it. I am NOT responsible for your failure to read the above warning, nor any utter destruction this may cause due to your negligence.

if($PSBoundParameters.Keys -ne $null){

    #get protected items. In this case we are assuming it's a managed disk and each Vm ONLY has 1 Managed disk. Obviously you will need to customize this based on your needs
    try{
        $protecteditems = (Get-AzureRmResource -ResourceGroupName $resourceGroupName -ResourceType Microsoft.RecoveryServices/vaults/replicationProtectedItems -ResourceName $VaultName -ApiVersion 2016-08-10)
    }
    
    catch{
        Write-Output $_.Exception.Message
        break
    }
    
    #Array to store protecteditems
    $finalprotecteditemsobject = @()
    
    #loop through each protected item and record the disk size in an array
    foreach($protecteditem in $protecteditems){
    
        #You may want to add another loop that iterates over each disk of the vm here if it applies to you
    
        $protecteditemsobject = @{
    
        disksize = $protecteditem.Properties.providerSpecificDetails.protectedManagedDisks.diskcapacityinbytes
    
        vmname = $protecteditem.Properties.friendlyname
        }
    
        #append result to object
        $finalprotecteditemsobject += New-Object psobject -Property $protecteditemsobject   
    }
    
    #Return all vm's and disks for those vm's.
    $finalprotecteditemsobject

    #You'll want to do math here with $finalprotecteditemsobject disksize to get a final size so that's on you to add 
}

else {

    Write-Output `
    "`t" `
    "You need to pass the resourceGroupName and vaultname dude" `
    "`t" `
    "EXAMPLE:" `
    "get-rsvaultdisksizes.ps1 -resourceGroupName 'nameofResourceGroup' -VaultName 'nameOfVault'" `
    "`t" `
    "WARNING!!!!!!!!!!!!!!!!" `
    "`t" `
    "Run this at your own damn risk. Know what it does before blindly running it." `
    "`t" `
    "I am NOT responsible for your failure to read the above warning, nor any utter destruction this may cause due to your negligence." `
    "`t" `
    "-Jose Rodriguez - 2/22/2020" `

}