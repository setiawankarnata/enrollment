FROM python:3.14-slim
LABEL maintainer="setiawankarnatan@gmail.com"

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

WORKDIR /app

EXPOSE 8000

ARG DEV=false
ENV DEV=${DEV}
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        postgresql-client \
        libpq-dev \
        build-essential && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi && \
    apt-get purge -y --auto-remove build-essential libpq-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"
USER django-user

# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
