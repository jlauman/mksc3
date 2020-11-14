#!/usr/bin/env bash
# set -x
XPATH=$(dirname $(readlink -f $0))
XFILE=${0##*/}
XBASE=${XFILE%.sh}
XJAR="${XPATH}/../package/hello1/target/scala-3.0.0-M1/hello1.jar"
if [ ! -f $XJAR ]; then
  pushd "${XPATH}/.."
  sbt hello1/assembly
  popd
fi
scala -jar "${XPATH}/../package/hello1/target/scala-3.0.0-M1/hello1.jar" "$@"
