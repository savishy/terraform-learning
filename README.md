# terraform-examples

## Prepare: Azure Account and Credentials

1. Create an Azure Account (if not already there)
1. Create an Azure Service Principal (if not already there)
1. Get the credentials and values for the 4 environment variables `AZURE_CLIENT_ID AZURE_CLIENT_SECRET AZURE_TENANT_ID AZURE_SUBSCRIPTION_ID`.
1. Edit the file `env.ps1` and `backend.ps1` and replace the values for `CHANGE_ME` with appropriate secret values:

```
$Env:AZURE_CLIENT_ID='CHANGE_ME'
$Env:AZURE_CLIENT_SECRET='CHANGE_ME'
$Env:AZURE_TENANT_ID='CHANGE_ME'
$Env:AZURE_SUBSCRIPTION_ID='CHANGE_ME'
```

## How to run

Assuming Powershell

1. `cd azure/0-linux-azure`
1. Execute a `terraform init` s
1. `terraform plan --var-file  .\poc.tfvars`
1. `terraform apply --var-file .\poc.tfvars`
