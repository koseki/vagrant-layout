#! /bin/sh

set -e
cd `dirname $0`/../..

source osx/manage/init
vagrant halt
vagrant destroy
