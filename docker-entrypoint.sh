#!/bin/sh

. "/opt/toolchains/dc/kos/environ.sh"

if [ $# -eq 0 ]
then
  exec env /bin/sh
else
  exec env /bin/sh -c "$@"
fi
