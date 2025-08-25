param apiCenterName string
param workspaceName string
param location string

param apimSubscriptionId string
param apimResourceGroup string
param apimName string
param uamiResourceId string

// API Center service
resource svc 'Microsoft.ApiCenter/services@2024-06-01-preview' = {
  name: apiCenterName
  location: location
  sku: {
    name: 'Free'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uamiResourceId}': {}
    }
  }
  // identity block optional; include if you want API Center to have an identity itself
  // identity: { type: 'UserAssigned', userAssignedIdentities: { '${uamiResourceId}': {} } }
}

// Workspace under the service
resource ws 'Microsoft.ApiCenter/services/workspaces@2024-06-01-preview' = {
  name: workspaceName
  parent: svc
  properties: {
    title: workspaceName
    description: 'Workspace created via Bicep'
  }
}

// Link APIM as a source in API Center
var apimId = resourceId(apimSubscriptionId, apimResourceGroup, 'Microsoft.ApiManagement/service', apimName)

resource apiSource 'Microsoft.ApiCenter/services/workspaces/apiSources@2024-06-01-preview' = {
  parent: ws
  name: 'apim'
  properties: {
    azureApiManagementSource: {
      resourceId: apimId
      msiResourceId: uamiResourceId
    }
    // Optional knobs:
    // importSpecification: 'ondemand' // 'always' | 'never' | 'ondemand'
    // targetLifecycleStage: 'production'
  }
}

output apiCenterId string = svc.id
output workspaceId string = ws.id
