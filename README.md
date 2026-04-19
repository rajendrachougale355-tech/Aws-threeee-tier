# Eks-Project
markdown
# Scalable Three-Tier AWS Architecture with Terraform

## 📌 Overview
This project provisions a **Three-Tier Architecture** on AWS using **Terraform** with a remote backend (S3 + DynamoDB).  
The architecture consists of:
- **Web Layer** → Nginx on EC2, behind an Application Load Balancer (ALB).
- **App Layer** → Apache Tomcat on EC2, private subnet.
- **Database Layer** → Amazon RDS (MySQL), private subnet.

State management is centralized using **S3 (state file storage)** and **DynamoDB (state locking)**.

---

## 🏗️ Architecture Diagram
Internet → ALB → Web EC2 (Nginx) → App EC2 (Tomcat) → RDS (MySQL)

Code

- Public Subnet → ALB + Web servers
- Private Subnet → App servers
- Private DB Subnet → RDS
- S3 → Stores Terraform state
- DynamoDB → Manages state locks

---

## ⚙️ Features
- Modular Terraform code (`modules/vpc`, `modules/ec2`, `modules/rds`, `modules/alb`)
- Remote backend with **S3 + DynamoDB**
- Secure networking (VPC, subnets, route tables, NAT Gateway)
- IAM roles and Security Groups for least privilege
- Automated EC2 bootstrapping with `user_data`
- RDS with Multi-AZ, private access, and Secrets Manager integration
- Cost optimization with right-sizing and monitoring

---

## 📂 Project Structure
aws-three-tier/
├── backend.tf          # Remote backend config (S3 + DynamoDB)
├── main.tf             # Root module calls
├── variables.tf        # Input variables
├── outputs.tf          # Outputs
└── modules/
├── vpc/            # VPC, subnets, IGW, NAT, route tables
├── ec2/            # Web + App EC2 instances
├── rds/            # MySQL RDS setup
└── alb/            # Application Load Balancer

Code

---

## 🔑 Backend Configuration
`backend.tf`:
```hcl
terraform {
  backend "s3" {
    bucket         = "rajendra-terraform-state-bucket"
    key            = "three-tier/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
🚀 Usage
1. Initialize Backend
bash
terraform init
2. Plan Infrastructure
bash
terraform plan
3. Apply Infrastructure
bash
terraform apply
4. Destroy Infrastructure
bash
terraform destroy
🔍 Verification
S3 Bucket → Check terraform.tfstate file.

DynamoDB Table → Verify lock entries during apply.

AWS Console → Confirm VPC, EC2, ALB, and RDS resources.

Browser → Access ALB DNS → Nginx welcome page.

App EC2 → Connect to RDS via MySQL client:

bash
mysql -h <RDS-endpoint> -u admin -p
📖 Learnings
Centralized state management with S3 + DynamoDB.

Secure three-tier architecture design.

Modular Terraform code for reusability.

Automated provisioning and configuration.

👨‍💻 Author
Rajendra Chougale  
System | Cloud | DevOps Engineer
LinkedIn (linkedin.com in Bing) | GitHub
