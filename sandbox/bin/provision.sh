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

VERSION=1
if [ $CURRENT_VERSION -lt $VERSION ]; then
  echo "--- $VERSION: init ---"

  ## Locale and timezone
  # localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
  # echo 'ZONE="Asia/Tokyo"'  > /etc/sysconfig/clock
  # echo 'UTC=false'         >> /etc/sysconfig/clock
  # ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

  echo $VERSION > $VERSION_FILE
fi

VERSION=`expr $VERSION + 1`
if [ $CURRENT_VERSION -lt $VERSION ]; then
  echo "--- $VERSION: epel ---"

  rpm --import https://fedoraproject.org/static/0608B895.txt
  rpm -Uvh http://download-i2.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

  echo $VERSION > $VERSION_FILE
fi

VERSION=`expr $VERSION + 1`
if [ $CURRENT_VERSION -lt $VERSION ]; then
  echo "--- $VERSION: nginx ---"

  yum install -y -v nginx --enablerepo=epel

  # To stop 'could not open error log file' alert when starting nginx.
  chmod 777 /var/log/nginx

  echo $VERSION > $VERSION_FILE
fi
