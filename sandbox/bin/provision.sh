#! /bin/sh

set -e
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

VERSION_FILE=/root/.provisioning_version

if [ -f $VERSION_FILE ]; then
  CURRENT_VERSION=`cat $VERSION_FILE`
else
  CURRENT_VERSION='0'
fi

echo "current provisioning version: $CURRENT_VERSION"

# Version 1: epel
VERSION=1
if [ $CURRENT_VERSION -lt $VERSION ]; then
  echo "--- $VERSION ---"
  rpm --import https://fedoraproject.org/static/0608B895.txt
  rpm -Uvh http://download-i2.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
  echo $VERSION > $VERSION_FILE
fi

# Version 2: nginx
VERSION=2
if [ $CURRENT_VERSION -lt $VERSION ]; then
  yum install -y -v nginx --enablerepo=epel

  # To stop 'could not open error log file' alert when starting nginx.
  chmod 777 /var/log/nginx

  echo $VERSION > $VERSION_FILE
fi

# Version 3: mysql
VERSION=3
if [ $CURRENT_VERSION -lt $VERSION ]; then
  echo "--- $VERSION ---"

  yum install -y -v mysql-server mysql-devel

  chmod 777 /var/log/nginx
  chkconfig --level 2345 mysqld on
  service mysqld start

  echo $VERSION > $VERSION_FILE
fi
