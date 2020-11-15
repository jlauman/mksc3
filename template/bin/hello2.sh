#!/usr/bin/env bash
# set -x
set -e
XPATH=$(dirname $(readlink -f $0))
XFILE=${0##*/}
XBASE=${XFILE%.sh}
XMAIN="${XPATH}/../package/hello2/target/scala-3.0.0-M1/hello2-opt/main.js"
if [ ! -f $XMAIN ]; then
  pushd "${XPATH}/.."
  sbt hello2/fullLinkJS
  popd
fi
node "$XMAIN" "$@"
