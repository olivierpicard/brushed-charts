ARG WORKING_DIR="/usr/src/app"


FROM python:3
ARG WORKING_DIR

RUN useradd -m container-user
WORKDIR ${WORKING_DIR}

COPY requirements.txt .
RUN apt-get update --yes 
RUN apt-get install librdkafka-dev --yes
USER container-user
RUN pip install --no-cache-dir --user -r requirements.txt
COPY src/ .

CMD python -u main.py