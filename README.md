# DevOps Final Project

A Terraform-based infrastructure project for AWS deployment.

## Getting Started

### Prerequisites

- AWS account with valid credentials
- Terraform installed
- SSH access configured

### Configuration

1. **Add AWS Credentials**
   - Navigate to `Infrastructure/main/terraform.tfvars`
   - Insert your AWS credentials

2. **Update Access Details**
   - Update the IP address configuration
   - Add your `KP1.pem` private key content for machine access

## Project Structure

- `Infrastructure/` - Terraform configuration files
  - `main/` - Main Terraform configuration
  - `modules/` - Reusable Terraform modules (EC2, VPC, KeyPair) 