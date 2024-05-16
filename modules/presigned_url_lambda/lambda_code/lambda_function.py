import boto3
import uuid

def lambda_handler(event, context):
        id = str(uuid.uuid4())
        # Generate a presigned URL for the S3 object
        s3_client = boto3.client('s3')
        
        s3_client = boto3.client('s3')
        try:
            response = s3_client.generate_presigned_post('mailinglistbucketpwgawzynski',
                                                         f'mailing_lists/{id}.json',
                                                         Fields={"Content-Type": "multipart/form-data"},
                                                         ExpiresIn=600)
        except ClientError as e:
            logging.error(e)
            return None
    
        # The response contains the presigned URL and required fields
        return response