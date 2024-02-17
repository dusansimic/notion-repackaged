#!/bin/bash
set -e

source _envs.sh
source _utils.sh

if [ -z "$SUFFIX" ]
then
  log "SUFFIX for package archive is not defined!"
  exit 1
fi

pushd "${BASEDIR}" > /dev/null

log "Create .tar.xz archive..."
tar -cJf "notion-app${SUFFIX}.tar.xz" --transform 's~^~notion-app/~' tools -C "${WORKDIR}" pkg

popd > /dev/null
