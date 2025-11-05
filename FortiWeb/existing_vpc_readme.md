# 🚀 AWS CloudFormation Template - FortiWeb Standalone Deployment (Existing VPC)

This CloudFormation template launches a **standalone FortiWeb-VM** into an **existing AWS VPC and subnet environment**. It automates the provisioning, configuration, and public access of the FortiWeb instance, supporting multiple licensing options and automatically fetching the latest compatible AMI from the AWS Marketplace.

---

## 📦 What’s Deployed

- 🧰 **FortiWeb EC2 Instance**
  - Dynamically selects the latest FortiWeb AMI using an AWS Lambda function  
  - Supports **BYOL** and **PAYG** licensing models  
  - Customizable EC2 instance type for performance and cost optimization  
  - Automatic Elastic IP association for management access  

- 🔒 **Security & Access**
  - Security Groups restrict inbound traffic based on user-specified CIDR  
  - Dual network interfaces for management and traffic separation  
  - Deploys into existing VPC and subnet architecture  

- ⚙️ **Automation & Roles**
  - Lambda function to fetch latest FortiWeb AMI  
  - IAM roles and instance profiles for Lambda and EC2 permissions  
  - Optional EIP allocation and association for public access  

- ⛑️ **Monitoring & Recovery**
  - IAM Role-based access control  
  - Easy redeployment using existing networking setup  
  - Template designed for fault isolation within a single AZ  

---

## 🔧 Parameters

| Parameter | Description |
|------------|--------------|
| `VPCID` | ID of the existing VPC where FortiWeb will be deployed |
| `VPCCIDR` | CIDR range for the VPC (e.g., `10.0.0.0/16`) |
| `AZForFWBA` | Availability Zone for FortiWeb deployment |
| `PublicSubnet1` | ID of the existing public subnet |
| `IPAPublicSubnet1` | Primary private IP address for the FortiWeb interface in public subnet |
| `PublicSubnet1RouterIP` | Default gateway IP in the public subnet |
| `PrivateSubnet1` | ID of the existing private subnet |
| `IPAPrivateSubnet1` | Primary private IP address for the FortiWeb interface in private subnet |
| `PrivateSubnet1RouterIP` | Default gateway IP in the private subnet |
| `FXPInstanceType` | EC2 instance type (default: `m5.xlarge`) |
| `FortiWebVersion` | Desired FortiWeb software version (e.g., 7.0.x–7.6.x) |
| `LicenseType` | License model (`BYOL` or `PAYG` tiers) |
| `CIDRForFWBAccess` | Source IP range allowed to access FortiWeb management interface |
| `KeyPair` | EC2 KeyPair name for SSH access |

---

## 📤 Outputs

- 🔗 **`FWBAURL`** – Public management URL for FortiWeb  
- 👤 **`FXPUsername`** – Default login username (`admin`)  
- 🔐 **`FWBAPassword`** – Default password (Instance ID–based login credential)  

---

## 📌 Notes

- This template assumes **networking resources already exist** (VPC, subnets, routing).  
- Automatically retrieves the **latest compatible FortiWeb AMI** from AWS Marketplace.  
- Designed for **standalone** FortiWeb deployments (no clustering or HA pairs).  
- Public subnet interface is assigned an **Elastic IP** for direct management access.  
- Supports **BYOL** and **PAYG** deployment modes seamlessly.  
