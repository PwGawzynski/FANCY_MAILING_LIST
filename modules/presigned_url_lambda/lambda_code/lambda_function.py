import boto3
import uuid
import os


BUCKET_NAME = os.getenv('BUCKET_NAME')
FOLDER_NAME = os.getenv('FOLDER_NAME')
print(BUCKET_NAME)
def lambda_handler(event, context):
        id = str(uuid.uuid4())
        # Generate a presigned URL for the S3 object
        s3_client = boto3.client('s3')
        
        s3_client = boto3.client('s3')
        try:
            response = s3_client.generate_presigned_post(BUCKET_NAME,
                                                         f'{FOLDER_NAME}/{id}.json',
                                                         Fields={"Content-Type": "multipart/form-data"},
                                                         ExpiresIn=600)
        except ClientError as e:
            logging.error(e)
            return None
    
        # The response contains the presigned URL and required fields
        return response