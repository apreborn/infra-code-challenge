# Static Website on AWS with Terraform

## Overview

This project demonstrates deploying a simple static website on AWS using Terraform. The website is hosted on an S3 bucket with CloudFront as the CDN to deliver the content globally. The infrastructure is designed to leverage AWS free-tier resources where possible.

## Features
- **Static Website Hosting**: Hosted on an S3 bucket with public access managed via CloudFront.
- **Global Content Delivery**: CloudFront CDN ensures fast content delivery to users worldwide.
- **Infrastructure as Code (IaC)**: All resources are provisioned using Terraform for consistency and reproducibility.

---
## Repository Structure
```bash
├── main.tf # Main configuration file to define resources and provider settings
├── cloudfront_s3.tf # S3 bucket & CloudFront distribution configuration 
├── variables.tf # Variables definition 
├── terraform.tfvars # Variable values for deployment (can be customized for environments) 
├── .gitignore # Git ignore rules for Terraform files 
└── README.md # Project documentation
```

---

## Steps to Deploy the Infrastructure

### 1. **Prerequisites**

Before you begin, ensure you have the following:
- Terraform installed (version >= 1.4.0).
- AWS CLI configured with valid credentials (`aws configure`).

### 2. **Clone the Repository**:
 ```bash 
 git clone https://github.com/apreborn/infra-code-challenge.git
 cd infra-code-challenge
 ```
### 3. **Configure the Terraform Provider**

In the `main.tf` file, we define the provider block, configuring AWS as the cloud provider:

```bash
provider "aws" {
  region = "us-east-1"  # Choose the AWS region that suits your needs
}
```

### 4. **Configure S3 for Static Website Hosting**

The `cloudfront_s3.tf` file contains the configuration for the S3 bucket, enabling static website hosting.

```bash
resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-website-bucket"
  website {
    index_document = "index.html"
    # Error document could also be added, e.g., error.html
  }
}
```

### 5. **Set Up CloudFront Distribution**

The `cloudfront_s3.tf` file sets up the CloudFront distribution to deliver your static content globally. This ensures fast delivery of the website to users.

```bash
resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name = aws_s3_bucket.website_bucket.website_endpoint
    origin_id   = "S3-website"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for static website"
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id = "S3-website"
    viewer_protocol_policy = "redirect-to-https"
  }
}
```

### 6. **Variables and Terraform Configuration**

Variables like the S3 bucket name, CloudFront settings, and more are defined in `variables.tf`, and their values can be customized in `terraform.tfvars`.

```bash
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}
```

### 7. ***Terraform Initialization and Deployment***

To initialize Terraform and deploy the infrastructure:
```bash
terraform init
terraform plan
terraform apply
```

---

## What Could Be Improved with More Time
If I had more time, I would enhance the website in the following ways:

1. **Custom Domain Integration**:
   - Register a custom domain using Route 53 or any other DNS provider.
   - Configure AWS Certificate Manager to add SSL certificates for HTTPS.

2. **Dynamic Content**:
   - Introduce backend functionality by using AWS Lambda for serverless computing.
   - Use Amazon DynamoDB to store and serve dynamic content, such as blog posts or user-generated data.

3. **CI/CD Pipelines**:
   - Implement a continuous integration and continuous delivery (CI/CD) pipeline using GitHub Actions or AWS CodePipeline to automate the deployment of changes to the website.

4. **Enhanced Monitoring**:
   - Use AWS CloudWatch to monitor the health and performance of the S3 bucket and CloudFront distribution.
   - Set up alarms to notify developers if certain metrics exceed thresholds (e.g., 404 errors or latency spikes).

5. **Improved Content Optimization**:
   - Enable gzip or Brotli compression for static assets like HTML, CSS, and JavaScript files.
   - Implement caching strategies to reduce load times and improve SEO performance.

---

## Alternative Solutions Considered

1. **AWS Amplify**:
   - AWS Amplify is a powerful service offering easy hosting for static and dynamic websites. It also provides built-in CI/CD and authentication features.
   - **Why Not Chosen**: While Amplify is excellent for rapid development, I opted for a more hands-on approach with Terraform and AWS services to demonstrate IaC (Infrastructure as Code) principles and AWS-specific configurations.

2. **Elastic Beanstalk or ECS/EKS**:
   - These services provide a scalable platform for deploying web applications but involve more complexity than needed for a static website.
   - **Why Not Chosen**: S3 and CloudFront offer a more straightforward, cost-effective static content solution. They are also easier to manage for this particular use case.

3. **GitHub Pages or Netlify**:
   - These are great options for quickly hosting static websites, but they don’t provide the level of customization and infrastructure control that AWS offers.
   - **Why Not Chosen**: This project was focused on using AWS, and Terraform integration with AWS services allows for more robust, scalable, and production-ready infrastructure.

