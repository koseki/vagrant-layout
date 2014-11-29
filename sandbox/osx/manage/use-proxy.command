#! /bin/sh

set -e
cd `dirname $0`/../..

CONF_FILE=config/vagrant_proxy.conf
if [ -f $CONF_FILE ]; then
   source $CONF_FILE

   echo Proxy Configuration (sandbox/config/vagrant_proxy.conf)
   echo ----------------------------------------------------------------
   echo HTTP: $http_proxy
   echo HTTPS: $https_proxy
   echo NO Proxy: $no_proxy
   echo ----------------------------------------------------------------
   echo Installing vagrant-proxyconf plugin via proxy.
   echo If installation fails, edit config file and execute use-proxy.command again.
   vagrant plugin install vagrant-proxyconf
else
   echo 'export http_proxy="http://user:passwd@www.example.com:8080"' > $CONF_FILE
   echo 'export https_proxy="http://user:passwd@www.example.com:8080"' >> $CONF_FILE
   echo 'export no_proxy="localhost,127.0.0.1"' >> $CONF_FILE

   echo ----------------------------------------------------------------
   echo Sample proxy configuration file created.
   echo Edit sandbox/config/vagrant_proxy.conf, and execute
   echo use-proxy.command again.
   echo ----------------------------------------------------------------
fi
