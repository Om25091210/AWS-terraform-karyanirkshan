# Terraform AWS Infrastructure - HAAS VPC

This repository contains Terraform configurations to provision a Highly Available (HA) infrastructure on AWS, including a VPC, load balancers, EC2 instances, RDS from a snapshot, Lambda functions, security groups, and IAM roles. This setup is designed to be robust and scalable, however it is **not a single-click deployment** and requires careful execution of individual steps within each directory.

## Repository Structure

The repository is organized into two main directories:

*   **`Global/`**: Contains resources that are global or require cross-region consistency.
*   **`regional/`**: Contains resources that are specific to the region where they are deployed using zone as **`ap-south-1`** or **`Asia-Mumbai`**.

Within each main directory, resources are grouped into more specific sub-directories:

### `AWS/Global/`

*   **`aws_nat_gateway/`**: Configuration for AWS NAT Gateway for private subnets.
*   **`ec2_security_grp/`**: Security group configuration for EC2 instances.
*   **`jenkins-lb_security_grp/`**: Security group configuration for Jenkins Load Balancer.
*   **`lambda_security_grp/`**: Security group configuration for Lambda functions.
*   **`lb-frontend-sgp/`**: Security group configuration for the Frontend Load Balancer.
*   **`vpc/`**: Configuration for the VPC and its subnets.

### `AWS/regional/`

*   **`aws_ec2/`**: Configuration for EC2 instances.
*   **`aws_lambda/`**: Configuration for Lambda functions.
*   **`aws_rds/`**: Configuration for RDS database instances from snapshot.
*   **`ec2_frontend_lb/`**: Configuration for the Frontend Load Balancer.
*   **`jenkins_iam_user/`**: Configuration for Jenkins IAM user and policies.
*   **`jenkins_lb/`**: Configuration for Jenkins Load Balancer.

## Deployment Instructions

**Important:** This is **NOT** a single-click deployment. You must execute Terraform commands within each relevant subdirectory in the correct order.

### Prerequisites

1.  **AWS Account:** You need an active AWS account with appropriate permissions to create and manage the resources specified in these configurations.
2.  **Terraform:** Ensure Terraform is installed on your system. You can download it from [terraform.io](https://www.terraform.io/downloads.html).
3.  **AWS CLI:**  AWS CLI is installed and configured with the necessary credentials. See [AWS CLI documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) for instructions.
4.  **RDS Snapshot:** You should have an RDS Snapshot available that will be used to restore database in aws_rds/ folder.
5.  **`provider.tf` File:** You need to create a `provider.tf` file in each directory with the following content and replace placeholders with correct values before starting the deployment.
    ```terraform
    provider "aws" {
      region     = "ap-south-1"
      access_key = "YOUR_ACCESS_KEY"
      secret_key = "YOUR_SECRET_KEY"
    }
    
### Step-by-Step Deployment

**Step 1: Deploy Global Resources**

1.  Navigate to the `Global/vpc/` directory:

    ```bash
    cd Global/vpc/
    ```
2.  Initialize Terraform:
    ```bash
    terraform init
    ```
3.  Plan your infrastructure changes:
    ```bash
    terraform plan
    ```
4.  Apply the changes:
    ```bash
    terraform apply
    ```
    **Important**: Review the plan output carefully before applying the changes.
5.  Navigate to the  `AWS/Global/aws_nat_gateway/` directory and follow similar steps to apply changes.
6.  Similarly, repeat steps 1-4 for the following directories:
    *   `Global/ec2_security_grp/`
    *   `Global/jenkins-lb_security_grp/`
    *   `Global/lambda_security_grp/`
    *   `Global/lb-frontend-sgp/`

**Step 2: Deploy Regional Resources**

1.  Navigate to the `regional/aws_rds/` directory:

    ```bash
    cd regional/aws_rds/
    ```
2.  Initialize Terraform:

    ```bash
    terraform init
    ```
3.  Plan your infrastructure changes:

    ```bash
    terraform plan
    ```
    **Important:** Make sure you update `snapshot_identifier` in the main.tf file with the valid snapshot id.
4.  Apply the changes:

    ```bash
    terraform apply
    ```
5.  Similarly, repeat steps 1-4 for the following directories:
    *   `regional/jenkins_iam_user/`
    *   `regional/aws_lambda/`
    *   `regional/aws_ec2/`
    *  `regional/ec2_frontend_lb/`
    *  `regional/jenkins_lb/`

**Important:**
 * Follow above steps carefully and in correct order.
 * Make sure that output of one directory is used as input of other directory. 
 * If your RDS is in some other region, then provide full arn in the `aws_rds/main.tf` file.

### Post-Deployment

After all the Terraform apply commands are successfully executed, the following resources should be available:

*   **VPC**: A custom VPC with public and private subnets.
*   **NAT Gateway**:  A NAT gateway in the public subnet to enable internet access for private subnets.
*   **Security Groups**: Security groups configured for EC2, Load Balancers, Lambda functions, restricting traffic as needed.
*   **EC2 Instances**: EC2 Instances in private subnet
*   **Load Balancers**: Load balancers to distribute traffic to the EC2 instances.
*   **RDS Instance**: An RDS database instance restored from the given snapshot.
*   **Lambda Function**: Deployed Lambda functions with specific IAM roles.
*   **IAM Roles**: Required IAM roles with appropriate permissions for different resources.

### Cleaning up

To destroy the created resources, use the following command from **each** directory:

```bash
terraform destroy
