import json
import boto3
import os
import io

def lambda_handler(event, context):
    # Retrieve the topic ARN and the region where the lambda function is running from the environment variables.
    TOPIC_ARN = os.environ['topicARN']
    FUNCTION_REGION = os.environ['AWS_REGION']
    
    # Extract the topic region from the topic ARN.
    arnParts = TOPIC_ARN.split(':')
    TOPIC_REGION = arnParts[3]
    
    # Create a S3 client
    s3Client = boto3.client('s3')
    
    # Retrieve the bucket name and object name from the event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    print(f"Event : {event}")
    print(f"Bucket : {bucket}")
    print(f"Object key : {key}")
    
    # Get the word count
    try:
        response = s3Client.get_object(Bucket=bucket, Key=key)
        data = response['Body'].read().decode('utf-8')
        word_count = len(data.split())
        print(f"The word count in the file {key} is {word_count}.")
    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
        raise e
        
    # Create an SNS client, and format and publish a message the total word count in the text file
    snsClient = boto3.client('sns', region_name=TOPIC_REGION)
    
     # Create the message
    message = io.StringIO()
    message.write(f"The word count in the file {key} is {word_count}.".center(80))
    message.write('\n')
    
    # Publish the message to the topic.

    response = snsClient.publish(
        TopicArn = TOPIC_ARN,
        Subject = 'Word Count Result',
        Message = message.getvalue()
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps('email sent.')
    }

