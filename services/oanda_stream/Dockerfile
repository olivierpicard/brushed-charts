FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt .
RUN apt-get update --yes 
RUN apt-get install librdkafka-dev --yes
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ .

CMD [ "python", "-u", "main.py" ]