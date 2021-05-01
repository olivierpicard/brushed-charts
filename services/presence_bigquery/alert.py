import smtplib
import os
import last_email_sent_date


HOST = os.getenv("MONGODB_HOST")
PORT = os.getenv("MONGODB_PORT")
DATABASE = os.getenv("MONGODB_OANDA_DBNAME")
COLLECTION_NAME = os.getenv("MONGODB_MAIL_COLLECTION")
EMAIL_ADDRESS = os.getenv("ADMIN_EMAIL_ADDRESS")
EMAIL_PASSWORD = os.getenv("ADMIN_EMAIL_PASSWORD")
REFRESH_RATE = os.getenv("PRESENCE_REFRESH_RATE_SECONDS")  # In seconds
BIGQUERY_TABLE_PATH = os.getenv("BIGQUERY_TABLE_PATH_TO_MONITOR_PRESENCE")


def email_on_no_presence(presences: list):
    if len(presences) != 0:
        return
    if not last_email_sent_date.is_ready_to_send_mail():
        return
    send_email()
    last_email_sent_date.save()


def send_email():
    email_content = make_email_message()
    server = smtplib.SMTP_SSL("smtp.gmail.com", 465)
    server.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
    server.sendmail(EMAIL_ADDRESS, EMAIL_ADDRESS, email_content)
    server.quit()


def make_email_message():
    subject = "No presence in {}".format(BIGQUERY_TABLE_PATH)
    body = "There is no data in '{}'\nsince more than {} seconds".format(
        BIGQUERY_TABLE_PATH,
        REFRESH_RATE
    )
    email_content = "Subject: {}\n\n{}".format(subject, body)

    return email_content
