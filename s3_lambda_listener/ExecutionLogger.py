from typing import Literal, Dict, Any
from datetime import datetime
import logging
logger = logging.getLogger()
logger.setLevel("INFO")


class SingletonMeta(type):
    __instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls.__instances:
            instance = super().__call__(*args, **kwargs)
            cls.__instances[cls] = instance
        return cls.__instances[cls]


class ExecutionLogger(metaclass=SingletonMeta):
    __store = {
        "status": "processed",
        "globalErrors": [],
        "logs": [],
    }
    
    LOGGER_MAIL = 'MailerInfo@pwgawzynski.pl'

    def register_global_error(self, message: str):
        self.__store['status'] = "error"
        self.__store['globalErrors'].append({
            "message": message
        })

    def register_log_for_mail(self, email: str, status: Literal["processed", "warning", "error"], info: str):
        if len(self.__store['logs']) > 0:
            for log in self.__store['logs']:
                if email == log['email']:
                    log["status"] = status if status else log["status"]
                    log['info'] = info if info else log["info"]
                    break
                else:
                    self.__store['logs'].append({
                        "email": email,
                        "status": status,
                        "info": info,
                    })
        else:
            self.__store['logs'].append({
                "email": email,
                "status": status,
                "info": info,
            })

    def send_operation_logs_report(self, ses_client, causerAddress: str):
        current_datetime = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        report_subject = f"Operation Logs Report - {current_datetime} - Status: {self.__store['status']}"
        print(self.__store['logs'])
        report_body = f"Global Errors: {self.__store['globalErrors']}\n\n"
        report_body += "Operation Logs:\n"
        for log in self.__store['logs']:
            report_body += f"Email: {log['email']}\n"
            report_body += f"Status: {log['status']}\n"
            report_body += f"Info: {log['info']}\n\n"
            report_body += f"\n\n"
        try:
            response = ses_client.send_email(
                Source=self.LOGGER_MAIL,
                Destination={
                    'ToAddresses': [causerAddress]
                },
                Message={
                    'Subject': {
                        'Data': report_subject
                    },
                    'Body': {
                        'Text': {
                            'Data': report_body
                        }
                    }
                }
            )
            logger.info("Report has been generated")
        except Exception as e:
            logger.info(f"Raport error: {str(e)}")

    def print_logs(self):
        for x in self.__store['logs']:
            print(x)
