@description('Location for UAMI and API Center')
param location string = 'eastus'

@description('UAMI name to create')
param uamiName string = 'apic-api-source-mi'

@description('API Center service name to create')
param apiCenterName string = 'api-source-apic'

@description('API Center workspace name to create')
param workspaceName string = 'default'

@description('Existing APIM subscription ID')
param apimSubscriptionId string = '47046546-29e0-4be5-bdda-78a53f62b992'

@description('Existing APIM resource group name')
param apimResourceGroup string = 'BR-APIM-APIC'

@description('Existing APIM service name')
param apimName string = 'apim-br-apim-apic'

module uami './modules/identity.bicep' = {
  name: 'uami'
  params: {
    uamiName: uamiName
    location: location
  }
}

module apimReader './modules/roleAssignment-apimReader.bicep' = {
  name: 'apimReader'
  scope: resourceGroup(apimSubscriptionId, apimResourceGroup)
  params: {
    apimSubscriptionId: apimSubscriptionId
    apimResourceGroup: apimResourceGroup
    apimName: apimName
    principalId: uami.outputs.principalId
  }
}

// Ensure role assignment exists before API Center tries to read APIM
module apiCenter './modules/apiCenter.bicep' = {
  name: 'apiCenter'
  params: {
    apiCenterName: apiCenterName
    workspaceName: workspaceName
    location: location
    apimSubscriptionId: apimSubscriptionId
    apimResourceGroup: apimResourceGroup
    apimName: apimName
    uamiResourceId: uami.outputs.id
  }
  dependsOn: [
    apimReader
  ]
}

output apiCenterId string = apiCenter.outputs.apiCenterId
output workspaceId string = apiCenter.outputs.workspaceId
output uamiId string = uami.outputs.id
