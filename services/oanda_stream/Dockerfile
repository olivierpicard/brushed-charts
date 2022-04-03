ARG WORKING_DIR="/usr/src/app"


FROM python:3 as base
ARG WORKING_DIR

RUN useradd -m container-user
WORKDIR ${WORKING_DIR}

COPY requirements.txt .
RUN apt-get update --yes 
RUN apt-get install librdkafka-dev --yes
USER container-user
RUN pip install --no-cache-dir --user -r requirements.txt
COPY src/ .


FROM base as test
COPY requirements-test.txt .
RUN pip install --no-cache-dir --user -r requirements-test.txt


FROM test as linting
CMD python -m pylama


FROM test as unit-test
CMD python -m pytest -p no:cacheprovider tests/unit/

FROM test as modules-integration-test
USER container-user
CMD python -m pytest -p no:cacheprovider tests/modules_integration/


FROM base as service
CMD python -u main.py