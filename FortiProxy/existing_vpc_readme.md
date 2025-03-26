# FortiProxy-VM Standalone Deployment within Existing VPC (CloudFormation)

This AWS CloudFormation template deploys a **Standalone FortiProxy-VM** within your **existing VPC**, using specified subnets and IPs. The stack provisions the necessary resources, security configuration.

---

## 📦 Features

- Deploys FortiProxy in your **existing VPC and subnets**
- Automatically fetches **latest GA FortiProxy AMI** (BYOL)
- Sets **static private/public IPs** for FortiProxy interfaces
- **Public access via EIP**

---

## 🛠️ Parameters

### VPC Configuration

| Parameter | Description |
|----------|-------------|
| `VPCID` | ID of your existing VPC |
| `VPCCIDR` | CIDR block of the VPC (e.g. `10.0.0.0/16`) |
| `PublicSubnet1` | Subnet ID for public interface |
| `IPAPublicSubnet1` | Static IP address for public interface (e.g. `10.0.1.12/24`) |
| `PublicSubnet1RouterIP` | Gateway IP for public subnet |
| `PrivateSubnet1` | Subnet ID for private interface |
| `IPAPrivateSubnet1` | Static IP address for private interface (e.g. `10.0.2.12/24`) |
| `PrivateSubnet1RouterIP` | Gateway IP for private subnet |

### FortiProxy Configuration

| Parameter | Description | Default |
|----------|-------------|---------|
| `AZForFXPA` | Availability Zone to launch FortiProxy | *(User-selected)* |
| `FXPInstanceType` | EC2 Instance type | `c5.xlarge` |
| `FortiProxyVersion` | FortiProxy OS Version | `7.6.x` |
| `LicenseType` | License type | `BYOL` |
| `CIDRForFXPAccess` | CIDR allowed to access FortiProxy | `0.0.0.0/0` |
| `KeyPair` | EC2 KeyPair for SSH/HTTPS access | *(User-selected)* |

---

## 🔐 Security

- Security group allows:
  - Remote access from `CIDRForFXPAccess`
  - Full VPC access
  - Intra-FortiProxy communication

---

## 🚀 Outputs

| Output | Description |
|--------|-------------|
| `FXPAURL` | Public URL to access FortiProxy |
| `FXPUsername` | Login username (`admin`) |
| `FXPAPassword` | EC2 instance ID used as password |

---

## 🧠 How It Works

1. Uses Lambda to fetch the latest GA FortiProxy AMI from AWS Marketplace.
2. Launches FortiProxy EC2 instance with preconfigured public and private interfaces.
3. Assigns static IPs to the ENIs as provided.
4. Associates EIPs for management/public access.

---

## 🔔 Requirements

- Existing VPC and subnets
- Valid FortiProxy BYOL license
- IAM permissions to create EC2, Lambda, IAM, and related resources

---
