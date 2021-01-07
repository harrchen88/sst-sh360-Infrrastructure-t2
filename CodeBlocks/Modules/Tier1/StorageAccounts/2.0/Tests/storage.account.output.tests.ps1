<#
	.NOTES
		==============================================================================================
		Copyright(c) Microsoft Corporation. All rights reserved.

		File:		storage.account.output.tests.ps1

		Purpose:	Test - Storage Account ARM Template Output Variables

		Version: 	1.0.0.0 - 1st May 2019 - Azure Virtual Datacenter Development Team
		==============================================================================================

	.SYNOPSIS
		This script contains functionality used to test Storage Account ARM template output variables.

	.DESCRIPTION
		This script contains functionality used to test Storage Account ARM template output variables.

		Deployment steps of the script are outlined below.
			1) Outputs Variable Logic to pipeline

	.PARAMETER storageAccountName
		Specify the Storage Account Name output parameter.

	.PARAMETER storageAccountResourceId
		Specify the storage Account ResourceId output parameter.
	
	.EXAMPLE
		Default:
		C:\PS>.\storage.account.output.tests.ps1 `
			-storageAccountName <"storageAccountName"> `
			-storageAccountResourceId <"storageAccountResourceId">
#>

#Requires -Version 5

[CmdletBinding()]
param
(
    [Parameter(Mandatory = $false)]
    [string]$storageAccountName,
	[Parameter(Mandatory = $false)]
    [string]$storageAccountResourceId
)

if($storageAccountName -ne $null)
{
    write-output "Storage Account Name: $($storageAccountName)" 
}
else
{
    write-output "Storage Account Name: NULL"
}

if($storageAccountResourceId -ne $null)
{
    write-output "Storage Account ResourceId: $($storageAccountResourceId)" 
}
else
{
    write-output "Storage Account ResourceId: NULL"
}