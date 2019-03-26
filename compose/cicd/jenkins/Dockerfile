FROM jenkinsci/blueocean:1.13.2

ENV GLIBC_VERSION=2.27-r0

ENV OC_MAJOR_VER=v3.11.0
ENV OC_MINOR_VER=0cbc58b
ENV OC=openshift-origin-client-tools-${OC_MAJOR_VER}-${OC_MINOR_VER}-linux-64bit

USER root

RUN curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    curl -L https://github.com/openshift/origin/releases/download/${OC_MAJOR_VER}/${OC}.tar.gz -o /tmp/oc.tar.gz && \
    tar -xzvf /tmp/oc.tar.gz -C /tmp/ --strip 1 && mv /tmp/oc /usr/local/bin/ && mv /tmp/kubectl /usr/local/bin/ && \
    rm -rf /tmp/oc* && \
    chmod 775 /usr/local/bin/docker-compose /usr/local/bin/oc /usr/local/bin/kubectl && \
    apk add ca-certificates wget && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://github.com/sgerrand/alpine-pkg-glibc/raw/2.27-r0/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
    apk add glibc-${GLIBC_VERSION}.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk 
RUN    apk add tzdata glibc-bin-${GLIBC_VERSION}.apk && cp /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

