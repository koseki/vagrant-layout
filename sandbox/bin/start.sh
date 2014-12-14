#! /bin/sh

set -e
cd `dirname $0`/..

touch logs/error.log

./bin/shoreman
