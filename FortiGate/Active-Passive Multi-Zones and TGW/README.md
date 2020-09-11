# AWS Transit Gateway flows secured by a pair of Active/Passive Fortigate running High Availability 

## Introduction

When enterprises have their resources spread over the cloud, they often use segmentation as a first step into their journey dedicated to security. In AWS it usually means their network architecture will involve a Transit Gateway (TGW).
This project gives an example of the usage of the recently (November 2018) announced [AWS Transit Gateway](https://aws.amazon.com/transit-gateway/) product. That component provides a way to interconnect multiple VPCs in a hub-spoke topology.

The Transit Gateway is meant to supersede the more complex and expensive Transit VPC technology. This is a didactic example to showcase how a Transit VPC should be configured to achieve a non-trivial (full mesh) scenario.

# Design

In AWS you can create a hub and spoke architecture using a Transit Gateway object, interconnecting some selected VPCs. Fortinet proposes to add one more VPC (called Security VPC) where all the security organs will be located to secure all the traffic flowing through. The TGW is configured to route all the communication flows between VPCs (called east<->west traffic) or between VPCs and outside (called South->North or North->South traffic) to the security organs which will clean them seamlessly.

TGW can be attached to the security VPC using VPNs attachments or standard attachements. As VPN attachments introduce limitations such as [performance limitations] (https://aws.amazon.com/vpn/faqs/?nc1=h_ls) or the usage of Source NAT, Fortinet has put efforts into developping an alternative solution. 

FortiOS now supports using FGCP (FortiGate Clustering Protocol) in unicast form to provide an active-passive clustering solution for deployments in AWS. This feature shares a majority of the functionality that FGCP on FortiGate hardware provides with key changes to support AWS SDN (Software Defined Networking).

Unlike the competition, FortiOS is able to select which part of the configuration file to sync between the HA members. In AWS, the subnets located in different zones do not share the same subnet IP ranges and gateways. Therefore the integrated solution must adapt to the zones, synchronizing only some of the objects selected by the administrator. 

This solution works with two FortiGate instances configured as a master and slave pair and that the instances are deployed in different subnets and different availability zones within a single VPC. These FortiGate instances act as a single logical instance and do not share interface IP addressing as they are in different subnets.

The pair of Fortigate will receive traffic from the TGW via a transit subnet. After cleaning the packets will be conveyed to their destination seanlessly. 

The main benefits of this solution are:

  - Fast and stateful failover of FortiOS and AWS SDN without external automation\services
  - Automatic AWS SDN updates to EIPs and route targets
  - Native FortiOS session sync of firewall, IPsec\SSL VPN, and VOIP sessions
  - Native FortiOS configuration sync
  - Ease of use as the cluster is treated as single logical FortiGate

The solution is considered as cloud native because it already embedds all the necessary API calls to adapt automatically the infrastructure to the network and security events. All the API calls are transparent to the user and do not need any manual configuration or intervention from the administrator. 

![active/passive in TGW design](images/tgw-ha.png)

# How it works

East<->West traffic: When a VPC needs to communicate with another VPC, the packets are initiated from the client to its gateway. The local routing table fo the local VPC subnet will route the packets to the TGW via its attachement (depicted in orange in previous schema). As the subnet is associated to the orange routing table, the destination of the packets is checked against that routing table and the packets are forwarded to the security VPC via the referenced attachement link in red.
As step2, the packets are now forwarded to the security VPC either via zoneA or zoneB attached subnets. Both of them are associated to a local routing table forwarding all packets to the eni0 of the FortiGate master. This is step3.
The cluster is now receiving the packets on its unique data port then process them using all its security filters and modules (AV, IPS, AS, DLP, WAF, ... ). After cleaning, the solution uses its local default gateway to forward the packets to its local subnet gateway (see subnet in green associated to Routing Table 2). This is step4. Finally the routing table of the subnet forwards the packets to the TGW as step5 via the unique attachement between the security VPC and the TGW (depicted in red). 
The TGW has received the packets and checks the destination against the routing table the security VPC is associated to. As step6, the TGW can find the attachement2 as the logical link to reach the destination. 
** note: Return packets stricly follow the same path **

South->North / North->South: The first 4 steps are very similair to east-west traffic. At step5, the local routing table of the subnet can check the destination of the packets is not a VPC but an unknown range of IP (internet, on-remise, remote connection...) and uses its default route to forward the packets. The default route can be associated to an Internet Gateway (for internet), a NAT gateway or any other eni. As step5, the packets will be routed to external.

## How to deploy

The templates will deploy a solution containing the following components.
  - A Transit Gateway with 3 routing tables (associated to the VPC, associated to one management VPC, associated to the security VPC), all attachements and associations with the VPCs.
  - 2 FortiGate firewall's in an active/passive deployment
  - 1 security VPC with 8 subnets (1 relay subnet, 1 data subnet, 1 HA subnet and 1 management subnet x 2 zones) and 6 eni required for the FortiGate deployment (data, ha and management x 2 zones). 
  - 4 public IPs. The first public IP is for cluster access to/through the active FortiGate.  The other two PIPs are for Management access (Management access is used to make API calls to modify the infrastructure) and the last one is to get access to the bastion/mgmt device in VPCMGMT. From that device, you will be able to get access to the other devices located in other VPCs for testing purposes (Ex: to simulate east-west traffic). 


![deployment from template](images/tgw-deployed.png)


The FortiGate solution can be deployed using the AWS console in Services > CloudFormation. Fill up the form before to deploy the solution:

![cloudformation form1](images/form-1.png)
![cloudformation form2](images/form-2.png)
![cloudformation form3](images/form-3.png)
![cloudformation form4](images/form-4.png)










## Requirements
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 0.12.0
* Terraform Provider AWS 2.59.0
* Terraform Provider Template 2.1.2

## Deployment Overview
A Transit Gateway relies on Route Tables. By default, a new Route Table is created in the Transit Gateway, which populates with the routing info toward every VPC attached to the gateway (the full mesh scenario)
The Terraform code in this project demonstrates a more complex scenario in which traffic is isolated based on the environment.

* VPC-1(10.1.0.0/16): in the 'dev' environment - Spoke1 VPC - 2 subnets
* VPC-2(10.2.0.0/16): in the 'dev' environment - Spoke2 VPC - 2 subnets
* VPC-3(10.3.0.0/16): in the 'shared' environment - Mgmt VPC - 2 subnets
* VPC-4(10.0.0.0/16): in the 'prod' environment - Prod VPC - 8 subnets

Let's assume the 'shared' environment will host shared components, such as proxy services, tools, ... Here are the rules we want our Transit Gateway to implement:
* The shared VPC can access dev and prod VPCs.
* The dev VPCs can access each other, and the shared VPC
* The prod VPCs can only access the shared VPC

To enable such a scenario, three Transit Gateway Route Tables are created.  One Route Table per environment.

* RouteTable-1 : associated with all subnets in both Spoke1 and Spoke2 VPC.
- RouteTable-2 : associated with all subnets in Mmgmt VPC.
- RouteTable-3 : associated with relay subnets in Prod PC.

* Spoke1/Spoke2/Mgmt VPC each gets a t2.micro Ubuntu instance to validate the network connectivity over ssh and ICMP (ping).
* The instance in the 'shared' is assigned with a public IP in order to have easy access to the Environment.

![transit-gateway-architecture](./output/transit-gateway.png?raw=true "Transit Gateway Architecture")

## Deployment
* Clone the repository.
* Change ACCESS_KEY and SECRET_KEY values in terraform.tfvars.
* Change parameters in the variables.tf.
* Initialize the providers and modules:
  ```sh
  $ terraform init
  ```
* Submit the Terraform plan:
  ```sh
  $ terraform plan
  ```
* Verify output.
* Confirm and apply the plan:
  ```sh
  $ terraform apply
  ```
* If output is satisfactory, type `yes`.

Output will include the information necessary to log in to the FortiGate-VM instances:
```sh
Outputs:

FGT_Active_MGMT_Public_IP = <Active FGT Management Public IP>
FGT_Cluster_Public_IP = <Cluster Public IP>
FGT_Passive_MGMT_Public_IP = <Passive FGT Management Public IP>
FGT_Password = <FGT Password>
FGT_Username = <FGT admin>
TransitGwy_ID = <Transit Gwy ID>

```

## Destroy the instance
To destroy the instance, use the command:
```sh
$ terraform destroy
```

# Support
Fortinet-provided scripts in this and other GitHub projects do not fall under the regular Fortinet technical support scope and are not supported by FortiCare Support Services.
For direct issues, please refer to the [Issues](https://github.com/fortinet/fortigate-terraform-deploy/issues) tab of this GitHub project.
For other questions related to this project, contact [github@fortinet.com](mailto:github@fortinet.com).

## License
[License](https://github.com/fortinet/fortigate-terraform-deploy/blob/master/LICENSE) © Fortinet Technologies. All rights reserved.
