# 🚀 AWS CloudFormation Template - FortiWeb Active/Active Deployment (Existing VPC)

This CloudFormation template automates the deployment of a **FortiWeb-VM Active/Active cluster** across **two Availability Zones** within an **existing AWS VPC**.  
It provisions FortiWeb instances, Network Load Balancer components, and dynamically retrieves the latest compatible AMIs from the AWS Marketplace.

---

## 📦 What’s Deployed

- 🧱 **Networking Integration**
  - Deploys into an existing VPC and existing public/private subnets  
  - Uses provided router IPs for each subnet  
  - Integrates seamlessly with existing routing and gateway configuration  

- ⚙️ **FortiWeb EC2 Instances**
  - Two FortiWeb-VMs (FortiWebA and FortiWebB) deployed across AZ1 and AZ2  
  - Configurable instance type for performance tuning  
  - Dynamically retrieves the latest FortiWeb AMI using a Lambda function  
  - Supports both **BYOL** and **PAYG** licensing models  

- 🌐 **Network Load Balancer (NLB)**
  - Cross-zone load balancing enabled  
  - Two listeners for user-specified ports (e.g., 80 and 443)  
  - Health checks on user-defined port  
  - Targets both FortiWeb instances for Active/Active traffic distribution  

- 🔒 **Security & Access**
  - Security Groups for management and private interfaces  
  - Management interface restricted to user-defined CIDR range  
  - SSH key pair support for administrative access  

- ⚙️ **Automation**
  - Lambda function dynamically discovers the latest FortiWeb AMI  
  - IAM role and policies for Lambda execution and logging  

---

## 🔧 Parameters

| Parameter | Description |
|------------|-------------|
| `VPCID` | ID of the existing VPC for FortiWeb deployment |
| `VPCCIDR` | CIDR range of the existing VPC |
| `PublicSubnet1` | ID of existing public subnet in AZ1 |
| `PublicSubnet1RouterIP` | Router IP address for Public Subnet 1 |
| `PublicSubnet2` | ID of existing public subnet in AZ2 |
| `PublicSubnet2RouterIP` | Router IP address for Public Subnet 2 |
| `PrivateSubnet1` | ID of existing private subnet in AZ1 |
| `PrivateSubnet1RouterIP` | Router IP address for Private Subnet 1 |
| `PrivateSubnet2` | ID of existing private subnet in AZ2 |
| `PrivateSubnet2RouterIP` | Router IP address for Private Subnet 2 |
| `AZ1` | First Availability Zone for FortiWebA |
| `AZ2` | Second Availability Zone for FortiWebB |
| `FWBInstanceType` | EC2 instance type for FortiWeb (default: `c5.xlarge`) |
| `FortiWebVersion` | Desired FortiWeb version (e.g., 7.4.x, 7.6.x, 8.0.x) |
| `LicenseType` | License model (`BYOL` or `PAYG`) |
| `CIDRForFWBAccess` | Source CIDR range allowed for FortiWeb management access |
| `KeyPair` | EC2 KeyPair name for SSH and console access |
| `NlbNamePrefix` | Prefix for naming the Network Load Balancer |
| `ListenerPort1` | First listener port (e.g., 80) |
| `ListenerPort2` | Second listener port (e.g., 443) |
| `TargetProtocol` | Protocol for backend target groups (TCP, TLS, UDP, TCP_UDP) |
| `HealthCheckPort` | Port used for NLB health checks (default: `traffic-port`) |

---

## 📤 Outputs

- 🌐 **`NlbDNS`** – DNS name of the external Network Load Balancer  
- 🔐 **`FwbAId`** – Instance ID of FortiWebA (used as default admin password)  
- 🔐 **`FwbBId`** – Instance ID of FortiWebB (used as default admin password)  

---

## 📌 Notes

- This template **does not create** new networking infrastructure — it uses **existing VPC and subnet resources**.  
- The included Lambda function automatically identifies and selects the **latest FortiWeb AMI** based on version and license type.  
- Cross-zone load balancing ensures high availability and improved performance across both AZs.  
- Each FortiWeb instance operates independently, providing a true **Active/Active architecture** for distributed traffic handling.  
- Ideal for **production environments** requiring scalability and fault tolerance without creating a new VPC.  

---
