FROM python:3.14-slim
LABEL maintainer="setiawankarnata@gmail.com"

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

WORKDIR /app

COPY . .

EXPOSE 8000

ARG DEV=false

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        postgresql-client \
        libpq-dev \
        libjpeg-dev \
        zlib1g \
        zlib1g-dev \
        build-essential && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi && \
    apt-get purge -y --auto-remove build-essential libpq-dev && \
    apt-get clean && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user && \
    mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    chown -R django-user:django-user /vol && \
    chmod -R 755 /vol

ENV PATH="/py/bin:$PATH"
USER django-user


