FROM jenkinsci/blueocean:1.8.2

ENV GLIBC_VERSION=2.27-r0

USER root

RUN curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    chmod 775 /usr/local/bin/docker-compose && \
    apk add ca-certificates wget && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://github.com/sgerrand/alpine-pkg-glibc/raw/2.27-r0/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
    apk add glibc-${GLIBC_VERSION}.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk 
RUN    apk add tzdata glibc-bin-${GLIBC_VERSION}.apk && cp /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

