from init import logger
from ExecutionLogger import ExecutionLogger
from typing import Literal, Dict, Any

def is_validable(data: Dict[str, Any]):
    if not data:
        logger.info('Json file do not contain correct data')
        ExecutionLogger.register_global_error("Json file do not contain correct data")
        return False
    if not data['emails']:
        logger.info('Object data not specified, or email property not exist')
        ExecutionLogger.register_global_error("Email property not specified")
        return False
    if not data['mailer']:
        logger.info('Mailer not specified')
        ExecutionLogger.register_global_error("Mailer not specified")
        return False
    return True
    

def is_item_validable(item):
    if not (item['to'] or item['subject'] or item['body']):
        logger.info(f"Object [{item['to'] or item['subject'] or item['body']}]\
        not specyfied all demaged info")
        return False
    return True