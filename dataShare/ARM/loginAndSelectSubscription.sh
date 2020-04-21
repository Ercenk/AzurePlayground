#!/bin/bash

az login

az account list --output table

az account set --subscription "IndustryExperiencesInternal"