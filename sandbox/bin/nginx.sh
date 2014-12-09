#! /bin/sh

set -e

cd `dirname $0`/../..
PROJECT_ROOT=`pwd`

# Set absolute document root path to nginx.conf
cd sandbox
sed -e "s!PROJECT_ROOT!$PROJECT_ROOT!" config/nginx.conf.src > config/nginx.conf

nginx -p . -c config/nginx.conf
