@description('The location in which all resources should be deployed.')
param location string = resourceGroup().location

@description('The name of the app to create.')
param appName string = uniqueString(resourceGroup().id)

var appServicePlanName = '${appName}${uniqueString(subscription().subscriptionId)}'
var vnetName = '${appName}vnet'
var vnetAddressPrefix = '10.0.0.0/16'
var subnetName = '${appName}sn'
var subnetAddressPrefix = '10.0.0.0/24'
var appServicePlanSku = 'S1'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku
  }
  kind: 'app'
}

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
    ]
  }
}

resource webApp 'Microsoft.Web/sites@2021-01-01' = {
  name: appName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan.id
    virtualNetworkSubnetId: vnet.properties.subnets[0].id
    httpsOnly: true
    siteConfig: {
      vnetRouteAllEnabled: true
      http20Enabled: true
    }
  }
}

// param prefix string


// resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
//   name: 'abcVNet5601'
//   location: resourceGroup().location
//   properties: {
//     addressSpace: {
//       addressPrefixes: [
//         '10.0.0.0/16'
//       ]
//     }
//     subnets: [
//       {
//         name: 'Subnet-1'
//         properties: {
//           addressPrefix: '10.0.0.0/24'
//         }
//       }
//       {
//         name: 'Subnet-2'
//         properties: {
//           addressPrefix: '10.0.1.0/24'
//         }
//       }
//     ]
//   }
// }


// resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
//   name: 'abcapp5601asp2'
//   location: resourceGroup().location
//   sku: {
//     name: 'P1V2'
//     capacity: 1
//   }
//   dependsOn: [
//     virtualNetwork
//   ]
// }

// // resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
// //   name: 'abcapp5601asp2'
// // }

// resource webApplication 'Microsoft.Web/sites@2018-11-01' = {
//   name: 'abcapp5601app2'
//   location: resourceGroup().location
//   tags: {
//     'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
//   }
//   properties: {
//     serverFarmId: appServicePlan.id
//   }
//   dependsOn: [
//     appServicePlan
//   ]
// }

// resource webappVnet 'Microsoft.Web/sites/networkConfig@2020-06-01' = {
//   parent: webApplication
//   name: 'virtualNetwork'
//   properties: {
//     subnetResourceId: virtualNetwork.properties.subnets[0].id
//     swiftSupported: true
//   }


// resource servicesSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-03-01' = {
//   scope: resourceGroup('ExampleGroup3')
//   name: 'MasterAzureCaseIntake1VNet/testonesubnet'
// }

// resource managedId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
//   name: 'id-web-${prefix}'
//   location: resourceGroup().location
// }



// param prefix string
// param location string

// resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
//   scope: resourceGroup('rgp-${prefix}-ops')
//   name: 'ai-${prefix}'
// }

// resource appPlan 'Microsoft.Web/serverfarms@2021-01-15' = {
//   name: 'web-plan-${prefix}'
//   location: location
// }

// resource servicesSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-03-01' existing = {
//   scope: resourceGroup('rgp-${prefix}-network')
//   name: 'vnet-${prefix}-app/WebServices'
// }

// resource managedId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
//   name: 'id-web-${prefix}'
//   location: location  
// }

// resource site 'Microsoft.Web/sites@2021-01-15' = {
//   name: 'web-${prefix}'
//   location: location
//   kind: 'app'
//   identity: {
//     type: 'UserAssigned'
//     userAssignedIdentities: {
//       '${managedId.id}': {}
//     }
//   }
//   properties: {
//     enabled: true
//     hostNameSslStates: [
//       {
//         name: 'web-${prefix}.azurewebsites.net'
//         sslState: 'Disabled'
//         hostType: 'Standard'
//       }
//       {
//         name: 'web-${prefix}.scm.azurewebsites.net'
//         sslState: 'Disabled'
//         hostType: 'Repository'
//       }
//     ]
//     serverFarmId: appPlan.id
//     reserved: false
//     isXenon: false
//     hyperV: false
//     siteConfig: {
//       numberOfWorkers: 1
//       acrUseManagedIdentityCreds: false
//       alwaysOn: true
//       http20Enabled: false
//       functionAppScaleLimit: 0
//       minimumElasticInstanceCount: 1
//     }
//     scmSiteAlsoStopped: false
//     clientAffinityEnabled: false
//     clientCertEnabled: false
//     clientCertMode: 'Required'
//     hostNamesDisabled: false
//     customDomainVerificationId: 'A7BF4C95ECA7B5BBD4A41AF669F8B40A506DDE8A8ED7FD18652CD594DD744B6E'
//     containerSize: 0
//     dailyMemoryTimeQuota: 0
//     httpsOnly: false
//     redundancyMode: 'None'
//     storageAccountRequired: false
//     virtualNetworkSubnetId: servicesSubnet.id
//     keyVaultReferenceIdentity: 'SystemAssigned'
//   }
//   dependsOn: [
//     appPlan
//   ]
// }

