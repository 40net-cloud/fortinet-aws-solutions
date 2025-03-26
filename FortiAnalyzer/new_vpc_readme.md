# 🚀 AWS CloudFormation Template - FortiAnalyzer Standalone Deployment

This CloudFormation template automates the deployment of a **standalone FortiAnalyzer-VM** in a **new AWS VPC**. It provisions all the necessary infrastructure, applies initial configuration, and retrieves the latest compatible AMI from the AWS Marketplace.

---

## 📦 What’s Deployed

- 🧱 **VPC Infrastructure**
  - New VPC with user-defined CIDR
  - Public Subnet + Internet Gateway + Route Table

- 🧰 **FortiAnalyzer EC2 Instance**
  - Configurable instance type
  - Latest AMI selected dynamically via Lambda
  - Optional EBS volume encryption
  - Custom UserData script for network/bootstrap config

- 🔒 **Security & Access**
  - Security Groups for public & VPC-wide access
  - Elastic IP for management access
  - SSH key pair support

- ⛑️ **Monitoring & Recovery**
  - CloudWatch alarm for system recovery on failure
  - Email notification configuration (future-proofed)

---

## 🔧 Parameters

| Parameter | Description |
|----------|-------------|
| `VPCCIDR` | CIDR range for new VPC (default `10.0.0.0/16`) |
| `PublicSubnet` | Subnet range (default `10.0.1.0/24`) |
| `AZForFAZ` | Availability Zone to deploy FAZ |
| `FortiAnalyzerVersion` | Version of FortiAnalyzer (e.g., 7.4.x, 7.6.x) |
| `LicenseType` | Choose BYOL or PAYG for various device limits |
| `FAZInstanceType` | Instance type (default `m5.xlarge`) |
| `EncryptVolumes` | Encrypt EBS volumes (`true`/`false`) |
| `CIDRForFAZccess` | IP range allowed to access FAZ |
| `KeyPair` | EC2 KeyPair name for SSH access |
| `EmailNotification` | Email for CloudWatch alarm (optional) |

---

## 📤 Outputs

- 🔗 `FAZURL` – Web GUI URL for FortiAnalyzer access
- 👤 `FAZUsername` – Default username (`admin`)
- 🔐 `FAZPassword` – Reference to instance password (manual retrieval)

---

## 📌 Notes

- FortiAnalyzer AMI is selected dynamically via Lambda using product code & version mapping.
- Default bootstrap config sets hostname, interface, and basic firewall/NAT rules.
- This template is intended for test/dev or standalone deployments, not for high-availability clusters.

---

## 📎 License

MIT (or align with your repo/project license)

---

## 👨‍💻 Maintainer

For questions or issues, please open an issue or reach out to [admin@example.com](mailto:admin@example.com).
