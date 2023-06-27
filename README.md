# AVDZeroTrustPolicies
Azure Virtual Desktop and Zero Trust

Example

![image](https://github.com/mikedzikowski/AVDZeroTrustPolicies/assets/34066455/d1417168-999c-4c21-aed6-e1287fd5b4b6)

Policies Currently Included

Azure Virtual Desktop service should use private link

Storage accounts should disable public network access

Storage accounts should use customer-managed key for encryption

Storage accounts should restrict network access

Audits Storage Account for Storage File Data SMB Share Elevated Contributor RBAC role for an AVD AD groups

Storage accounts should have infrastructure encryption

Storage accounts should use private link

Azure Virtual Desktop hostpools should disable public network access only on session hosts

Azure Virtual Desktop hostpools should disable public network access

Azure Virtual Desktop workspaces should disable public network access

System updates should be installed on your machines

Management ports of virtual machines should be protected with just-in-time network access control

[Preview]: All Internet traffic should be routed via your deployed Azure Firewall

[Preview]: Guest Attestation extension should be installed on supported Windows virtual machines

Accounts with owner permissions on Azure resources should be MFA enabled

[Preview]: vTPM should be enabled on supported virtual machines

[Preview]: Secure Boot should be enabled on supported Windows virtual machines

Accounts with read permissions on Azure resources should be MFA enabled
Accounts with write permissions on Azure resources should be MFA enabled
Azure Defender for servers should be enabled
Microsoft Defender for Storage (Classic) should be enabled

