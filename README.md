# s3-lambda-sns

* Create an AWS Lambda function to count the number of words in a text file. The general
  requirements are as follows:
  * Use **Terraform** to develop a **Lambda function** in Python and to create
    its required resources.
  * Report the word count in an *email* using an **Amazon Simple Notification Service (SNS)**
    topic. Optionally, also send the result in an *SMS (text)* message.
  * Format the response message as follows:<br/>
    ```
    The word count in the file <textFileName> is nnn.  
    ```
    Replace *textFileName* with the name of the file.
  * Specify the email subject line as: *Word Count Result*
  * Automatically trigger the function when the text file is uploaded to an **Amazon S3 bucket**.
* Test the function by uploading several text files with different word counts to the S3 bucket.
* Forward the email produced by one of your tests to your instructor along with a screenshot of your
   Lambda function.
* You will need an AWS Identity and Access Management (IAM) role for the Lambda function to
  access other AWS services. Create a LambdaAccessRole role that provides the following permissions:
  * AWSLambdaBasicExecutionRole
  * AmazonSNSFullAccess
  * AmazonS3FullAccess
  * CloudWatchFullAccess

# Infra Diagram
![s3-lambda-sns](s3-lambda-sns.png)

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.2.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.30.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.lambda_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lambda_function.lambda_word_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_s3_bucket.word_count_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.event_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_sns_topic.word_count_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.wc_topic_sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [archive_file.python_script_file](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_lambda_function_name"></a> [lambda\_function\_name](#input\_lambda\_function\_name) | Name of the Lambda function | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->