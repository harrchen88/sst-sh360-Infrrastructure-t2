<#
	.NOTES
		==============================================================================================
		Copyright(c) Microsoft Corporation. All rights reserved.

		File:		key.vault.output.tests.ps1

		Purpose:	Test - Key Vault ARM Template Output Variables

		Version: 	1.0.0.0 - 1st May 2019 - Azure Virtual Datacenter Development Team
		==============================================================================================

	.SYNOPSIS
		This script contains functionality used to test Key Vault ARM template output variables.

	.DESCRIPTION
		This script contains functionality used to test Key Vault ARM template output variables.

		Deployment steps of the script are outlined below.
			1) Outputs Variable Logic to pipeline

	.PARAMETER keyVaultName
		Specify the Key Vault Name output parameter.
	
	.EXAMPLE
		Default:
		C:\PS>.\key.vault.output.tests.ps1 `
			-keyVaultName <"keyVaultName"> 
#>

#Requires -Version 5

[CmdletBinding()]
param
(
    [Parameter(Mandatory = $false)]
    [string]$keyVaultName
)  
  
if ($keyVaultName -ne $null)
{
    write-output "Azure Key Vault Name: $($keyVaultName)"
}
else 
{
    write-output "Azure Key Vault Name: NULL"
}