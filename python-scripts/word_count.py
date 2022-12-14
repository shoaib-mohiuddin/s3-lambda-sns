import json
import boto3
import os
import io

def lambda_handler(event, context):
    
    print(event)

    # Retrieve the topic ARN and the region where the lambda function is running 
    # from the environment variables.
    # TOPIC_ARN = os.environ['TopicArn']
    # print(TOPIC_ARN)
    FUNCTION_REGION = os.environ['AWS_REGION']
    #print(f"function_region : {FUNCTION_REGION}")
    
    # Extract the topic region from the topic ARN.
    # arnParts = TOPIC_ARN.split(':')
    # TOPIC_REGION = arnParts[3]
    # print(f"topic_region : {TOPIC_REGION}")

    
    # Create a S3 client
    s3Client = boto3.client('s3')
    
    # Retrieve the bucket name and object name from the event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    # print(f"Bucket name : {bucket}")
    # print(f"Object key/name : {key}")
    
    # Get the word count
    response = s3Client.get_object(Bucket=bucket, Key=key)
    data = response['Body'].read().decode('utf-8')
    word_count = len(data.split())
    print(f"The word count in the file {key} is {word_count}.")
        
    # Create an SNS client, and format and publish a message with the total word count in the text file
    snsClient = boto3.client('sns')
    response = snsClient.list_topics()
    TOPIC_ARN = response['Topics'][0]['TopicArn']

     # Create the message
    message = io.StringIO()
    message.write(f"The word count in the file {key} is {word_count}.".center(80))
    message.write('\n')
    
    # Publish the message to the topic.

    response = snsClient.publish(
        TopicArn = TOPIC_ARN,
        #TopicArn = "arn:aws:sns:eu-west-2:045978437674:word-count-topic",
        Subject = 'Word Count Result',
        Message = message.getvalue()
    )
    
    print('200 : email sent')