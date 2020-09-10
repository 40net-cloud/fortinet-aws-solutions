# Active/Passive High Available FortiGate pair running in 2 Availability Zones


# Introduction

More and more enterprises are turning to AWS to extend internal data centers and take advantage of the elasticity of the public cloud. While AWS secures the access to the infrastructure, you are responsible for protecting everything you put in it. Fortinet Security Fabric provides AWS with the broad protection, native integration and automated management enabling customers with consistent enforcement and visibility across their multi-cloud infrastructure.
The solution adds layer7 security to AWS infrastructure. 

These CloudFormation templates deploy a High Availability pair of FortiGate Next-Generation Firewalls accompanied by the required infrastructure or integrating into it. Additionally, Fortinet Fabric Connectors deliver the ability to create dynamic security policies.

# Design

In AWS, you can deploy an active/passive pair of FortiGate VMs that communicate with each other through the infrastructure. This FortiGate setup will receive the traffic to be inspected using standard routing tables of the attached subnets and from the public IPs. You can send all or specific traffic that needs inspection, going to/coming from on-prem networks or public internet by adapting the local VPC routing.

These AWS CloudFormation templates can automatically deploy a full working environment or can integrate into your existing environment. These two behaviours are explicit in the names of the files (Ex: FGT_AP_HA_XAZ_<behaviour>_BYOL.template): 
- "existingVPC" means the template will prompt you for some parameters to best integrate the solution 
- "newVPC" means the template will create a new infrastructure to run the solution into. 
The templates can deploy devices in PAYG (on demand) or BYOL (you provide the licence) models. You can select the appropriate template using the extension in the names. Ex: FGT_AP_HA_XAZ_newVPC_<extension>.template


The templates will deploy a solution containing the following components.
  - 2 FortiGate firewall's in an active/passive deployment
  - (with newVPC behaviour) 1 VPC with 4 protected subnets (1 private, 1 Public in 2 zones) and 4 subnets required for the FortiGate deployment (ha and management in 2 zones). If using an existing VPC, it must already have 8 subnets
  - 3 public IPs. The first public IP is for cluster access to/through the active FortiGate.  The other two PIPs are for Management access which are also used for API calls.

![active/passive design](images/fgt-ha.png)

# Concept of cloud native HA

FortiOS now supports using FGCP (FortiGate Clustering Protocol) in unicast form to provide an active-passive clustering solution for deployments in AWS. This feature shares a majority of the functionality that FGCP on FortiGate hardware provides with key changes to support AWS SDN (Software Defined Networking).

Unlike the competition, FortiOS is able to select which part of the configuration file to sync between the HA members. In AWS, the subnets located in different zones do not share the same subnet IP ranges and gateways. Therefore the integrated solution must adapt to the zones, synchronizing only some of the objects selected by the administrator. 

This solution works with two FortiGate instances configured as a master and slave pair and that the instances are deployed in different subnets and different availability zones within a single VPC. These FortiGate instances act as a single logical instance and do not share interface IP addressing as they are in different subnets.

The main benefits of this solution are:

  - Fast and stateful failover of FortiOS and AWS SDN without external automation\services
  - Automatic AWS SDN updates to EIPs and route targets
  - Native FortiOS session sync of firewall, IPsec\SSL VPN, and VOIP sessions
  - Native FortiOS configuration sync
  - Ease of use as the cluster is treated as single logical FortiGate

The solution is considered as cloud native because it already embedds all the necessary API calls to adapt automatically the infrastructure to the network and security events. All the API calls are transparent to the user and do not need any manual configuration or intervention from the administrator. 

FGCP HA provides AWS networks with enhanced reliability through device fail-over protection, link fail-over protection, and remote link fail-over protection. In addition, reliability is further enhanced with session fail-over protection for most IPv4 and IPv6 sessions including TCP, UDP, ICMP, IPsec\SSL VPN, and NAT sessions.
A FortiGate FGCP cluster appears as a single logical FortiGate instance and configuration synchronization allows you to configure a cluster in the same way as a standalone FortiGate unit. If a fail-over occurs, the cluster recovers quickly and automatically and can also send notifications to administrator so that the problem that caused the failure can be corrected and any failed resources restored.

For further information on FGCP reference the High Availability chapter in the FortiOS Handbook on the Fortinet Documentation site.

Note: Other Fortinet solutions for AWS such as FGCP HA (Single AZ), AutoScaling, and Transit Gateway are available. Please visit www.fortinet.com/aws for further information.

## How to deploy

The FortiGate solution can be deployed using the AWS console in Services > CloudFormation. Fill up the form before to deploy the solution:

![cloudformation form1](images/form-1.png)
![cloudformation form2](images/form-2.png)
![cloudformation form3](images/form-3.png)
![cloudformation form4](images/form-4.png)



# Requirements and limitations

The ARM template deploy different resource and it is required to have the access rights and quota in your Microsoft Azure subscription to deploy the resources.

- The template will deploy Standard F4s VMs for this architecture. Other VM instances are supported as well with a minimum of 2 NICs. A list can be found [here](https://docs.fortinet.com/document/fortigate/6.2.0/azure-cookbook/562841/instance-type-support)
- Licenses for Fortigate
  - BYOL: A demo license can be made available via your Fortinet partner or on our website. These can be injected during deployment or added after deployment. Purchased licenses need to be registered on the [Fortinet support site] (http://support.fortinet.com). Download the .lic file after registration. Note, these files may not work until 30 minutes after it's initial creation.
  - PAYG or OnDemand: These licenses are automatically generated during the deployment of the FortiGate systems.

## Fabric Connector

The FortiGate-VM uses [Managed Identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/) for the SDN Fabric Connector. A SDN Fabric Connector is created automatically during deployment. After deployment, it is required apply the 'Reader' role to Azure Subscription you want the FortiGate-VM(s) to resolve Azure Resources from. More information can be found on the [Fortinet Documentation Libary](https://docs.fortinet.com/vm/azure/fortigate/6.4/azure-cookbook/6.4.0/236610/creating-a-fabric-connector-using-a-managed-identity).

# FortiGate configuration

The FortiGate VMs need a specific configuration to operate in your environment. This configuration can be injected during provisioning or afterwards via the different management options including GUI, CLI, FortiManager or REST API.

- [Default configuration using this template](doc/config-provisioning.md)
- [Cloud-init](doc/config-cloud-init.md)
- [Inbound connections](doc/config-inbound-connections.md)
- [Outbound connections](doc/config-outbound-connections.md)
  - [NAT considerations: 1-to-1 and 1-to-many](doc/config-outbound-nat-considerations.md)
- East west connections

# Troubleshooting

You can find a troubleshooting guide for this setup [here](doc/troubleshooting.md)

## Support
Fortinet-provided scripts in this and other GitHub projects do not fall under the regular Fortinet technical support scope and are not supported by FortiCare Support Services.
For direct issues, please refer to the [Issues](https://github.com/fortinet/azure-templates/issues) tab of this GitHub project.
For other questions related to this project, contact [github@fortinet.com](mailto:github@fortinet.com).

## License
[License](LICENSE) © Fortinet Technologies. All rights reserved.
