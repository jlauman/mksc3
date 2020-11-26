#!/usr/bin/env bash
# set -x
set -e
XPATH=$(dirname $(readlink -f $0))
XFILE=${0##*/}
XBASE=${XFILE%.sh}
sbt "hello3/clean" "show hello3/fullLinkJS"
node -i -e "import('${XPATH}/../package/hello3/target/scala-3.0.0-M2/hello3-opt/hello3.js').then(module => global.Hello3 = module.Hello3);"
# Hello3.hello('world!')
