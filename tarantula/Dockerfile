
# Tarantula docker image

FROM centos:6

MAINTAINER Onn Khairuddin bin Rahmat

ENV URL http://localhost/
ENV EMAIL tarantula@example.org
ENV SMTP_HOST localhost
ENV SMTP_PORT 25
ENV SMTP_DOMAIN localhost

# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN yum -y update && \
yum -y install make gcc readline-devel zlib-devel openssl-devel libyaml libyaml-devel && \
yum -y install epel-release wget patch && \
yum -y install irb mysql-devel pcre openssl libxml2-devel memcached cronie supervisor \
        mysql-server ruby zlib-devel git \
        gcc-c++ curl-devel httpd-devel apr-devel apr-util-devel httpd

RUN gpg2 --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3 && \
	curl -L https://get.rvm.io | bash -s stable
RUN bash -lc "source /usr/local/rvm/scripts/rvm && \
	rvm install 1.9.3 && \
	echo 'gem: --no-rdoc --no-ri' > /etc/gemrc && \
	gem install rails -v 3.2.21"

ENV TARANTULA_REPO "https://github.com/prove/tarantula.git"

ADD patch/01-add-missing-dependency-echoe.patch /
ADD install.sh /
ADD supervisord.conf /etc/supervisord.conf

RUN bash -lc "sh /install.sh \
    && chown apache.apache /tmp/std* \
    && rm -rf /opt/tarantula/rails/.git \
    && mkdir -p /data/supervisor \
    && cp /opt/tarantula/rails/config/crontab /etc/cron.d/tarantula"

RUN bash -lc "yum -y erase wget patch readline-devel openssl-devel \
              libyaml-devel mysql-devel libxml2-devel zlib-devel httpd-devel \
              curl-devel apr-devel apr-util-devel \
    && yum clean all"

EXPOSE 80
CMD ["/usr/bin/supervisord"]

