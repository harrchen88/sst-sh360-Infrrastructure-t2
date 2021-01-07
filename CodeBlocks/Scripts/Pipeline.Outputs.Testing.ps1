<#
	.NOTES
		==============================================================================================
		Copyright(c) Microsoft Corporation. All rights reserved.

		File:		tier1.<resource>.output.test.ps1

		Purpose:	Test - <resource> ARM Template Output Variables

		Version: 	1.0.0.0 - 1st April 2019 - Build Release Deployment Team
		==============================================================================================

	.SYNOPSIS
		This script contains functionality used to test <resource> ARM template output variables.

	.DESCRIPTION
		This script contains functionality used to test <resource> ARM template output variables.

		Deployment steps of the script are outlined below.
            1) Outputs Variable Logic into pipeline

	.PARAMETER resourceGroupName
		Specify the resourceGroupName output parameter.
	
	.EXAMPLE
		Default:
		C:\PS> tier1.<resource>.output.test.ps1 `
			-resourceGroupName <"resourceGroupName"> 
			
#>

#Requires -Version 5

[CmdletBinding()]
param
(
	[Parameter(Mandatory = $false)]
	[string]$resourceGroupName
)

#region - Get Output Template Variables into pipeline
$paramGetAzureRmResourceGroupDeployment = @{
	ResourceGroupName = $resourceGroupName
}
$lastDeployment = Get-AzureRmResourceGroupDeployment @paramGetAzureRmResourceGroupDeployment | Sort-Object Timestamp -Descending | Select-Object -First 1

if (-not $lastDeployment)
{
	throw "Deployment could not be found for Resource Group '$resourceGroupName'."
}

if (-not $lastDeployment.Outputs)
{
	throw "No output parameters could be found for the last deployment of Resource Group '$resourceGroupName'."
}

foreach ($key in $lastDeployment.Outputs.Keys)
{
	$type = $lastDeployment.Outputs.Item($key).Type
	$value = $lastDeployment.Outputs.Item($key).Value
	
	if ($type -eq "SecureString")
	{
		Write-Host "##vso[task.setvariable variable=$key;issecret=true]$value"
	}
	else
	{
		Write-Host "##vso[task.setvariable variable=$key;]$value"
	}
}
#endregion