// // resource ftpCredPolicy 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2021-02-01' = {
// //   parent: site
// //   name: 'ftp'
// //   tags: commonTags
// //   properties: {
// //     allow: true
// //   }
// // }

// // resource scmCredPolicy 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2021-02-01' = {
// //   parent: site
// //   name: 'scm'
// //   tags: commonTags
// //   properties: {
// //     allow: true
// //   }
// // }

// resource siteWeb 'Microsoft.Web/sites/config@2021-01-15' = {
//   parent: site
//   name: 'web'
//   properties: {
//     numberOfWorkers: 1
//     defaultDocuments: [
//       'Default.htm'
//       'Default.html'
//       'Default.asp'
//       'index.htm'
//       'index.html'
//       'iisstart.htm'
//       'default.aspx'
//       'index.php'
//       'hostingstart.html'
//     ]
//     netFrameworkVersion: 'v5.0'
//     requestTracingEnabled: false
//     remoteDebuggingEnabled: false
//     httpLoggingEnabled: false
//     acrUseManagedIdentityCreds: false
//     logsDirectorySizeLimit: 35
//     detailedErrorLoggingEnabled: false
//     publishingUsername: '$web-${prefix}'
//     scmType: 'VSTSRM'
//     use32BitWorkerProcess: true
//     webSocketsEnabled: false
//     alwaysOn: true
//     managedPipelineMode: 'Integrated'
//     virtualApplications: [
//       {
//         virtualPath: '/'
//         physicalPath: 'site\\wwwroot'
//         preloadEnabled: true
//       }
//     ]
//     loadBalancing: 'LeastRequests'
//     experiments: {
//       rampUpRules: []
//     }
//     autoHealEnabled: false
//     vnetName: '3dbc9a15-0979-4cb6-94bc-29f0090a37c3_Services'
//     vnetRouteAllEnabled: true
//     vnetPrivatePortsCount: 0
//     apiDefinition: {
//       url: 'https://api-${prefix}.azurewebsites.net/swagger/index.html'
//     }
//     localMySqlEnabled: false
//     xManagedServiceIdentityId: 4802
//     ipSecurityRestrictions: [
//       {
//         vnetSubnetResourceId: servicesSubnet.id
//         action: 'Allow'
//         tag: 'Default'
//         priority: 100
//         name: 'vnet'
//       }
//       {
//         ipAddress: 'AzureFrontDoor.Backend'
//         action: 'Allow'
//         tag: 'ServiceTag'
//         priority: 200
//         name: 'frontdoor'
//       }
//       {
//         ipAddress: 'Any'
//         action: 'Deny'
//         priority: 2147483647
//         name: 'Deny all'
//         description: 'Deny all access'
//       }
//     ]
//     scmIpSecurityRestrictions: [
//       // {
//       //   vnetSubnetResourceId: servicesSubnet.id
//       //   action: 'Allow'
//       //   tag: 'Default'
//       //   priority: 100
//       //   name: 'vnet'
//       // }
//       // {
//       //   ipAddress: 'AzureDevOps'
//       //   action: 'Allow'
//       //   tag: 'ServiceTag'
//       //   priority: 200
//       //   name: 'devops'
//       // }
//       {
//         ipAddress: 'Any'
//         action: 'Deny'
//         priority: 2147483647
//         name: 'Deny all'
//         description: 'Deny all access'
//       }
//     ]
//     scmIpSecurityRestrictionsUseMain: true
//     http20Enabled: false
//     minTlsVersion: '1.2'
//     scmMinTlsVersion: '1.0'
//     ftpsState: 'AllAllowed'
//     preWarmedInstanceCount: 0
//     functionAppScaleLimit: 0
//     functionsRuntimeScaleMonitoringEnabled: false
//     minimumElasticInstanceCount: 0
//     azureStorageAccounts: {}
//   }
// }

// resource siteBinding 'Microsoft.Web/sites/hostNameBindings@2021-01-15' = {
//   parent: site
//   name: 'web-${prefix}.azurewebsites.net'
//   properties: {
//     siteName: 'web-${prefix}'
//     hostNameType: 'Verified'
//   }
// }
//}
