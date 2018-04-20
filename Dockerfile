FROM ddvv/python:latest
# Based on https://hub.docker.com/r/harrisbaird/scrapyd/

RUN echo "https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.6/main/" > /etc/apk/repositories

WORKDIR /scrapyd

# Copy requirements.txt
COPY /data/requirements.txt .

# Set pypi mirror
COPY /data/pip.conf /.pip/pip.conf

# Set default scrapyd.conf
COPY /data/scrapyd.conf /etc/scrapyd/

ENV RUNTIME_PACKAGES ca-certificates libxslt libxml2 libssl1.0
ENV BUILD_PACKAGES build-base libxslt-dev libxml2-dev libffi-dev openssl-dev git

RUN apk update && apk upgrade && apk add --no-cache $RUNTIME_PACKAGES && \
    update-ca-certificates

RUN apk --no-cache add --virtual build-dependencies $BUILD_PACKAGES && \
    python -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip install --upgrade pip setuptools && \
    pip --no-cache-dir install -r requirements.txt && \
    apk del build-dependencies

CMD ["scrapyd"]
