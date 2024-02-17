#!/bin/bash
set -e

source `dirname $0`/_utils.sh
workdir ${WORKSPACE_BUILD_DIR}

tar -cJf notion-app.tar.xz --transform 's,^,notion-app/,' pkg -C "${WORKSPACE_DIR}" tools
