# Create a VM and a storage account, and assign the system assigned managed identity  to the file share

Query the existing roles

`az role definition list --query "[].{Name:roleName, Id:name}[?contains(Name,'Storage')]" --output table

