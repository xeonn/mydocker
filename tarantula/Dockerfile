
# Tarantula docker image

FROM centos:6

MAINTAINER Onn Khairuddin bin Rahmat version: 0.1

ENV DEFAULT_APACHE_USER "apache"

# RUN yum -y update && \
RUN yum install -y make gcc readline-devel zlib-devel openssl-devel libyaml redhat-lsb && \
yum install -y epel-release wget && \
yum install -y irb mysql-devel pcre openssl libxml2-devel memcached \
        mysql-server ruby ruby-devel rubygems git \
        gcc-c++ curl-devel zlib-devel httpd-devel apr-devel apr-util-devel httpd

RUN curl -L https://get.rvm.io | sudo bash -s stable --rails
RUN source /usr/local/rvm/scripts/rvm

ENV TARANTULA_REPO "https://github.com/prove/tarantula.git"
ENV VERSION master

# RUN wget https://raw.github.com/prove/tarantula/master/vendor/installer/install.sh
# RUN bash install.sh
RUN pgrep mysql > /dev/null
RUN /etc/init.d/mysqld start
RUN gem install bundler > /dev/null 2> /dev/null
RUN gem install passenger > /dev/null 2> /dev/null

RUN \
mkdir -p /opt/tarantula && \
git clone "$TARANTULA_REPO" /opt/tarantula/rails && \
    cd /opt/tarantula/rails && \
    git submodule init && \
    git checkout "$VERSION" && \
    git submodule update && \
    set +e
    
# Check and update symlinks for attachment_files, log, tmp tmp/pids
RUN \
mkdir -p /opt/tarantula/attachment_files /opt/tarantula/log && \
mkdir -p /opt/tarantula/tmp/pids && \
update_symlink /opt/tarantula/attachment_files /opt/tarantula/rails/attachment_files && \
update_symlink /opt/tarantula/log /opt/tarantula/rails/log && \
update_symlink /opt/tarantula/tmp /opt/tarantula/rails/tmp

RUN yum erase -y wget && yum clean all

CMD [ "irb" ]