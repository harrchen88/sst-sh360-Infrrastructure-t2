$ResourceGroupName   = 'RG-DOJO-WESTUS2-SHD-DEV';
$DBResourceGroupName = 'RG-DOJO-WESTUS2-PAAS-DEV'
$VNetName            = 'dojohubvnet';
$SubnetName          = 'sub_infraapp';
$SubnetAddressPrefix = '10.1.1.0/24'; # Looks roughly like: '10.0.0.0/24'
$SqlDbServerName = 'bookingsappsql01';
$VNetRuleName        = 'appsrvtosqldb'

$ServiceEndpointTypeName_SqlDb = 'Microsoft.Sql';  # Do NOT edit. Is official value.

### 2. Search for your virtual network, and then for your subnet.

# Search for the virtual network.
$vnet = Get-AzVirtualNetwork `
  -ResourceGroupName $ResourceGroupName `
  -Name              $VNetName;

$subnet = $null;
for ($nn=0; $nn -lt $vnet.Subnets.Count; $nn++)
{
    $subnet = $vnet.Subnets[$nn];
    if ($subnet.Name -eq $SubnetName)
    { break; }
    $subnet = $null;
}

### 4. Add a Virtual Service endpoint of type name 'Microsoft.Sql', on your subnet and also the rule

$vnet = Set-AzVirtualNetworkSubnetConfig `
  -Name            $SubnetName `
  -AddressPrefix   $SubnetAddressPrefix `
  -VirtualNetwork  $vnet `
  -ServiceEndpoint $ServiceEndpointTypeName_SqlDb;

# Persist the subnet update.
$vnet = Set-AzVirtualNetwork `
  -VirtualNetwork $vnet;

$vnetRuleObject1 = $null;

$vnetRuleObject1 = Get-AzSqlServerVirtualNetworkRule `
  -ResourceGroupName      $DBResourceGroupName `
  -ServerName             $SqlDbServerName `
  -VirtualNetworkRuleName $VNetRuleName;
  ##-VirtualNetworkSubnetId $subnet.Id;

if ($null -eq $vnetRuleObject1)
{

    $vnetRuleObject1 = New-AzSqlServerVirtualNetworkRule `
  -ResourceGroupName      $DBResourceGroupName `
  -ServerName             $SqlDbServerName `
  -VirtualNetworkRuleName $VNetRuleName `
  -VirtualNetworkSubnetId $subnet.Id;

}
else { Write-Host "Already exist"; }