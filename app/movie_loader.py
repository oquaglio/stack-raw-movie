import json
import urllib.parse
import boto3
import os

print('Loading function...')

s3 = boto3.client('s3')
s3_resource = boto3.resource('s3')

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))

    try:

        return "ok"

    except Exception as e:
        print(e)
        print('Error writing object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, source_bucket))
        raise e
