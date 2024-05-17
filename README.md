# Fancy Mailing List 📧✨

This is  **Fancy Mailing List**! This project leverages Terraform with the AWS provider to create an efficient mailing list system using AWS Lambda, S3 Bucket, and SES (Simple Email Service). Below, you'll find a detailed overview of the project components and setup instructions.

## Table of Contents
- [Overview](#overview)
- [Modules](#modules)
  - [AWS S3 Bucket](#aws-s3-bucket)
  - [PresignedURL Lambda](#presignedurl-lambda)
  - [S3 Lambda Listener](#s3-lambda-listener)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Overview
**Fancy Mailing List** is a Terraform-based project designed to streamline the sending of emails to mailing list addresses with just one api call. By leveraging AWS services such as Lambda, S3 Bucket and SES, the project provides efficient support for sending and processing large files. The project consists of three main modules:

1. **AWS S3 Bucket**: Configures an S3 Bucket to store mailing list files.
2. **PresignedURL Lambda**: Generates Presigned URLs for secure and efficient file uploads.
3. **S3 Lambda Listener**: Listens for events triggered by the S3 Bucket to process uploaded files.

## Modules

### AWS S3 Bucket
This module sets up an S3 Bucket and defines resources for managing S3 objects. All mailing lists are stored in a designated folder within this bucket.

- **Resources**:
  - S3 Bucket
  - S3 Object (for the mailing list folder)

### PresignedURL Lambda
This module defines a Lambda function that generates Presigned URLs, allowing for direct file uploads to the S3 Bucket. This method enhances upload efficiency, especially for large files. The Lambda function also logs activities using CloudWatch.

- **Features**:
  - Generates Presigned URLs for file uploads
  - Integrated with CloudWatch for logging

- **Resources**:
  - AWS Lambda
 

### S3 Lambda Listener
This module contains a Lambda function that listens for events triggered by the S3 Bucket. When a file is uploaded using a Presigned URL, this function processes the file.

- **Features**:
  - Listens for S3 Bucket events
  - Processes uploaded files
  - Sends email messages specified in a JSON file
  - Logs actions and errors to a designated sender email address

- **Resources**:
  - AWS Lambda
  - AWS SES (Simple Email Service)

### File Structure
The file must contain email objects, each containing recipient email addresses, mail subject and message bodies. The Lambda function then sends email messages to the specified recipients. Beyond that file must contain mailer address whichis email address which will be used to sends back operation logs.

#### Example File Structure

```json
{
    "mailer": "example.email@example.com",
    "emails": [
        {
            "to": "recipient1@example.com",
            "subject": "Welcome!",
            "body": "Hello World, welcome to our mailing list, powered by AWS."
        },
        {
            "to": "recipient2@example.com",
            "subject": "Welcome!",
            "body": "Hello World, welcome to our mailing list, powered by AWS."
        }
    ]
}
```

#### Logging and Error Handling
In addition to processing emails, the S3 Lambda Listener logs all actions and errors. These logs are sent to a designated sender email address, allowing for monitoring of all activities performed by the Lambda function. If an email recipient is not registered in the SES (Simple Email Service) or if there are any errors, this information is included in the logs and then sends it back to **Fancy Mailing List** user.

#### SES Sandbox Version
This project operates within the constraints of the SES Sandbox version, which limits sending emails to verified addresses only. To circumvent this limitation, the project checks if an email address is registered. If not, it sends a registration link to prompt the recipient to verify their address. This ensures that subsequent email messages are successfully delivered.


All rights reserved **®PwGawżyński**