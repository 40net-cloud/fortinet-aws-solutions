# 🛡️ FortiWeb (Standalone) Deployment in a New VPC on AWS

This AWS CloudFormation template (`fwb_standalone_newvpc.yaml`) deploys a **FortiWeb (FWB) standalone instance** into a **new Virtual Private Cloud (VPC)** environment. It provisions all the necessary AWS infrastructure including networking, security, and FortiWeb configuration resources.

---

## 🗺️ Deployment Overview

This template launches the following in your AWS environment:

- A new **VPC** with public and private subnets across multiple Availability Zones
- **FortiWeb EC2 instance** in a public subnet
- Required **security groups**, **IAM roles**, **Elastic IP addresses**
- Route tables, Internet Gateway, NAT Gateway, and necessary networking components
- Parameters for custom configurations such as license type, instance size, admin credentials, etc.

---

## ⚙️ Template Parameters

The following parameters can be customized at deployment:

| Parameter | Description | Default |
|----------|-------------|---------|
| `VpcCidr` | CIDR block for the new VPC | `10.0.0.0/16` |
| `PublicSubnet1Cidr` | CIDR block for public subnet in AZ1 | `10.0.1.0/24` |
| `PrivateSubnet1Cidr` | CIDR block for private subnet in AZ1 | `10.0.2.0/24` |
| `AvailabilityZone1` | AWS Availability Zone for deployment | `us-east-1a` |
| `InstanceType` | EC2 instance type for FortiWeb | `c5.large` |
| `FWBUsername` | Admin username for FortiWeb | `admin` |
| `FWBPassword` | Admin password for FortiWeb | *(No default)* |
| `LicenseType` | Choose BYOL or PAYG license model | `BYOL` |
| `KeyPairName` | Name of the EC2 KeyPair to SSH into instance | *(Required)* |

> 🔒 **Note**: You must provide your own key pair and password at deployment. Password must meet FortiWeb complexity requirements.

---

## 🚀 Deployment Instructions

### 🖥️ Option 1: Deploy via AWS Console

1. Go to the AWS CloudFormation console.
2. Choose **"Create stack with new resources (standard)"**.
3. Upload the `fwb_standalone_newvpc.yaml` file.
4. Fill in the parameter values as needed.
5. Acknowledge required capabilities (IAM roles).
6. Launch the stack.

### 💻 Option 2: Deploy via AWS CLI

```bash
aws cloudformation create-stack \
  --stack-name FortiWeb-Standalone \
  --template-body file://fwb_standalone_newvpc.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters ParameterKey=KeyPairName,ParameterValue=MyKeyPair \
               ParameterKey=FWBPassword,ParameterValue='MySecurePassword123!'
