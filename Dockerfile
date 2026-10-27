# Change from debian:13 (which installs Python 3.13) to debian:12 (installs Python 3.11)
FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    nano \
    vim \
    curl \
    wget \
    build-essential \
    openssl \
    libxml2 \
    libxslt1.1 \
    libgeos-c1v5 \
    libpq5 \
    libjpeg62-turbo \
    zlib1g \
    libfreetype6 \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --break-system-packages --only-binary=:all: \
    lxml \
    python-dateutil \
    pyparsing \
    requests \
    xlrd \
    xlwt \
    openpyxl \
    reportlab \
    shapely \
    geopy \
    qrcode \
    docx-mailmerge \
    psycopg2-binary \
    sphinx \
    sphinx-rtd-theme

# Workspace
WORKDIR /workspace

# Updated web2py commit reset to official 9005306
RUN git clone https://github.com/web2py/web2py.git && \
    cd web2py && \
    git reset --hard 9005306 && \
    git submodule update --init --recursive

# Generating self-signed certificate
RUN openssl req -x509 -newkey rsa:4096 \
    -keyout /workspace/key.pem -out /workspace/cert.pem -days 365 -nodes \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=localhost.local"

EXPOSE 8000