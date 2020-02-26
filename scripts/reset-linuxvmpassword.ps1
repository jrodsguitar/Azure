
#Reset Linux VM password example
$vm = get-azvm

$linuxExtensionParams = @{

    'VMName'             = $vm.Name
    'ResourceGroupName'  = $vm.ResourceGroupName
    'Name'               = 'VMAccessForLinux'
    'Location'           = $vm.Location
    'Type'               = 'VMAccessForLinux'
    'TypeHandlerVersion' = 1.4
    'Publisher'          = 'Microsoft.OSTCExtensions'

}

Set-AzVMExtension @linuxExtensionParams -ProtectedSettings @{'password' = $pass; 'username' = $userName }