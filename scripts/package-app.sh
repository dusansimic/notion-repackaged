#!/bin/bash
set -e

source _envs.sh
source _utils.sh

pushd "${BASEDIR}" > /dev/null

log "Create .tar.xz archive..."
tar -cJf "notion-app${SUFFIX}.tar.xz" --transform 's~^~notion-app/~' tools -C "${WORKDIR}" pkg

popd > /dev/null