4. **EC2 Hosting:**:
   - Hosting static content on EC2 would require configuring and maintaining a web server (e.g., Nginx or Apache).
   - **Why Not Chosen**: EC2 instances would add unnecessary complexity and cost for a simple static website.


---

## Making the Website Production-Grade

To take this website from a simple prototype to a production-grade solution, the following changes would be needed:

1. **Infrastructure Enhancements:**:
   - Enable geo-restrictions to control which countries can access the website.
   - Implement multi-region deployment for failover and improved availability.
   - Add AWS WAF to protect against common web attacks such as SQL injection and cross-site scripting (XSS).

2. **Security Measures:**:
   - Enforce HTTPS and redirect HTTP traffic to HTTPS using CloudFront settings.
   - Use IAM roles and policies to restrict access to AWS resources.
   - Enable S3 bucket versioning to protect against accidental deletions or overwrites of content.

3. **Collaboration Across Teams**:
   - Use Terraform modules to structure the code into reusable components.
   - Implement remote state management with an S3 backend and DynamoDB for state locking to allow safe team collaboration.
   - Implement a GitOps workflow for version-controlled deployments.
   - Integrate automated CI/CD pipeline tests to validate infrastructure and application behaviour.

4. **CI/CD Integration**:
   - Set up automated deployment pipelines (e.g., GitHub Actions or AWS CodePipeline) for continuous updates to the website.
   - Implement automated tests for infrastructure and content verification during the pipeline.

5. **Monitoring and Resilience**:
   - Use AWS CloudWatch for metrics and custom dashboards to monitor traffic and resource usage.
   - Set up automated alerts for any issues such as failed deployments or high error rates.
   
---
## Team Collaboration

When working in a collaborative environment, it is essential to implement best practices to ensure smooth workflows and high-quality code. The following are key practices for team collaboration:

### 1. **Version Control and Branching Strategy**

   - Use a feature branch-based workflow, where developers create individual branches for new features, bug fixes, or improvements. Pull requests (PRs) are submitted once changes are ready for review and merging.
  Example:
  ```bash
  git checkout -b feature/custom-domain
  # Work on the feature, commit changes and push them to remote
  git push origin feature/custom-domain
  ```
### 2. **Pull Requests and Code Reviews**

   - All changes go through a PR process to review and ensure code quality and security standards are followed. Code reviews focus on:
     - Proper use of Terraform resources and modules.
     - Consistency with naming conventions.
     - Security best practices and efficiency of the code.

### 3. **Terraform Linting (tflint)**

   - Implement Terraform linting to enforce coding standards and detect common mistakes. Linting should be part of the CI/CD pipeline to catch issues before changes are merged into production.

   Example:
   ```bash
   tflint .
   ```

### 4. **Version Locking and Remote State Management**

   - Lock Terraform and provider versions in the versions.tf file to prevent compatibility issues. Use remote state management with S3 and DynamoDB for collaboration and state consistency.

### 5. **CI/CD Pipeline Integration**

   - Automate the deployment process through a CI/CD pipeline. The pipeline should run `terraform plan` and `terraform apply` upon successful PR merges, ensuring consistent and repeatable deployments.
Example GitHub Actions Pipeline:
```bash
name: Deploy Static Website to AWS

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    # Checkout the repository
    - name: Checkout code
      uses: actions/checkout@v3

    # Set up Terraform
    - name: Set up Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: 1.6.0

    # Initialize Terraform
    - name: Terraform Init
      run: terraform init

    # Plan the deployment
    - name: Terraform Plan
      run: terraform plan -out=tfplan

    # Apply the Terraform plan
    - name: Terraform Apply
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      run: terraform apply -auto-approve tfplan

    # Deploy updated HTML content to S3
    - name: Upload updated HTML to S3
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      run: |
        aws s3 cp index.html s3://your-unique-bucket-name/ --acl public-read --region us-east-1

```
---
## How to Use

1. **Clone the Repository**:
   ```bash 
   git clone https://github.com/apreborn/infra-code-challenge.git
   cd terraform-static-website
   ```
2. **Modify Variables (optional)**: Edit terraform.tfvars to customize the S3 bucket name or other variables.
3. **Deploy the Infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
4. The Static website is accessible via the below Cloudfront distribution endpoint.
   ```bash
   Outputs:
   bucket_arn = "arn:aws:s3:::robin-code-challenge-s3"
   Object URL = "https://robin-code-challenge-s3.s3.us-east-1.amazonaws.com/index.html"
   cloudfront_url = "d35v03glrit7yy.cloudfront.net"
   ```
   Paste the `https://d35v03glrit7yy.cloudfront.net/` into the browser to view the static webpage.
   
