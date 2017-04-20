#! /bin/bash

# Installer script for Tarantula, which should be usable in Debian or
# Redhat based distributions.

# Dependencies:
# Rubygems 1.4,2
# monit
# openssl
# nginx

# Ubuntu / Debian -paketit
# build-essential
# irb
# libmysqlclient-dev
# libpcre3
# libssl-dev
# libxml2-dev
# memcached
# monit
# mysql-server
# ruby
# ruby1.8-dev
# rdoc
# zlib1g-dev
# libopenssl-ruby
# openssl

# Gem dependencies are handled with Bundler


# Params:
# $1 source directroy
# $2 destination/link name
#
# If destination exists and is directory, copy its contents to source.
update_symlink() {
    if [ -d $2 ]; then
        cp -r $2/* $1 2> /dev/null
        rm -r $2
    elif [ -L $2 ]; then
        rm $2
    fi

    mkdir -p $(dirname $2)
    ln -s $1 $2
}


colorize_text() {
    echo -en "\e[$2m$1\e[m"
}
bold_red() {
    colorize_text "$1" "1;31"
}
color_red() {
    colorize_text "$1" "0;31"
}
color_yellow() {
    colorize_text "$1" "0;33"
}
color_green() {
    colorize_text "$1" "0;32"
}
bold_text() {
    colorize_text "$1" "1"
}
error_msg() {
    echo -e "$(bold_red Error:) $1"
    exit 1
}

#if [ $(id -u) -gt 0 ]; then
#    echo -e "$(bold_red Error:) Only root can run $0"
#    echo -e "Use "$(bold_text "su -c $0")" or "$(bold_text "sudo $0")
#    exit 1
#fi

TARANTULA_REPO="https://github.com/prove/tarantula.git"

#which lsb_release > /dev/null 2> /dev/null
#if [ $? -gt 0 ]; then
#    error_msg "lsb_release not found. Please install redhat-lsb.( # yum install redhat-lsb ) and try again"
#fi
# DISTRO=$(lsb_release -a 2> /dev/null | grep "Distributor ID" | sed "s/.*\:\s//")
DISTRO="CentOS"
DEFAULT_APACHE_USER="apache"

# Start mysql server if it's not already running
pgrep mysql > /dev/null
if [ $? -gt 0 ]; then
    /etc/init.d/mysqld start
fi

# executed in docker file
#echo "Installing Passenger..."
#gem install rack -v=1.6.5
#gem install passenger > /dev/null 2> /dev/null

VERSION=2014.26.1

    set -e
    git clone "$TARANTULA_REPO" /opt/tarantula/rails
    cd /opt/tarantula/rails
    git submodule init
    git checkout "$VERSION"
    git submodule update
    # Apply patch
	patch -p1 < /01-add-missing-dependency-echoe.patch 
    set +e

# Check and update symlinks for attachment_files, log, tmp tmp/pids
mkdir -p /opt/tarantula/attachment_files /opt/tarantula/log
mkdir -p /opt/tarantula/tmp/pids
update_symlink /opt/tarantula/attachment_files /opt/tarantula/rails/attachment_files
update_symlink /opt/tarantula/log /opt/tarantula/rails/log
update_symlink /opt/tarantula/tmp /opt/tarantula/rails/tmp

# Change proper file permissions
TARANTULA_USER=$DEFAULT_APACHE_USER;

id -u $TARANTULA_USER > /dev/null 2> /dev/null
if [ $? -gt 0 ]; then
    echo "User $TARANTULA_USER doesn't exist and will be created."
    adduser $TARANTULA_USER
fi
touch /opt/tarantula/rails/log/production.log
chown -R $TARANTULA_USER:$TARANTULA_USER /opt/tarantula

set -e
cd /opt/tarantula/rails
bundle install --deployment
set +e

echo -e $(bold_text "Done installing packages and Tarantula files")"\n"
echo "Verify/edit database settings in file: "\
     $(bold_text "/opt/tarantula/rails/config/database.yml")
echo "If db settings are OK run "$(bold_text "RAILS_ENV=production rake tarantula:install")" in Rails root (/opt/tarantula/rails) to initialize DB."

sleep 5

set -e
echo -e "Installing passenger..."
gem install passenger -v=4.0.45
passenger-install-apache2-module -a
set +e

#echo 'Installing Tarantula'
echo -e "$URL\n$EMAIL\n$SMTP_HOST\n$SMTP_PORT\n$SMTP_DOMAIN" | \
		rake tarantula:install

generate_config() {
    if [ ! -f $1 ]; then
        passenger-install-apache2-module --snippet > $1
        echo -e "\n<VirtualHost *:80>" >> $1
        echo -e "\t# ServerName www.yourhost.com" >> $1
        echo -e "\tDocumentRoot /opt/tarantula/rails/public" >> $1
        echo -e "\t<Directory /opt/tarantula/rails/public>" >> $1
        echo -e "\t\tAllowOverride all" >> $1
        echo -e "\t\tOptions -MultiViews" >> $1
        echo -e "\t</Directory>" >> $1
        echo -e "</VirtualHost>" >> $1
        echo "Usable passenger configuration generated to "$(bold_text "$1")
    fi
}

set -e
generate_config /etc/httpd/conf.d/tarantula.conf
echo "Compile Apache native mod_passenger as root by running: "$(bold_text "passenger-install-apache2-module")" and restart Apache: "$(bold_text "service httpd restart")

cd /opt/tarantula/rails
#RAILS_ENV=production rake tarantula:install
