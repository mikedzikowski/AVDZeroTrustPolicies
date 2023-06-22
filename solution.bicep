targetScope = 'subscription'

param avdGroup string
param time string = utcNow()

@allowed([
  'AzureCloud'
  'AzureUSGovernment'
])
param environment string

var policyName = 'StorageRBACAudit'
var policyDisplayName = 'Audits Storage Account for Storage File Data SMB Share Elevated Contributor RBAC role for an AVD AD groups'
var policyDescription = 'Audits Storage Account for Storage File Data SMB Share Elevated Contributor RBAC role for an AVD AD group'
var subscriptionId = subscription().subscriptionId
var location = deployment().location
var macPolicySet = [
	{
		deploymentName: 'MAC-ZTA'
		libDefinition: json(loadTextContent('policy-definition-es-deploy-zta-initiative-mac.json'))
	}
]

var magPolicySet = [
	{
		deploymentName: 'MAG-ZTA'
		libDefinition: json(loadTextContent('policy-definition-es-deploy-zta-initiative-mag.json'))
	}
]



resource policy 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
	name: policyName
	properties: {
		displayName: policyDisplayName
		policyType: 'Custom'
		mode: 'All'
		description: policyDescription
		metadata: {
			category: 'Zero Trust'
		}
		parameters: {}
		policyRule: {
			if: {
				allOf: [
					{
						field: 'type'
						equals: 'Microsoft.Storage/storageAccounts'
					}
				]
			}
			then: {
				effect: 'AuditIfNotExists'
				details: {
					type: 'Microsoft.Authorization/roleAssignments'
					existenceCondition: {
						allOf: [ {
								field: 'Microsoft.Authorization/roleAssignments/roleDefinitionId'
								equals: '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/a7264617-510b-434b-a828-9731dc254ea7'
							}
							{
								field: 'Microsoft.Authorization/roleAssignments/principalId'
								equals: avdGroup
							}
						]
					}
				}
			}
		}
	}
}

module avdMacZtaPolicySetDefinition './modules/policyset.bicep' = if(environment == 'AzureCloud') {
	scope: subscription(subscriptionId)
	name: (length('PolicySetDefini-${time}') > 64) ? take('AVD-MAC-ZTA-Policy-Set-Definition-${time}', 64) : 'AVD-ZTA-Policy-Set-Definition-${time}'
	params: {
		location: location
		name: macPolicySet[0].deploymentName 
		description: macPolicySet[0].libDefinition.properties.description
		displayName: macPolicySet[0].libDefinition.properties.displayName
		metadata: macPolicySet[0].libDefinition.properties.metadata
		policyDefinitions: macPolicySet[0].libDefinition.properties.policyDefinitions
	}
	dependsOn: [
		policy
	]
}

module avdMagZtaPolicySetDefinition './modules/policyset.bicep' = if(environment == 'AzureUSGovernment') {
	scope: subscription(subscriptionId)
	name: (length('PolicySetDefini-${time}') > 64) ? take('AVD-MAG-ZTA-Policy-Set-Definition-${time}', 64) : 'AVD-ZTA-Policy-Set-Definition-${time}'
	params: {
		location: location
		name: magPolicySet[0].deploymentName
		description: magPolicySet[0].libDefinition.properties.description
		displayName: magPolicySet[0].libDefinition.properties.displayName
		metadata: magPolicySet[0].libDefinition.properties.metadata
		policyDefinitions: magPolicySet[0].libDefinition.properties.policyDefinitions
	}
	dependsOn: [
		policy
	]
}
