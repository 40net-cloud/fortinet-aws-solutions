# 🚀 AWS CloudFormation Template - FortiManager Standalone Deployment

This CloudFormation template automates the deployment of a **standalone FortiManager-VM** in a **new AWS VPC**. It provisions all the necessary infrastructure, and retrieves the latest compatible AMI from the AWS Marketplace.

---

## 📦 What’s Deployed

- 🧱 **VPC Infrastructure**
  - New VPC with user-defined CIDR
  - Public Subnet + Internet Gateway + Route Table

- 🧰 **FortiManager EC2 Instance**
  - Configurable instance type
  - Latest AMI selected dynamically via Lambda
  - Optional EBS volume encryption

- 🔒 **Security & Access**
  - Security Groups for public & VPC-wide access
  - Elastic IP for management access
  - SSH key pair support

- ⛑️ **Monitoring**
  - Email notification configuration

---

## 🔧 Parameters

| Parameter | Description |
|----------|-------------|
| `VPCCIDR` | CIDR range for new VPC (default `10.0.0.0/16`) |
| `PublicSubnet` | Subnet range (default `10.0.1.0/24`) |
| `AZForFMG` | Availability Zone to deploy FMG |
| `FortiManagerVersion` | Version of FortiManager (e.g., 7.4.x, 7.6.x) |
| `LicenseType` | Choose BYOL or PAYG for various device limits |
| `FMGInstanceType` | Instance type (default `m5.xlarge`) |
| `EncryptVolumes` | Encrypt EBS volumes (`true`/`false`) |
| `CIDRForFMGccess` | IP range allowed to access FMG |
| `KeyPair` | EC2 KeyPair name for SSH access |
| `EmailNotification` | Email for CloudWatch alarm (optional) |

---

## 📤 Outputs

- 🔗 `FMGURL` – Web GUI URL for FortiManager access
- 👤 `FMGUsername` – Default username (`admin`)
- 🔐 `FMGPassword` – Reference to instance password (manual retrieval)

---

## 📌 Notes

- FortiManager AMI is selected dynamically via Lambda using product code & version mapping.
- This template is intended for test/dev or standalone deployments, not for high-availability clusters.

---
