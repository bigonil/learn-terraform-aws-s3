# Terraform S3 Static Website

This Terraform script creates an AWS S3 bucket configured to host a static website. The S3 bucket can be used to serve static content such as HTML, CSS, JavaScript, and other assets directly from AWS.

## Features

- Creates an S3 bucket with website hosting enabled.
- Configures the S3 bucket for public access (optional).
- Defines index and error documents for the website.
- Outputs the S3 website endpoint.

## Architecture

Below is a high-level architecture diagram showing the static website hosted in an S3 bucket:

![S3 Static Website Architecture](./images/s3-static-website-diagram.png)

## Prerequisites

Before you begin, ensure you have the following:

- [Terraform](https://www.terraform.io/downloads.html) installed on your machine.
- AWS credentials configured on your machine, either through environment variables or the AWS CLI.
- Necessary permissions to create an S3 bucket in your AWS account.

## Usage

1. **Clone the repository**:

   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Initialize the Terraform configuration**:

   ```bash
   terraform init
   ```

3. **Apply the Terraform configuration**:

   Run the following command to provision the S3 bucket. You will be prompted to confirm before applying the changes.

   ```bash
   terraform apply
   ```

4. **View the S3 Website URL**:

   After successful execution, Terraform will output the S3 bucket website endpoint. Use this URL to access your static website:

   ```bash
   Outputs:
   website_endpoint = http://your-bucket-name.s3-website-region.amazonaws.com
   ```

## Variables

You can customize the script by modifying the following variables in the `variables.tf` file:

- `bucket_name`: The name of the S3 bucket to create.
- `region`: AWS region where the bucket will be created.
- `index_document`: The name of the index document (e.g., `index.html`).
- `error_document`: The name of the error document (e.g., `error.html`).

## Example

Here is an example of how to set up the variables:

```hcl
variable "bucket_name" {
  description = "The name of the S3 bucket"
  default     = "my-static-website-bucket"
}

variable "region" {
  description = "The AWS region"
  default     = "us-east-1"
}

variable "index_document" {
  description = "The index document"
  default     = "index.html"
}

variable "error_document" {
  description = "The error document"
  default     = "error.html"
}
```

## Outputs

The following output will be generated:

- `website_endpoint`: The URL of the S3 static website.

## Cleanup

To delete the resources created by this Terraform configuration, run:

```bash
terraform destroy
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
