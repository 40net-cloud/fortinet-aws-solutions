# 🚀 AWS CloudFormation Template - FortiWeb Active/Active Deployment (New VPC)

This CloudFormation template automates the deployment of a **FortiWeb-VM Active/Active cluster** across **two Availability Zones** in a **new AWS VPC**. It provisions all required infrastructure components, Network Load Balancer configuration, and dynamically retrieves the latest compatible AMIs from the AWS Marketplace.

---

## 📦 What’s Deployed

- 🧱 **VPC Infrastructure**
  - New VPC with user-defined CIDR
  - Public and Private Subnets across **two Availability Zones**
  - Router IPs for each subnet
  - Internet Gateway and appropriate Route Tables

- ⚙️ **FortiWeb EC2 Instances**
  - Two FortiWeb-VMs (FortiWebA and FortiWebB) deployed across AZ1 and AZ2
  - Configurable instance type
  - Latest AMIs selected dynamically via Lambda
  - License type selectable (BYOL or PAYG)

- 🌐 **Network Load Balancer (NLB)**
  - Cross-zone load balancing enabled
  - Two listeners (configurable ports)
  - Health checks on user-defined port
  - Targets both FortiWeb instances for Active/Active traffic distribution

- 🔒 **Security & Access**
  - Security Groups for management and data access
  - Elastic IPs assigned to management interfaces
  - SSH key pair support for administrative access
  - User-defined CIDR range for management access control

- ⛑️ **Monitoring**
  - Optional email notifications for CloudWatch alarms

---

## 🔧 Parameters

| Parameter | Description |
|------------|-------------|
| `VPCCIDR` | CIDR range for new VPC (default `10.0.0.0/16`) |
| `PublicSubnet1` | Public subnet in AZ1 (default `10.0.1.0/24`) |
| `PublicSubnet1RouterIP` | Gateway IP for PublicSubnet1 (default `10.0.1.1`) |
| `PublicSubnet2` | Public subnet in AZ2 (default `10.0.2.0/24`) |
| `PublicSubnet2RouterIP` | Gateway IP for PublicSubnet2 (default `10.0.2.1`) |
| `PrivateSubnet1` | Private subnet in AZ1 (default `10.0.10.0/24`) |
| `PrivateSubnet1RouterIP` | Gateway IP for PrivateSubnet1 (default `10.0.10.1`) |
| `PrivateSubnet2` | Private subnet in AZ2 (default `10.0.20.0/24`) |
| `PrivateSubnet2RouterIP` | Gateway IP for PrivateSubnet2 (default `10.0.20.1`) |
| `AZ1` | First Availability Zone for FortiWebA |
| `AZ2` | Second Availability Zone for FortiWebB |
| `FortiWebVersion` | Version of FortiWeb (e.g., 7.4.x, 7.6.x) |
| `LicenseType` | Choose BYOL or PAYG for appropriate license model |
| `FWBInstanceType` | Instance type for FortiWeb (default `c5.xlarge`) |
| `CIDRForFWBAccess` | IP range allowed to access FortiWeb management interface |
| `KeyPair` | EC2 KeyPair name for SSH access |
| `NlbNamePrefix` | Prefix name for Network Load Balancer |
| `ListenerPort1` | First listener port (e.g., 80) |
| `ListenerPort2` | Second listener port (e.g., 443) |
| `TargetProtocol` | Protocol for backend target group (e.g., TCP) |
| `HealthCheckPort` | Port used for NLB health checks |
| `EmailNotification` | Email address for CloudWatch alarm notifications (optional) |

---

## 📤 Outputs

- 🌐 `NLBEndpoint` – DNS name of the Network Load Balancer  
- 🔗 `FWBAManagementURL` – Web GUI URL for FortiWebA  
- 🔗 `FWBBManagementURL` – Web GUI URL for FortiWebB  
- 👤 `FWBUsername` – Default username (`admin`)  
- 🔐 `FWBPassword` – Reference to instance password (manual retrieval)  

---

## 📌 Notes

- FortiWeb AMIs are selected dynamically via a Lambda function using product code and version mapping.  
- This template provides an **Active/Active** architecture with NLB cross-zone load balancing for improved performance and redundancy.  
- Ideal for **production** or **redundant** deployments where traffic must be distributed across multiple Availability Zones.  
- Each FortiWeb-VM instance operates independently, handling inbound traffic from the NLB.  

---

