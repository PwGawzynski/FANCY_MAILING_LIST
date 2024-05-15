import json
import boto3
from typing import Literal, Dict, Any
from datetime import datetime
from verification import reduce_to_verified, is_mailer_verified
from init import MAX_EMAIL_COUNT, ExecutionLogger, logger, ses_client, s3_client
from validation import is_validable, is_item_validable

BUCKET_NAME = 'pwgawzynskisesmailing'
SENDER_NAME = 'kontakt@pwgawzynski.pl'

def lambda_handler(event, context):
    # dewnloads file name from event
    file_key = event['Records'][0]['s3']['object']['key']

    # getting file from bucket and transform to object
    bucket_file = s3_client.get_object(Bucket=BUCKET_NAME , Key=file_key)
    bucket_file = bucket_file['Body'].read()
    object_data = bucket_file.decode('utf-8')
    object_data = json.loads(object_data)
    
    
    # checks if fille contains all required properties
    if not is_validable(object_data): return
    
    if not is_mailer_verified(object_data['mailer']): return

    verified_mails = reduce_to_verified(object_data['emails'])
    if not (verified_mails or len(verified_mails)):
        ExecutionLogger.register_global_error('None of given mails\
        has not been verified')
        return
    
    if not is_mailer_verified(object_data['mailer']): return
    
    for i, item in enumerate(verified_mails):
        
        if i >= MAX_EMAIL_COUNT:
            ExecutionLogger.register_log_for_mail(item['to'], 'error',\
            f'Cannot send, MAX_REQUESTED_EMAILS({MAX_EMAIL_COUNT}) limit exceeded')
            continue
        
        if not is_item_validable(item):
            continue
        
        response = ses_client.send_email(
                Source=SENDER_NAME,  # Replace with the sender's email address
                Destination={
                    'ToAddresses': [item['to']]  # Replace with the recipient's email address
                },
                Message={
                    'Subject': {
                        'Data': item['subject'],  # Replace with the email subject
                    },
                    'Body': {
                        'Text': {
                            'Data': item['body']
                        }
                    }
                }
            )
        print(response)
        if response:
            ExecutionLogger.register_log_for_mail(item['to'], 'processed',
                                 f'Email has been correctly send to: ({item["to"]})')

    ExecutionLogger.send_operation_logs_report(ses_client, object_data['mailer'])
    return {
        'statusCode': 200,
        'body': json.dumps('mail send')
    }
