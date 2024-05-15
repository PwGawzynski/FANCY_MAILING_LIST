from ExecutionLogger import ExecutionLogger
from init import ExecutionLogger, logger, ses_client
from functools import reduce


def register_mail(email: str):
        response = ses_client.verify_email_identity(EmailAddress=email)
        ExecutionLogger.register_log_for_mail(email, 'warning',
                                              f'Email {email} is not verified, registration link has been send')
        
        
def reduce_to_verified(mails_object):
    mails = reduce(lambda prev, cur: [*prev, cur['to']], mails_object, [])
    response = ses_client.get_identity_verification_attributes(
    Identities=mails,
)
    while 'NextToken' in response:
        next_token = response['NextToken']
        r = ses.get_identity_verification_attributes(NextToken=next_token)
        response['VerificationAttributes'] += r['VerificationAttributes']
    
    verified_emails = []
    verification_attributes = response.get("VerificationAttributes", {})
    
    for email, status in verification_attributes.items():
        if status.get("VerificationStatus") == "Success":
            verified_emails.append(email)
            
    for x in [x for x in mails if x not in verified_emails]:
        register_mail(x)
        
    return [x for x in mails_object if x['to'] in verified_emails]


def is_mailer_verified(email: str):
    response = ses_client.get_identity_verification_attributes(
    Identities=[email],
)
    if response.get("VerificationAttributes", {}):
        for mail, res in response.get("VerificationAttributes", {}).items():
            if mail == email and res.get('VerificationStatus') == 'Success':
                return True
    register_mail(email)
    return False
    