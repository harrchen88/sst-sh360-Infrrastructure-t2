<#
	.NOTES
		==============================================================================================
		Copyright(c) Microsoft Corporation. All rights reserved.

		File:		application.insights.output.test.ps1

		Purpose:	Test - Application Insight ARM Template Output Variables

		Version: 	1.0.0.0 - 1st April 2019 - Azure Virtual Datacenter Development Team
		==============================================================================================

	.SYNOPSIS
		This script contains functionality used to test Application Insights ARM Template Output Variables.

	.DESCRIPTION
		This script contains functionality used to test Application Insights ARM Template Output Variables.

		Deployment steps of the script are outlined below.
            1) Outputs Variable Logic from pipeline

	.PARAMETER appInsightsName
		Specify the Application Insights Name output parameter.

	.PARAMETER appInsightsKey
		Specify the Application Insights Key output parameter.

	.PARAMETER appInsightsAppId
		Specify the Application Insights AppId output parameter.
		
    .PARAMETER appInsightsStorageAccountName
		Specify the Application Insights Storage Account Name output parameter.
			
	.EXAMPLE
		Default:
		C:\PS>.\application.insights.outputs.test.ps1 `
            -appInsightsName <"appInsightsName"> `
            -appInsightsKey <"appInsightsKey"> `
            -appInsightsAppId <"appInsightsAppId"> `
            -appInsightsStorageAccountName <"appInsightsStorageAccountName"> 		
#>

#Requires -Version 5

[CmdletBinding()]
param
(
    [Parameter(Mandatory = $false)]
    [string]$appInsightsName,

    [Parameter(Mandatory = $false)]
    [string]$appInsightsKey,

    [Parameter(Mandatory = $false)]
    [string]$appInsightsAppId,
    
    [Parameter(Mandatory = $false)]
    [string]$appInsightsStorageAccountName
)

#region - AppInsight
if($appInsightsName -ne $null)
{
    write-output "Application Insights Name: $($appInsightsName)"
}
else
{
    write-output "Application Insights Name: NULL"
}

if($appInsightsKey -ne $null)
{
    write-output "Application Insights Instrumentation Key: $($appInsightsKey)"
}
else
{
    write-output "Application Insights Instrumentation Key: NULL"
}

if($appInsightsAppId -ne $null)
{
    write-output "Application Insights AppId: $($appInsightsAppId)"
}
else
{
    write-output "Application Insights AppId: NULL"
}

if($appInsightsStorageAccountName -ne $null)
{
    write-output "Application Insights Storage Account Name: $($appInsightsStorageAccountName)"
}
else
{
    write-output "Application Insights Storage Account Name: NULL"
}
#endregion
