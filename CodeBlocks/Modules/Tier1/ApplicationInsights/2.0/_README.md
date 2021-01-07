# Application Insights

This module deploys Application Insights. 

https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/allversions


## Resources

The following Resources are deployed.

+ **Application Insights**


## Parameters

+ **appInsightsName** - Name of the Application Insights
+ **appInsightsType** - Application type
+ **location** - Location for all Resources
+ **storageAccountName** - Storage Account Name
+ **storageAccountType** - Storage Account type


## Outputs

  + **appInsightsName**
  + **appInsightsKey**
  + **appInsightsAppId**
  + **appInsightsStorageAccountName** 


## Scripts

+ **tier1.app.insights.continuous.export.ps1**   