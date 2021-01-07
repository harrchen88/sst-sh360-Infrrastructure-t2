<#
   .NOTES
      ============================================================================================================
      Copyright (c) Microsoft Corporation. All rights reserved.

      File:		Remove.Resource.Deployments.ps1

      Purpose:	Removes Azure DevOps Resource Deployment Records

      Version: 	1.0.0.0 - 1st February 2019 - Build Release Deployment Team
   ============================================================================================================

   .SYNOPSIS
      Removes Azure DevOps Resource Deployment Records

   .DESCRIPTION
      This script is used to Remove Azure DevOps Resource Deployment Records
	
	.PARAMETER ResourceGroups
		Specify the Names of the Resource Groups.

   .EXAMPLE
      C:\PS>  .\Remove.Resource.Deployments.ps1 `
					-ResourceGroups "<RG>","<RG>"

#>

#Requires -Version 5

[CmdletBinding()]
param
(
	[Parameter(Mandatory = $true, Position = 1)]
	[ValidateNotNullOrEmpty()]
	[string[]]$ResourceGroups
)

#region - Removing ResourceGroup Deployments
foreach ($ResourceGroup in $ResourceGroups)
{
	$paramWriteOutput = @{
		InputObject = "Removing ResourceGroup Deployments for $ResourceGroup"
	}
	Write-output @paramWriteOutput
	
	$paramGetAzureRmResourceGroupDeployment = @{
		ResourceGroupName = $ResourceGroup
	}
	Get-AzureRmResourceGroupDeployment @paramGetAzureRmResourceGroupDeployment | Select-Object -Skip 100 | Remove-AzureRmResourceGroupDeployment
}
#endregion
