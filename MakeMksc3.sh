#!/usr/bin/env bash
#set -x
XPATH=$(dirname $(readlink -f $0))
XFILE=${0##*/}
XBASE=${XFILE%.sh}
mkdir -p "${XPATH}/out"
scalac -d "${XPATH}/out" "${XPATH}/${XBASE}.scala"
scala -classpath "${XPATH}/out" "${XBASE}" "$@"

