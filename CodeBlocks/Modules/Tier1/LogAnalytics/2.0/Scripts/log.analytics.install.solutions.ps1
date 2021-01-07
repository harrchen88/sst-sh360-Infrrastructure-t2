<#
	.NOTES
		==============================================================================================
		Copyright(c) Microsoft Corporation. All rights reserved.
		
		File:		log.analytics.install.solutions

		Purpose:	Deploy Log Analytics Solutions Automation Script
		
		Version: 	1.0.0.0 - 1st April 2019 - Azure Virtual Datacenter Development Team
		==============================================================================================

	.SYNOPSIS
		Install Log Analytics Solutions Deployment Automation Script
	
	.DESCRIPTION
		Install Log Analytics Solutions Deployment Automation Script
		
		Deployment steps of the script are outlined below.
		1) Install Log Analytics Solutions

	.PARAMETER WorkspaceName  
		Specify the Log Analytics Workspace Name parameter.

	.PARAMETER Solutions [Array]
		Specify the Solutions parameter.

	.EXAMPLE
		Default:
		C:\PS>.\logAnalytics.install.solutions `
			-WorkspaceName <"omsWorkspaceName"> `
			-Solutions<"Solutions A","Solutions B">
#>

#Requires -Version 5
#Requires -Module AzureRM.OperationalInsights

[CmdletBinding()]
param
(
	[Parameter(Mandatory = $true)]
	[string]$WorkspaceName,
	[Parameter(mandatory = $true)]
	[string[]]$Solutions = @()
)

#region - Deployment
$paramGetAzureRmResource = @{
	ResourceName = $WorkspaceName
	ResourceType = "Microsoft.OperationalInsights/workspaces"
}
$Workspace = Get-AzureRmResource @paramGetAzureRmResource

foreach ($solution in $solutions)
{
	$Parameters = @{
		ResourceGroupName    = $Workspace.ResourceGroupName
		WorkspaceName	     = $Workspace.Name
		IntelligencePackName = $solution
		Enabled			     = $true
	}
	Set-AzureRmOperationalInsightsIntelligencePack @Parameters
}
#endregion