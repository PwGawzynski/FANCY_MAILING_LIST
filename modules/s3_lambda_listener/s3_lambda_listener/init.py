import boto3
import logging
from ExecutionLogger import ExecutionLogger

s3_client = boto3.client('s3')
ses_client = boto3.client('ses', region_name='us-east-1')
logger = logging.getLogger()
logger.setLevel("INFO")

ExecutionLogger = ExecutionLogger()

MAX_EMAIL_COUNT = 5