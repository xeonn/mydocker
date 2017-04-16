
# Tarantula docker image

FROM centos:6

MAINTAINER Onn Khairuddin bin Rahmat version: 0.1

ENV RUBY_MAJOR 2.1
ENV RUBY_VERSION 2.1.4

# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN yum -y update && \
yum -y install make gcc readline-devel zlib-devel openssl-devel libyaml libyaml-devel && \
yum -y install epel-release wget && \
yum -y install irb mysql-devel pcre openssl libxml2-devel memcached \
        mysql-server ruby zlib-devel git \
        gcc-c++ curl-devel zlib-devel httpd-devel apr-devel apr-util-devel httpd

# To Build ruby 2.1, Autoconf version 2.67 or higher is required
RUN mkdir -p /usr/src/autoconf \
    && curl -SL "http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz " \
    | tar -xzC /usr/src/autoconf \
    && cd /usr/src/autoconf/autoconf-2.69 \
    && ./configure \
    && make \
    && make install \
    && rm -r /usr/src/autoconf

RUN mkdir -p /usr/src/ruby \
	&& curl -SL "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" \
		| tar -xjC /usr/src/ruby --strip-components=1 \
	&& cd /usr/src/ruby \
	&& autoconf \
	&& ./configure --disable-install-doc \
	&& make -j"$(nproc)" \
	&& yum remove -y ruby \
	&& make install \
	&& rm -r /usr/src/ruby

# skip installing gem documentation
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"

# install things globally, for great justice
ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH
RUN gem install bundler \
	&& bundle config --global path "$GEM_HOME" \
	&& bundle config --global bin "$GEM_HOME/bin"

# don't create ".bundle" in all our apps
ENV BUNDLE_APP_CONFIG $GEM_HOME

#RUN gem install bundler

ENV TARANTULA_REPO "https://github.com/prove/tarantula.git"

RUN wget https://raw.githubusercontent.com/xeonn/mydocker/master/tarantula/patch/01-add-missing-dependency-echoe.patch
RUN wget https://raw.githubusercontent.com/xeonn/mydocker/master/tarantula/install.sh

RUN bash install.sh

RUN yum erase -y wget automake && yum clean all
