# Key Vault

This module deploys Azure Key Vault 

https://docs.microsoft.com/en-us/azure/templates/microsoft.keyvault/allversions


## Resources

The following Resources are deployed.

+ **Key Vault**
+ **DiagnosticSettings**


## Parameters

+ **keyVaultName** - Name of the Azure Key Vault
+ **accessPolicies** - Access policies object
+ **secretsObject** - all secrets wrapped in a secure object
+ **logsRetentionInDays** - Specifies the number of days that logs will be kept for, a value of 0 will retain data. indefinitely
+ **enableVaultForDeployment** - Specifies if the vault is enabled for deployment by script or compute
+ **enableVaultForDiskEncryption** - Specifies if the azure platform has access to the vault for enabling disk encryption scenarios
+ **vaultSku** - Specifies the SKU for the vault
+ **diagnosticStorageAccountName** - Diagnostics Storage Account Name
+ **diagnosticStorageAccountRG** - Diagnostics Storage Account Resource Group name
+ **logAnalyticsWorkspaceResourceGroup** - Log Analytics Workspace Resource Group Name
+ **logAnalyticsWorkspaceName** - Log Analytics Workspace name


## Outputs

+ **keyVaultName**
 

## Scripts

+ **key.vault.backup.ps1**   
+ **key.vault.logAnalytics.register.ps1**   
+ **key.vault.restore.ps1**   
+ **key.vault.secrect.rules.ps1**   