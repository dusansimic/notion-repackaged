#!/usr/bin/env bash
set -e

source `dirname $0`/_utils.sh

log "Removing build directory..."

rm -rf ${WORKSPACE_BUILD_DIR}

source "${WORKSPACE_DIR}/notion-repackaged.sh"

${WORKSPACE_DIR}/scripts/download-exe.sh

log "Creating sources..."

${WORKSPACE_DIR}/scripts/extract-src.sh

log "Building edition..."

${WORKSPACE_DIR}/scripts/build-locally.sh

log "Create .tar.xz archive..."
${WORKSPACE_DIR}/scripts/create-pkg.sh

fg > /dev/null 2>&1 || true
log "All build steps have successfully finished."
