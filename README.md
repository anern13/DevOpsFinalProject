# DevOps Final Project

A Terraform-based infrastructure project for AWS deployment.

## Getting Started

### CI/CD Secrets
- Set `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and optionally `AWS_SESSION_TOKEN` in GitHub Secrets to enable Terraform plan in CI.
- Set `DOCKERHUB_USERNAME`, `DOCKERHUB_PASSWORD`, and `DOCKERHUB_REPO` (repo variable, defaults to `leads-manager`) to enable Docker image build/push in CI.

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

### Build and Push App Image (local)
- From repo root: `./scripts/build-and-push.sh <dockerhub-username> [tag]`
- Then push: `docker push <dockerhub-username>/leads-manager:<tag>`

## Project Structure

- `Infrastructure/` - Terraform configuration files
  - `main/` - Main Terraform configuration
  - `modules/` - Reusable Terraform modules (EC2, VPC, KeyPair) 
