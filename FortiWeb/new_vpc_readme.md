# 🚀 AWS CloudFormation Template - FortiWeb Standalone Deployment

This CloudFormation template automates the deployment of a **standalone FortiWeb-VM** in a **new AWS VPC**. It provisions all the necessary infrastructure, and retrieves the latest compatible AMI from the AWS Marketplace.

---

## 📦 What’s Deployed

- 🧱 **VPC Infrastructure**
  - New VPC with user-defined CIDR
  - Public and Private Subnets with router IPs
  - Internet Gateway + Route Tables

- 🧰 **FortiWeb EC2 Instance**
  - Configurable instance type
  - Latest AMI selected dynamically via Lambda
  - Deployed in user-selected Availability Zone

- 🔒 **Security & Access**
  - Security Groups for management and data access
  - Elastic IP for management interface
  - SSH key pair support for administrative access

- ⛑️ **Monitoring**
  - Email notification configuration for CloudWatch alarms

---

## 🔧 Parameters

| Parameter | Description |
|------------|-------------|
| `VPCCIDR` | CIDR range for new VPC (default `10.0.0.0/16`) |
| `PublicSubnet` | Public subnet range (default `10.0.1.0/24`) |
| `PublicSubnetRouterIP` | Gateway IP for public subnet (default `10.0.1.1`) |
| `PrivateSubnet` | Private subnet range (default `10.0.2.0/24`) |
| `PrivateSubnetRouterIP` | Gateway IP for private subnet (default `10.0.2.1`) |
| `AZForFWB` | Availability Zone to deploy FortiWeb |
| `FortiWebVersion` | Version of FortiWeb (e.g., 7.4.x, 7.6.x) |
| `LicenseType` | Choose BYOL or PAYG for appropriate license model |
| `FWBInstanceType` | Instance type for FortiWeb (default `c5.xlarge`) |
| `CIDRForFWBccess` | IP range allowed to access FortiWeb |
| `KeyPair` | EC2 KeyPair name for SSH access |
| `EmailNotification` | Email for CloudWatch alarm (optional) |

---

## 📤 Outputs

- 🔗 `FWBURL` – Web GUI URL for FortiWeb access  
- 👤 `FWBUsername` – Default username (`admin`)  
- 🔐 `FWBPassword` – Reference to instance password (manual retrieval)  

---

## 📌 Notes

- FortiWeb AMI is selected dynamically via Lambda using product code & version mapping.  
- This template is intended for test/dev or standalone deployments, not for high-availability clusters.  
