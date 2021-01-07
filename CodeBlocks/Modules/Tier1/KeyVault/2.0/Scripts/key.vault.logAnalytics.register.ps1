<#
	.NOTES
		==============================================================================================
		Copyright(c) Microsoft Corporation. All rights reserved.
		
		File:		keyvault.logAnalytics.register.ps1

		Purpose:	Register Key Vault with Log Analytics Deployment Automation Script
		
		Version: 	1.0.0.0 - 1st May 2019 - Azure Virtual Datacenter Development Team
		==============================================================================================	

	.SYNOPSIS
		Register Key Vault with Log Analytics Deployment Automation Script
	
	.DESCRIPTION
		Register Key Vault with Log Analytics Deployment Automation Script
		
		Deployment steps of the script are outlined below.
		1) Register Key Vault with Log Analytics

	.PARAMETER keyVaultName
		Specify the key Vault Name parameter.

	.PARAMETER diagstorageAccountName
		Specify the diagnostic Storage Account Name parameter.

	.PARAMETER logAnalyticsWorkspaceName  
		Specify the Log Analytics Workspace Name parameter.
		
	.EXAMPLE
		Default:
		C:\PS>.\key.vault.logAnalytics.register.ps1 `
			-keyVaultName <"keyVaultName"> `
			-diagstorageAccountName <"diagstorageAccountName"> `
			-logAnalyticsWorkspaceName <"logAnalyticsWorkspaceName">
#>

#Requires -Version 5
#Requires -Module AzureRM.Resources
#Requires -Module AzureRM.Insights

[CmdletBinding()]
param
(
    [Parameter(Mandatory = $true)]
    [string]$keyVaultName,
    [Parameter(Mandatory = $true)]
    [string]$diagstorageAccountName,
    [Parameter(Mandatory = $true)]
    [string]$logAnalyticsWorkspaceName
)

#region - Register Keyvault with OMS
$paramGetAzureRmResource = @{	
    ResourceName = $keyVaultName
    ResourceType = "Microsoft.DocumentDb/databaseAccounts"
}
$keyVault = Get-AzureRmResource @paramGetAzureRmResource

$paramGetAzureRmResource = @{
    ResourceName = $diagstorageAccountName
    ResourceType = "Microsoft.Storage/storageAccounts" 
}
$storageAccount = Get-AzureRmResource @paramGetAzureRmResource

$paramGetAzureRmResource = @{
    ResourceName = $logAnalyticsWorkspaceName
    ResourceType = "Microsoft.OperationalInsights/workspaces"
}
$workspaceName = Get-AzureRmResource @paramGetAzureRmResource

$paramSetAzureRmDiagnosticSetting = @{
    ResourceId       = $keyVault.ResourceId
    StorageAccountId = $storageAccount.Id
    WorkspaceId      = $workspaceName.Id
    Enabled          = $true	
}
Set-AzureRmDiagnosticSetting @paramSetAzureRmDiagnosticSetting
#endregion