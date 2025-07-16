# Terraform AWS Infrastructure: Bastion Host, VPC, RDS, Secrets

## 🧱 Overview

This project provisions a secure and modular AWS infrastructure in the **Ireland region (`eu-west-1`)** using Terraform. It sets up:

- A custom **VPC** with public and private subnets  
- An **Internet Gateway** and public route table  
- A **Bastion EC2 instance** in the public subnet with secure SSH access  
- A **PostgreSQL RDS** instance in a private subnet  
- **Remote state management** using S3 and DynamoDB  
- Secure handling of **DB password** and **EC2 SSH private key** using AWS Systems Manager (SSM) Parameter Store

---

## 🗂️ Folder Structure

```

fastapi-terraform-aws-infra/
├── remote-backend-setup.tf  # Remote state backend configuration (S3 + DynamoDB)
├── main.tf                  # Root module composition
├── variables.tf             # Input variables
├── terraform.tfvars         # Optional: override values
├── modules/
│   ├── vpc/                 # VPC, subnets, route tables
│   ├── ec2/                 # Bastion EC2 host and SSH SG
│   ├── rds/                 # PostgreSQL DB
│   ├── ssm/                 # Random DB password via SSM
│   └── ec2-key/             # SSH key pair and private key in SSM

````

---

## 📦 Infrastructure Details

### 🔐 Remote Backend

- Terraform state is stored in **S3** and locked with **DynamoDB** to ensure safe concurrent usage.

### 🌐 Networking (VPC)

- **CIDR**: `10.0.0.0/16`  
- **Subnets**:
  - `10.0.1.0/24` (public)
  - `10.0.2.0/24` (private)
- **Internet Gateway** attached to the VPC  
- **Public Route Table** associated with the public subnet

### 🧳 EC2 Bastion Host

- Deployed in the public subnet  
- Key pair is generated using `tls_private_key`  
- Private key stored securely in **SSM Parameter Store**  
- Public IP is assigned for SSH access

### 🗄️ PostgreSQL RDS Instance

- Deployed in a private subnet  
- **db_name**: `moosasharieff`  
- **Password**: Auto-generated and stored securely in SSM  
- **Not publicly accessible**

### 🔐 Secrets Management

- RDS DB Password and SSH private key are stored using **AWS SSM Parameter Store** with `SecureString` type.  
- These values are fetched during provisioning using `data "aws_ssm_parameter"` blocks.

---

## 🚀 Usage

### 1. Create S3 Bucket & DynamoDB Table for Backend

```bash
aws s3api create-bucket --bucket my-tf-state-backend-mms --region eu-west-1

aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region eu-west-1
````

### 2. Run Terraform

```bash
terraform init
terraform plan
terraform apply
```

### 3. SSH Into Bastion Host

```bash
# Fetch key securely from SSM
aws ssm get-parameter \
  --name "/fastapi-terraform-aws-stack/ec2/private-key" \
  --with-decryption \
  --query "Parameter.Value" \
  --output text > ec2_key.pem

chmod 400 ec2_key.pem

# Get Public IP
terraform output ec2_public_ip

# SSH into Bastion Host
ssh -i ec2_key.pem ubuntu@<bastion-public-ip>
```

---

## 🌍 Architecture Diagram

```
               ┌────────────────────────────┐
               │      AWS VPC (10.0.0.0/16) │
               └────────────────────────────┘
                          │
             ┌────────────┴────────────┐
             │                         │
 ┌─────────────────────┐     ┌──────────────────────┐
 │ Public Subnet        │     │  Private Subnet       │
 │ (10.0.1.0/24)        │     │  (10.0.2.0/24)         │
 │                      │     │                      │
 │  Bastion Host (EC2)  │     │  PostgreSQL RDS       │
 └─────────────────────┘     └──────────────────────┘
```

---

## 📌 Future Plan: Deploy FastAPI on This Infrastructure

Deploy a **FastAPI service** securely using this architecture:

* 🧰 Host your FastAPI app on a private EC2 instance or ECS Fargate
* 🔄 Use Nginx as a reverse proxy on the Bastion Host (or ALB in future)
* 🔐 Connect to the database using the private RDS hostname
* 📦 Use CI/CD (e.g., GitHub Actions + Terraform + Ansible) to automate deployment

---

## 🧑‍💻 Author

**Mohammed Moosa Sharieff**
Infrastructure Automation | Backend Engineering | Software Development
📍 Letterkenny, Co. Donegal, Ireland
📬 [moosa.sharieff09@gmail.com](mailto:moosa.sharieff09@gmail.com)