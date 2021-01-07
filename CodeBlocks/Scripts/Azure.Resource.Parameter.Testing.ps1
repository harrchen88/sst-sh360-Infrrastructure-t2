<#
 	.NOTES
 		============================================================================================================
		Copyright (c) Microsoft Corporation. All rights reserved.

		File:		Azure.Resource.Parameter.Testing

		Purpose:	Azure Resource Parameter Testing Script
		
		Version: 	1.0.0.0 - 1st February 2019 - Build Release Deployment Team
	============================================================================================================

 	.SYNOPSIS
		PowerShell Module Update Script

 	.DESCRIPTION
		Azure Resource Parameter Testing Script

		Resource Regions
		1) Azure Search
		2) Azure KeyVault
		3) Azure Redis Cache
		4) Log Analytics
		5) Storage Accounts
		6) Comosdb
		7) Applications Insights

#>

$jsonParameters = @{ }

#region - Azure Search
Get-AzureRmProviderOperation -OperationSearchString "Microsoft.Search/*" | Format-Table Operation

$Parameters = @{
	ResourceType = "Microsoft.Search/searchServices"
}
$resource = Get-AzureRmResource @Parameters

$Parameters = @{
	ResourceId = $resource.Id
}
$resource = Get-AzureRmResource @Parameters
$resource

$resource | get-member
$resource | Select-Object -ExpandProperty Properties
$resource

$Parameters = @{
	Action	   = 'listAdminKeys'
	ResourceId = $resource.ResourceId
	ApiVersion = '2015-08-19'
}
$apiKey = (Invoke-AzureRmResourceAction @Parameters -Force).PrimaryKey

$jsonParameters.Add("Search--ServiceName", $resource.Name)
$jsonParameters.Add("Serach--APIKey", $apiKey)

#endregion

#region - Azure KeyVault
Get-AzureRmProviderOperation -OperationSearchString "Microsoft.KeyVault/*" | Format-Table Operation

$Parameters = @{
	ResourceType = "Microsoft.KeyVault/vaults"
}
$resource = Get-AzureRmResource @Parameters

$Parameters = @{
	ResourceId = $resource.Id
}
$resource = Get-AzureRmResource @Parameters
$resource

$resource | get-member
$resource | Select-Object -ExpandProperty Properties
$resource

$jsonParameters.Add("KeyVault--Name", $($resource.Name))

#endregion

#region - Azure Redis Cache
Get-AzureRmProviderOperation -OperationSearchString "Microsoft.Cache/*" | Format-Table Operation

$Parameters = @{
	ResourceType = "Microsoft.Cache/Redis"
    ResourceName = "devcrsrediscache001"
}
$resource = Get-AzureRmResource @Parameters

$Parameters = @{
    ResourceId = $resource.Id 
       
}
$resource = Get-AzureRmResource @Parameters
$resource

$resource | get-member
$resource | Select-Object -ExpandProperty Properties
$resource 

$Parameters = @{
    Action              = 'listKeys'
    ResourceType        = "Microsoft.Cache/Redis"
    ApiVersion          = "2018-03-01" 
    ResourceGroupName   = $resource.ResourceGroupName 
    Name                = $resource.Name
}
$RedisCacheKey = (Invoke-AzureRmResourceAction @Parameters -Force).primaryKey

$jsonParameters.Add("RedisCache--Name", $($resource.Name))

#endregion

#region - Log Analytics
Get-AzureRmProviderOperation -OperationSearchString "Microsoft.OperationalInsights/*" | Format-Table Operation

$Parameters = @{
	ResourceType = "Microsoft.OperationalInsights/workspaces"
}
$resource = Get-AzureRmResource @Parameters

$resource
$resource | get-member
$resource | Select-Object -ExpandProperty Properties
$resource

#endregion

#region - Storage Accounts
Get-AzureRmProviderOperation -OperationSearchString "Microsoft.Storage/*" | Format-Table Operation

$Parameters = @{
	ResourceType = "Microsoft.Storage/storageAccounts"
	ResourceName = 'devcrsdiagsta001'
}
$resource = Get-AzureRmResource @Parameters

$Parameters = @{
	ResourceId = $resource.Id
}
$resource = Get-AzureRmResource @Parameters
$resource

$resource | get-member
$resource | Select-Object -ExpandProperty Properties
$resource

$Parameters = @{
	Action	   = 'listkeys'
	ResourceId = $resource.ResourceId
}
$storagekey = (Invoke-AzureRmResourceAction @Parameters -Force).keys[0].value
$storagekey

#endregion

#region - Comosdb
Get-AzureRmProviderOperation -OperationSearchString "Microsoft.DocumentDb/*" | Format-Table Operation

$Parameters = @{
	ResourceType = "Microsoft.DocumentDb/databaseAccounts"
}
$resource = Get-AzureRmResource @Parameters

$Parameters = @{
	ResourceId = $resource.Id
}
$resource = Get-AzureRmResource @Parameters
$resource

$resource | get-member
$resource | Select-Object -ExpandProperty Properties
$resource

$Parameters = @{
	Action		      = 'listKeys'
	ResourceType	  = "Microsoft.DocumentDb/databaseAccounts"
	ApiVersion	      = "2015-04-08"
	ResourceGroupName = $resource.ResourceGroupName
	Name			  = $resource.Name
}
$dbPassword = (Invoke-AzureRmResourceAction @Parameters -Force).primaryMasterKey

$Parameters = @{
	Action		      = 'listConnectionStrings'
	ResourceType	  = "Microsoft.DocumentDB/databaseAccounts"
	ApiVersion	      = "2015-04-08"
	ResourceGroupName = $resource.ResourceGroupName
	Name			  = $resource.Name
}
$dbConnectionString = Invoke-AzureRmResourceAction @Parameters -Force

$jsonParameters.Add("Comosdb--ResourceGroupName", $($resource.ResourceGroupName))
$jsonParameters.Add("Comosdb--dbServerName", $($resource.Name))
$jsonParameters.Add("Comosdb--dbPassword", $($dbPassword))
$jsonParameters.Add("Comosdb--dbConnectionString", $($dbConnectionString))
#endregion

#region - Applications Insights
Get-AzureRmProviderOperation -OperationSearchString "Microsoft.Insights/*" | Format-Table Operation

$Parameters = @{
	ResourceType = "Microsoft.Insights/components"
	ResourceName = "devcrsappinsights001"
}
$resource = Get-AzureRmResource @Parameters

$Parameters = @{
	ResourceId = $resource.Id
}
$resource = Get-AzureRmResource @Parameters
$resource

$resource | get-member
$resource | Select-Object -ExpandProperty Properties
$resource

$resource.ResourceGroupName
$resource.Properties.AppId
$resource.Properties.InstrumentationKey

$jsonParameters.Add("Insights--Name", $($resource.Name))
$jsonParameters.Add("Insights--InstrumentationKey", $ikey)
#endregion

#region - Read Hash Parameters
$jsonParameters.Keys | ForEach-Object {
	$key = $_
	$value = $jsonParameters.Item($_)
	"key = $key , value = $value "
}

$Key = "Rules--AzureSearchConfig--SearchServiceName"
if (Get-AzureKeyVaultSecret -VaultName "dev-crs-keyvault-sta-001" | Where-Object { $psitem.Name -eq "$Key" })
{
	$true
}
else
{
	$false
}
#endregion