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

  # Epel
  rpm --import https://fedoraproject.org/static/0608B895.txt
  rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

  # Basic tools
  yum install -y -v patch zlib zlib-devel openssl openssl-devel

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

VERSION=`expr $VERSION + 1`
if [ $CURRENT_VERSION -lt $VERSION ]; then
  echo "--- $VERSION: mysql ---"

  yum install -y -v mysql-server mysql-devel

  chkconfig --level 2345 mysqld on
  service mysqld start

  echo $VERSION > $VERSION_FILE
fi

VERSION=`expr $VERSION + 1`
if [ $CURRENT_VERSION -lt $VERSION ]; then
  echo "--- $VERSION: python ---"

  yum install -y -v gcc

  PYTHON_VER=2.7.9
  PYTHON_SHORT_VER=2.7

  cd /usr/local/src
  wget https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz
  tar xzf Python-${PYTHON_VER}.tgz
  cd Python-${PYTHON_VER}
  ./configure
  make altinstall

  cd /usr/local/src
  wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py
  /usr/local/bin/python${PYTHON_SHORT_VER} get-pip.py

  /usr/local/bin/pip${PYTHON_SHORT_VER} install virtualenv

  mkdir -p /home/vagrant/.virtualenv
  virtualenv -p /usr/local/bin/python${PYTHON_SHORT_VER} /home/vagrant/.virtualenv/python${PYTHON_SHORT_VER}
  chown -R vagrant:vagrant /home/vagrant/.virtualenv

  echo $VERSION > $VERSION_FILE
fi
