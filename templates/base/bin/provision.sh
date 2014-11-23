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

# Version 1: basic settings
# VERSION=1
# if [ $CURRENT_VERSION -lt $VERSION ]; then
#   echo "--- $VERSION ---"
#
#   # localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
#
#   echo $VERSION > $VERSION_FILE
# fi

<<'COMMENT'
# Version 0: do something.
VERSION=0
if [ $CURRENT_VERSION -lt $VERSION ]; then
  echo "--- $VERSION ---"

  # do something.

  echo $VERSION > $VERSION_FILE
fi
COMMENT
