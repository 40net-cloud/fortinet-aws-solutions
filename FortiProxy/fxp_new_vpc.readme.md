# FortiProxy-VM Standalone Deployment on AWS (CloudFormation)

This AWS CloudFormation template automates the deployment of a **Standalone FortiProxy-VM** in a **New Virtual Private Cloud (VPC)**. It sets up necessary networking, security, IAM roles, and FortiProxy configuration using the latest GA AMI for the selected version.

---

## 📦 Features

- Launches FortiProxy in a **dedicated VPC** with public and private subnets
- Configures **public and private routing**
- Supports **BYOL licensing model only**
- Automatically pulls the **latest GA FortiProxy AMI** using a Lambda-backed custom resource
- Enables **CloudWatch Alarm** for instance recovery monitoring
- Provides **remote access** to FortiProxy via EIP

---

## 🛠️ Parameters

### VPC Configuration

| Parameter | Description | Default |
|----------|-------------|---------|
| `VPCCIDR` | CIDR block for the VPC | `10.0.0.0/16` |
| `PublicSubnet` | CIDR for public subnet | `10.0.1.0/24` |
| `PrivateSubnet` | CIDR for private subnet | `10.0.2.0/24` |
| `PublicSubnetRouterIP` | Gateway IP for public subnet | `10.0.1.1` |
| `PrivateSubnetRouterIP` | Gateway IP for private subnet | `10.0.2.1` |

### FortiProxy Configuration

| Parameter | Description | Default |
|----------|-------------|---------|
| `AZForFXP` | Availability Zone to launch FortiProxy | *(User-selected)* |
| `FXPInstanceType` | EC2 Instance type | `c5.xlarge` |
| `FortiProxyVersion` | FortiProxy OS Version | `7.6.x` |
| `LicenseType` | License type (Only BYOL supported) | `BYOL` |
| `CIDRForFXPccess` | CIDR range for remote access | `0.0.0.0/0` |
| `KeyPair` | EC2 KeyPair for SSH access | *(User-selected)* |

### Notifications

| Parameter | Description | Default |
|----------|-------------|---------|
| `EmailNotification` | Email for CloudWatch alarm notifications | `admin@example.com` |

---

## 🔐 Security

- Creates security group allowing:
  - Full access from `CIDRForFXPccess`
  - VPC-wide access
  - Intra-FortiProxy communication
- Enables SSH/HTTPS access on both public/private interfaces

---

## 🚀 Outputs

| Output | Description |
|--------|-------------|
| `FXPURL` | Public URL to access FortiProxy |
| `FXPUsername` | Login username (`admin`) |
| `FXPPassword` | Auto-generated EC2 instance ID used as password |

---

## 🧠 How It Works

1. A Lambda function queries the AWS Marketplace for the latest GA FortiProxy AMI.
2. The template provisions the VPC, subnets, route tables, IGW, EIPs, and security groups.
3. An EC2 instance is launched with the chosen FortiProxy version.
4. CloudWatch monitors the instance and auto-recovers if needed.

---

## 🔔 Requirements

- Valid AWS account
- Proper IAM permissions to launch EC2, Lambda, VPC, and related resources
- BYOL FortiProxy license

---
