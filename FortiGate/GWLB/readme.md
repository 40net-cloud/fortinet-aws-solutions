# Provide advanced L7 security to AWS TGW designs using FortiGate VM and AWS GWLB

## Introduction 

As enterprises expand across the cloud, network segmentation becomes a key early step in building a secure architecture. In AWS, this often involves using a Transit Gateway (TGW) to interconnect multiple VPCs.

Before TGW, many organizations relied on the Transit VPC pattern. This repository provides a concise, didactic example of how a Transit VPC can be configured to support a non-trivial full-mesh scenario, highlighting the routing concepts behind hub-and-spoke designs.

AWS has since introduced the Gateway Load Balancer ![GWLB](https://aws.amazon.com/elasticloadbalancing/gateway-load-balancer/), which simplifies deploying security appliances by distributing stateful traffic across multiple devices, improving performance, routing flexibility, and failover.

### About GWLB

AWS introduced the Gateway Load Balancer (GWLB) to make it easier to deploy and operate network security appliances. GWLB helps you:

 - Deploy third-party virtual appliances more quickly
 - Scale appliances efficiently while controlling costs
 - Improve reliability and availability of virtual appliance fleets

It is made of three major components:

<img src="images/icon-gwlb.png" width="32" height="32"> **Gateway Load Balancer** – Distributes sessions to appliances using the Geneve protocol. It is accessible only from the subnets where it’s deployed, serving the FortiGate appliance pool.

<img src="images/icon-targeteni.png" width="32" height="32"> **Target Group Eni** –  The FortiGate instances or IPs that act as Geneve targets for the GWLB. Each FortiGate establishes a Geneve-encapsulated interface on its associated ENI.

<img src="images/icon-endpoint.png" width="32" height="32"> **Gateway Load Balancer Endpoint (GWLBe)** – A route-table target that sends traffic to the GWLB via PrivateLink. GWLBe is a zonal construct—one endpoint per Availability Zone (with limited exceptions).

GWLB is designed with AWS Availability Zones in mind, preferring to send sessions to targets within the same zone as the traffic source. In large architectures, this can create challenges when sources and destinations span multiple zones.

To maintain symmetry and avoid cross-zone flow issues, a Transit Gateway (TGW) can act as a relay and stateful anchor for east-west traffic. In multi-AZ designs, TGW becomes essential for supporting advanced, stateful security across zones.

## Design

As GWLB was introduced to help seamless integration of third party security components into traditional hub and spokes architectures, Fortinet has put efforts to natively support geneve tunnels to connect to this component.

- All sessions initiated from AWS devices will be routed to TGW running in appliance mode (stateful) before they get forwarded to a GWLB endpoint. This extends privatelink based scenariis. GWLB then creates a session and serves traffic to one Fortigate component for L7 advanced security (IPS, AV, Application control, Web filtering, DLP, WAF...). After cleaning, traffic destined to an AWS VPC returns to GWLB via the same originating geneve tunnel and GWLB originating endpoint. This traffic will be routed back to TGW to reach out to its destination as the next hop. Traffic destined to internet is immediately routed by the Fortigate to the local IGW of the security VPC. 

- Ingress traffic initiated from Internet to a device located in a VPC must enter via its local IGW. Traffic is routed to local GWLB endpoint (located inside the VPC) before reaching out to the GWLB then a Fortigate device for inspection. Traffic is returned back to originating VPC via the endpoint and meets its destination.

The main benefits of this solution are:

  - Fast failover of FortiOS and AWS SDN without external automation\services
  - Enhanced scalability for high performance needs
  - stateful inspection
  - No need for source NATting for E-W communications  

## How it works

### Management of the devices
The Fortigate devices have been configured with 2 virtual domains for internal segmentation. Virtual domains roles are both admin and traffic management. The first virtual domain is called "root" and allows admin to connect and configure the unit via the WebUI. Second vdom called "FG-Traffic" is used to process and clean traffic. 

### East<->West traffic
When a VPC needs to communicate with another VPC, the packets are initiated from the client to its gateway. The local routing table fo the local VPC subnet will route the packets to the TGW via its attachement (depicted in orange as **step1**). As the subnet is associated to the orange routing table, the destination of the packets is checked against that routing table and the packets are forwarded to the security VPC via the referenced attachement link in red.
As **step2**, the packets are now forwarded to the security VPC either via zoneA or zoneB attached subnets. TGW is configured in appliance mode (i.e stateful mode) and will always route packets to the same zone for one established session. Both relay subnets are associated to a local routing table forwarding all packets to the GWLB endpoint interface located in the same local zone. This is **step3**.
The packets entering the endpoint are automatically forwarded to the local GWLB component responsible for establishing a tunnel to the local Fortigate device located in the zone. This is **step4**.
As **step5**, the local Fortigate device is now receiving the packets on its unique geneve tunnel interface and processes them using all its security filters and modules (AV, IPS, AS, DLP, WAF, ... ). If no Fortigate device is available in that zone, GWLB component is configured to forward traffic to another zone where another Fortigate device will be present. After cleaning, the solution uses its local routing table (pointing to all VPC CIDR) to forward the packets back to the tunnel. 
After the packets have reached out to the GWLB interface via the geneve tunnel, they are routed back to the originating endpoint subnet as described by **step6**. 
Endpoint subnet is associated to a routing table whose purpose is to route all traffic to TGW via the VPC attachment. Packets reach out to the TGW (**step7**) via the attachment (depicted in red) then hit the associated red routing table. 
TGW will route the packets to their final destination in the destination VPC as **step8**.

** note: Return packets stricly follow the same path **

![E-W traffic direction](images/EW-direction.png)

### South->North traffic
When a VPC needs to communicate with another VPC, the packets are initiated from the client to its gateway. The local routing table fo the local VPC subnet will route the packets to the TGW via its attachement (depicted in orange as **step1**). As the subnet is associated to the orange routing table, the destination of the packets is checked against that routing table and the packets are forwarded to the security VPC via the referenced attachement link in red.
As **step2**, the packets are now forwarded to the security VPC either via zoneA or zoneB attached subnets. TGW is configured in appliance mode (i.e stateful mode) and will always route packets to the same zone for one established session. Both relay subnets are associated to a local routing table forwarding all packets to the GWLB endpoint interface located in the same local zone. This is **step3**.
The packets entering the endpoint are automatically forwarded to the local GWLB component responsible for establishing a tunnel to the local Fortigate device located in the zone. This is **step4**.
As **step5**, the local Fortigate device is now receiving the packets on its unique geneve tunnel interface and processes them using all its security filters and modules (AV, IPS, AS, DLP, WAF, ... ). If no Fortigate device is available in that zone, GWLB component is configured to forward traffic to another zone where another Fortigate device will be present. After cleaning, the solution uses its local routing table (pointing to the public subnet via port3) to send packet to public subnet's local router. The public subnet is configured with a default route pointing to the local IGW of the security VPC and routes packets to it as **step6**.
**Step7** is the final step as packets reach out to their destination on internet.

** note: Return packets stricly follow the same path ** 

![S-N traffic direction](images/SN-direction.png)

### North->South
Ingress traffic is bit more challenging because GWLB can only initiate a session with a SYN packet entering the endpoint interface. Reverse direction (from target to GWLB interface) is not allowed. Therefore traffic must reach out to the GWLB before packets hit the targets. Bypassing the GWLB and using Fortigate as the destination of the ingress session would add some complexity in routing (especially for return packets). 

The recommended approach to reach a server is to use the local IGW of the VPC it is located in (**step1**). Ingress packets would hit the edge routing database of the VPC (i.e the routing table of the IGW) which forward them to a local GWLB endpoint (**step2**). The endpoint is responsible for sending packets directly to the GWLB as **step3** before they get dispatched to the target group of Fortigates (**step4**). The Fortigate will clean the sessions with advanced filtering and route the traffic back to the GWLB. 
As **step5**, the packets follow a path back to the GWLB endpoint located in the server VPC. The GWLB endpoint is located on a specific subnet whose routing table has a default route to the IGW and a local route to the VPC CIDR. It is responsible for routing the packets to their final destination as **step6**. 
Return traffic is nearly similair: after they are cleaned by the Fortigate device, packets coming back to the endpoint will use the default route instead of the local route installed on the endpoint subnet's local router. This local router located in the server VPC will route the packets to the source, located on internet (**step8 and step9**).

![N-S traffic direction](images/NS-direction.png)

## How to deploy

The templates support both PAYG (On-Demand) and BYOL licensing models.
  - BYOL: Demo licenses can be obtained from your Fortinet partner or the Fortinet website. Licenses can be injected during deployment or added afterward. Purchased licenses must be registered on the Fortinet Support site before downloading the .lic file—note that newly created license files may take up to 30 minutes before becoming active.
  - PAYG: Licenses are automatically generated when the FortiGate instances are deployed.

# Active/Active FortiGate cluster Multi-AZ Deployment witt GWLB & TGW

| **FortiGate Deployment Template** | **CloudFormation Template** | **1-Button Deployment** |
|-----------------|-----------------------------|-------------------------|
| **FortiGate A/A Cluster with GWLB & TGW - Demo setup with VDOMs (New VPC)**<br><br>*Creates a required infrastructure, and deploys a FortiGate Active/Active using VDOMs with GWLB* | <div align="center">[<img src="https://ftnt-cfts.s3.eu-central-1.amazonaws.com/shared/downloadicon.png" alt="CloudFormation Template">](https://ftnt-cfts.s3.amazonaws.com/fgt/fgt_gwlb_newvpc.yaml)</div> | [![Launch Stack](https://github.com/40net-cloud/fortinet-aws-solutions/blob/master/FortiGate/Active-Passive-Multi-Zone/images/aws_cft_image.png)](https://console.aws.amazon.com/cloudformation/home#/stacks/create/review?templateURL=https://ftnt-cfts.s3.amazonaws.com/fgt/fgt_gwlb_newvpc.yaml&stackName=FortiGate-GWLB-Cluster-with-TGW-New-VPC) |
| **FortiGate A/A Cluster with GWLB & TGW - Demo setup without VDOMs (New VPC)**<br><br>*Creates a required infrastructure, and deploys a FortiGate Active/Active without using VDOMs with GWLB* | <div align="center">[<img src="https://ftnt-cfts.s3.eu-central-1.amazonaws.com/shared/downloadicon.png" alt="CloudFormation Template">](https://ftnt-cfts.s3.amazonaws.com/fgt/fgt_gwlb_newvpc_novdoms.yaml)</div> | [![Launch Stack](https://github.com/40net-cloud/fortinet-aws-solutions/blob/master/FortiGate/Active-Passive-Multi-Zone/images/aws_cft_image.png)](https://console.aws.amazon.com/cloudformation/home#/stacks/create/review?templateURL=https://ftnt-cfts.s3.amazonaws.com/fgt/fgt_gwlb_newvpc_novdoms.yaml&stackName=FortiGate-GWLB-Cluster-with-TGW-New-VPC) |

The template deploy the following architecture:
  - A Transit Gateway in appliance mode with two routing tables (one for the VPCs, one for the security VPC), including all required attachments and associations
  - A security VPC with eight subnets across two AZs: (Relay subnet, GWLBe subnet, GWLB ENI subnet, public subnet, two ENIs per FortiGate
  - A Gateway Load Balancer in the security VPC with cross-zone capability enabled
  - Two standalone FortiGate firewalls preconfigured with Geneve tunnels to the GWLB
  - Public IPs assigned to each FortiGate
  - Two spoke VPCs, each hosting a Linux instance for E-W and S-N traffic testing
  
![deployment from template](images/gwlb-deployed.png)


The Fortinet based infrastructure solution can be deployed using the AWS console in Services > CloudFormation. Fill up the form before to deploy the solution:

![cloudformation form1](images/form-1.png)
![cloudformation form2](images/form-2.png)
![cloudformation form3](images/form-3.png)
![cloudformation form4](images/form-4.png)


## Failover process

It is recommended to test failover with TCP/UDP protocols instead of ICMP.

## After deployment

1. You can easily test traffic directions connecting to the linux device using the following commands:
 * ssh -i `<path to your private key>` ec2-user@`<public ip of the linux device>`
 * ping `<private ip of the linux device located in the other VPC>`
 * ping 8.8.8.8 => (test S-N traffic direction)

2. login to one of the two Fortigate unit:
From the AWS console Services > EC2, click on the Fortigate instance and retrieve its public IP and its instance ID. You can now connect to its GUI using the default login "admin" and the default password "instance ID". You will be prompted to change the password.


## Support
Fortinet-provided scripts in this and other GitHub projects do not fall under the regular Fortinet technical support scope and are not supported by FortiCare Support Services.
For direct issues, please refer to the [Issues](https://github.com/fortinet/fortigate-terraform-deploy/issues) tab of this GitHub project.
For other questions related to this project, contact [github@fortinet.com](mailto:github@fortinet.com).

## License
[License](https://github.com/fortinet/fortigate-terraform-deploy/blob/master/LICENSE) © Fortinet Technologies. All rights reserved.
