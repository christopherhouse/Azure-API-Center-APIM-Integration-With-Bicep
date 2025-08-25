# 🚀 Azure API Center & APIM Integration with Bicep
**Automate, Secure, and Connect your APIs with Azure API Center and APIM using Bicep!**

This repository demonstrates how to link an Azure API Center resource to an existing Azure API Management resource.  The approach shown here uses a User-Assigned Managed Identity for authorization to the API Management resource.

---

## 📦 Repository Structure


```text
main.bicep                # Main Bicep entry point orchestrating all resources
main.json                 # Compiled ARM template (optional)
modules/
  apiCenter.bicep         # Deploys API Center, workspace, and links APIM as a source
  identity.bicep          # Creates User Assigned Managed Identity (UAMI)
  roleAssignment-apimReader.bicep # Assigns APIM Reader role to UAMI on APIM
parameters/
  main.bicepparam         # Parameter file for main.bicep (default values)
  main.local.bicepparam   # Optional: local parameter overrides
```

## 🧩 Module Breakdown

- **main.bicep**: Orchestrates the deployment of all resources, including UAMI, role assignment, and API Center setup. Ensures correct dependency order.
- **modules/identity.bicep**: Provisions a User Assigned Managed Identity for secure resource access.
- **modules/roleAssignment-apimReader.bicep**: Assigns the API Management Service Reader role to the UAMI on the target APIM instance, enabling API Center to read APIs from APIM.
- **modules/apiCenter.bicep**: Deploys API Center, creates a workspace, and configures APIM as an API source using the UAMI for authentication.
- **parameters/main.bicepparam**: Provides default parameter values for deployments.

---

## 🛠️ Deployment Flow

1. **UAMI Creation**: A managed identity is created for secure access.
2. **Role Assignment**: The UAMI is granted the API Management Service Reader role on the target APIM instance.
3. **API Center Deployment**: API Center is provisioned with a workspace, and APIM is linked as a source using the UAMI.

---

## ⚡ Quickstart

### Prerequisites

- Azure CLI installed
- Bicep CLI installed
- Sufficient permissions to create resources in the target subscription/resource group

### Usage


1. Update the parameter file (`parameters/main.bicepparam`) with your environment values.
2. Deploy using Azure CLI:
  ```pwsh
  az deployment sub create --location <location> --template-file ./main.bicep --parameters @./parameters/main.bicepparam
  ```
3. Verify resources in the Azure Portal.

---

## 🎯 Purpose

This repo provides a repeatable, secure, and automated way to:
- Set up Azure API Center
- Integrate with existing APIM
- Use managed identities and least-privilege access
- Demonstrate modular Bicep practices for enterprise scenarios

---

## 📚 References

- [Azure API Center Documentation](https://learn.microsoft.com/en-us/azure/api-center/)
- [Azure API Management Documentation](https://learn.microsoft.com/en-us/azure/api-management/)
- [Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)

---
