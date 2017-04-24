
# Base image
FROM ubuntu:16.04

MAINTAINER Onn Khairuddin Bin Rahmat

COPY rootstart.sh /

RUN bash -lc "chmod +x /rootstart.sh && mkdir -p /data/supervisor \
    && apt-get update && apt-get install -y --no-install-recommends libssl1.0.0 supervisor wget \
    && wget http://redwoodhq.com/download/RedwoodHQLinuxUbuntu_250.tar.gz \
    && tar -xzf RedwoodHQLinuxUbuntu_250.tar.gz 2> /dev/null; exit 0 \
    && rm RedwoodHQLinuxUbuntu_250.tar.gz \
    && apt-get purge wget && apt-get clean all"

COPY supervisord.conf /etc/supervisor/conf.d/redwoodhq.conf

CMD "/usr/bin/supervisord"
EXPOSE 3000

