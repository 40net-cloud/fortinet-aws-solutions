# 🚀 AWS CloudFormation Template - FortiAnalyzer Standalone Deployment (Existing VPC)

This CloudFormation template launches a **standalone FortiAnalyzer-VM** into an **existing AWS VPC and public subnet**. It automates the setup of the instance, supporting different licensing models and dynamically pulling the latest compatible AMI from the AWS Marketplace.

---

## 📦 What’s Deployed

- 🧰 **FortiAnalyzer EC2 Instance**
  - Dynamically selects latest compatible AMI via Lambda
  - Supports multiple licensing options (BYOL, PAYG)
  - Configurable instance type and EBS volume encryption

- 🔒 **Security & Access**
  - Security Groups allow configurable CIDR-based access
  - Network Interface created in user-specified subnet
  - Elastic IPs for public management access

- ⛑️ **Monitoring & Recovery**
  - CloudWatch alarm
  - IAM role for instance and Lambda access
  - Email contact placeholder for alarm notifications

---

## 🔧 Parameters

| Parameter | Description |
|----------|-------------|
| `ExistingVPCID` | The ID of an existing VPC |
| `ExistingSubnetID` | The ID of an existing public subnet |
| `ExistingSubnetCIDR` | CIDR of that subnet (e.g. 10.0.1.0/24) |
| `VPCCIDR` | CIDR range for the full VPC |
| `AZForFAZ` | AZ to deploy FortiAnalyzer in |
| `FortiAnalyzerVersion` | Version (7.0.x–7.6.x) |
| `LicenseType` | License type (BYOL or PAYG tiers) |
| `FAZInstanceType` | EC2 instance type (default: `m5.xlarge`) |
| `EncryptVolumes` | Encrypt EBS volumes (true/false) |
| `CIDRForFAZccess` | Source IP range allowed to access the instance |
| `KeyPair` | EC2 KeyPair for SSH access |
| `PublicSubnetRouterIP` | Gateway IP in the subnet |
| `EmailNotification` | Email to receive CloudWatch alarm (optional) |

---

## 📤 Outputs

- 🔗 `FAZURL` – Public URL for web access
- 👤 `FAZUsername` – Default user (`admin`)
- 🔐 `FAZPassword` – Reference to instance ID as password (default login)

---

## 📌 Notes

- Uses a Lambda function to find the latest compatible FortiAnalyzer AMI from AWS Marketplace.
- This template assumes networking resources already exist and focuses solely on deploying and configuring FortiAnalyzer securely.

---
