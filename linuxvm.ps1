## PARAMETERS

$resourceGroup="hopixLinux"

$availabilitySetName="linux-avaSet"

$vnetName="linux-VNet"

$nsgName="linux-NSG"

$location="canadaeast"

$vms=@("webServer1","webServer2")

# Create the resources group
New-AzureRmResourceGroup -Name $resourceGroup -Location $location

# Create the availability set
New-AzureRmAvailabilitySet -Location $location `
    -Name $availabilitySetName `
    -ResourceGroupName $resourceGroup `
    -PlatformUpdateDomainCount 2 `
    -PlatformFaultDomainCount 2


# Create the VNET options

# Create web rules port 80 and 443
$webRule = New-AzureRmNetworkSecurityRuleConfig -Name web `
                -Description "port 80 web" `
                -Access Allow `
                -Protocol Tcp `
                -Direction Inbound `
                -Priority 100 `
                -SourceAddressPrefix Internet `
                -SourcePortRange * `
                -DestinationAddressPrefix * `
                -DestinationPortRange 80

$sslRule = New-AzureRmNetworkSecurityRuleConfig -Name webSSL `
                -Description "port 443 SSL" `
                -Access Allow `
                -Protocol Tcp `
                -Direction Inbound `
                -Priority 101 `
                -SourceAddressPrefix Internet `
                -SourcePortRange * `
                -DestinationAddressPrefix * `
                -DestinationPortRange 443


# create the NSG
$nsg = New-AzureRmNetworkSecurityGroup -Name $nsgName `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -SecurityRules $webRule,$sslRule

# Create the subnet and VNET
$frontendSubnet= New-AzureRmVirtualNetworkSubnetConfig -Name "frontendSubnet" `
                    -AddressPrefix "10.0.1.0/24" `
                    -NetworkSecurityGroup $nsg

New-AzureRmVirtualNetwork -Name $vnetName `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -AddressPrefix "10.0.0.0/16" `
    -Subnet $frontendSubnet


#foreach($vm in $vms)
#{
#    New-AzureRmVM -ResourceGroupName $resourceGroup `
#        -Name $vm `
#        -AvailabilitySetName $availabilitySetName `
#        -Size Standard_DS1_v2       
#}

