#!/bin/bash

resourceGroupName="ercdatashare"
location="eastus2"

az group create --name "$resourceGroupName" --location "$location"
az group deployment create --resource-group "$resourceGroupName" --name "createShare" --template-file ./azuredeployCreateShare.json --parameters ./parametersCreateShare.json