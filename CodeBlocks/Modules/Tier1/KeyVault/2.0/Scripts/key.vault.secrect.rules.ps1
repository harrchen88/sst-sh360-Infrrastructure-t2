<#
	.NOTES
		==============================================================================================
		Copyright(c) Microsoft Corporation. All rights reserved.

		File:		key.vault.secrect.rules.ps1

		Purpose:	Set Key Vault Secrets Automation Script

		Version: 	1.0.0.0 - 1st May 2019 - Azure Virtual Datacenter Development Team
		==============================================================================================

	.SYNOPSIS
		Set Key Vault Secrets Automation Script

	.DESCRIPTION
		Set Key Vault Secrets Automation Script

		Deployment steps of the script are outlined below.
		1) Set Azure KeyVault Parameters
		2) Set SQLDB Parameters
		3) Create Azure KeyVault Secret
			
	.PARAMETER keyVaultName
		Specify the Azure KeyVault Name parameter.
		
	.PARAMETER sqlDBConnectionString
		Specify the SQLDB Connection String parameter.	
	
	.EXAMPLE
		Default:
		C:\PS>.\key.vault.secrect.rules.ps1
#>

#Requires -Version 5
#Requires -Module AzureRM.KeyVault

[CmdletBinding()]
param
(
	[Parameter(Mandatory = $false)]
	[string]$keyVaultName,	
	[Parameter(Mandatory = $false)]	
	[string]$sqlDBConnectionString	
)

#region - Azure KeyVault Parameters
$kVSecretParameters = @{ }

if ($keyVaultName -ne $null)
{
	$kVSecretParameters.Add("Secert--KeyVault--VaultName", $($keyVaultName))	
}
else
{
	write-output "KeyVaultName : NULL"
}
#endregion

#region - SQLDB Parameters
if ($sqlDBConnectionString -ne $null)
{
	$kVSecretParameters.Add("Secert--SQLDB--ConnectionString", $($sqlDBConnectionString))	
}
else
{
	write-output "SQLDBConnectionString : NULL"
}
#endregion

#region - Set Azure KeyVault Secret
$kVSecretParameters.Keys | ForEach-Object {
	$key = $_
	$value = $kVSecretParameters.Item($_)
	
	$Parameters = @{
		VaultName = $keyVaultName
	}
	if (Get-AzureKeyVaultSecret @Parameters | Where-Object { $psitem.Name -eq "$key" })
	{
		Write-Output "The secret for $key already exists"
	}
	else
	{
		Write-Output "Setting Secret for $key"
		$Parameters = @{
			VaultName   = $keyVaultName
			Name	    = $key
			SecretValue = (ConvertTo-SecureString $value -AsPlainText -Force)
		}
		Set-AzureKeyVaultSecret @Parameters -Verbose
	}
}
#endregion