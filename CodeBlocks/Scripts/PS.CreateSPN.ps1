# Login

Login-AzAccount

# Create Service Principal

Import-Module Az
$spDisplayName = 'ps-<YOURALIAS>'
$password = (New-Guid).guid
$credentials = New-Object Microsoft.Azure.Commands.ActiveDirectory.PSADPasswordCredential -Property @{ StartDate=Get-Date; EndDate=Get-Date -Year 2024; Password=$password}
$sp = New-AzAdServicePrincipal -DisplayName $spDisplayName -PasswordCredential $credentials

Write-Warning "DisplayName: $($sp.DisplayName) (WRITE THIS DOWN)"
Write-Warning "Password: $password (WRITE THIS DOWN)"
Write-Warning "ApplicationId: $($sp.ApplicationId.guid) (WRITE THIS DOWN)" 
Write-Warning "ObjectId: $($sp.Id) (WRITE THIS DOWN)"
Write-Warning "TenantId: $((Get-AzContext).Tenant.Id) (WRITE THIS DOWN)"
Write-Warning "SubscriptionId $((Get-AzContext).Subscription.Id) (WRITE THIS DOWN)"

# Add Role Assignment

Start-Sleep 30 #Please wait some seconds since the creation of a Service Principal takes some time to reflect in Azure

$appID = (Get-AzADServicePrincipal -DisplayName $spDisplayName).ApplicationID
New-AzRoleAssignment -ApplicationID $appID -RoleDefinitionName 'Owner'