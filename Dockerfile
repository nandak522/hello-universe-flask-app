FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y software-properties-common

RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
    curl \
    python3-dev \
    python3-pip \
    less \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /service
COPY requirements.txt .
RUN pip3 install -r requirements.txt
COPY . ./
EXPOSE 9999
CMD ["python3", "app.py"]
