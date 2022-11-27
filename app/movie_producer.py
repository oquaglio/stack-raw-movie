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

        for x in range(1, 10000):
            print("Writing file to s3")

            json_file = '[{"id":the_id,"title":"Dirty Harry","properties":[{"name":"Genre","value":"Action"},{"name":"Year","value":"1979"},{"name":"Length","value":"123"},{"name":"Studio","value":"MGM"},{"name":"Rating","value":"7.6"},{"name":"Language","value":"English"},{"name":"Country","value":"USA"}]}]'
            json_file = json_file.replace("the_id", str(x))
            json_data = bytes(json_file, 'utf-8')

            file_name = 'movie_' + str(x) + '.json'

            object = s3_resource.Object('stack-raw-movie-s3-108667452811-apse2-dev', 'landing/movies2/' + file_name)
            result = object.put(Body=json_data)

            print("Done")

        return "ok"

    except Exception as e:
        print(e)
        print('Error writing object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, source_bucket))
        raise e
