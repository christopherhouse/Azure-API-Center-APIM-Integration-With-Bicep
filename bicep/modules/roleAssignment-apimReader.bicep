// modules/roleAssignment-apimReader.bicep
param apimSubscriptionId string
param apimResourceGroup string
param apimName string
param principalId string
targetScope = 'resourceGroup'

var roleDefId = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '71522526-b88f-4d52-b57f-d31fc3546d0d' // API Management Service Reader
)

resource apim 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: apimName
  scope: resourceGroup(apimSubscriptionId, apimResourceGroup)
}

resource apimReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(apim.id, principalId, roleDefId)
  properties: {
    roleDefinitionId: roleDefId
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}
