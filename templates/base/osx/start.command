#! /bin/sh

set -e
cd `dirname $0`/..

source osx/manage/init
vagrant up
vagrant ssh -c "/vagrant/sandbox/bin/start.sh"
