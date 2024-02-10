# Use the Python 3.11 Alpine image
FROM python:3.11-alpine

WORKDIR /usr/src/app

RUN apk add --no-cache --virtual .build-deps \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    && pip install poetry \
    && apk del .build-deps

COPY . /usr/src/app

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

EXPOSE 5000

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

CMD ["flask", "run"]