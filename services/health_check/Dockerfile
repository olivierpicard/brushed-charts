FROM python:3

WORKDIR /usr/src/app

ENV PYTHONUNBUFFERED True
ENV ADMIN_EMAIL_ADDRESS=olivier.picard.m@gmail.com
ENV FIRESTORE_HEALTH_COLLECTION=health
ENV GCP_PROJECT_ID=brushed-charts
ENV SECRET_PATH_MAILGUN_API_KEY=projects/brushed-charts/secrets/mailgun-api-key/versions/latest

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD exec gunicorn --bind :$PORT --workers 1 --threads 2 --timeout 0 app:app