#!/usr/bin/env bash
set -e

source `dirname $0`/_utils.sh
workdir ${WORKSPACE_BUILD_DIR}

# check-cmd bsdtar jq convert sponge
check-env NOTION_VERSION NOTION_REPACKAGED_REVISION

if [ -d "${NOTION_EXTRACTED_EXE_NAME}" ]; then
  log "Removing already extracted exe contents..."
  rm -r "${NOTION_EXTRACTED_EXE_NAME}"
fi

export NOTION_DOWNLOADED_NAME="Notion-${NOTION_VERSION}.exe"
log "Extracting Windows installer contents..."

mkdir "${NOTION_SRC_NAME}"
bsdtar -xf "${NOTION_DOWNLOADED_NAME}" -C "${NOTION_SRC_NAME}"

export NOTION_REPACKAGED_VERSION_REV="${NOTION_VERSION}-${NOTION_REPACKAGED_REVISION}"

pushd "${NOTION_SRC_NAME}" > /dev/null

log "Extracting asar archive"

asar e resources/app.asar unpacked

log "Patching and cleaning source"

sed -ie 's/"win32"===process.platform/(true)/g' unpacked/.webpack/main/index.js
sed -ie 's/_.Store.getState().app.preferences?.isAutoUpdaterDisabled/(true)/g' unpacked/.webpack/main/index.js
sed -ie 's~extra-resources~/usr/share/notion-app~g' unpacked/.webpack/main/index.js
sed -ie 's/trayIcon.ico/trayIcon.png/g' unpacked/.webpack/main/index.js

log "Adapting package.json including fixes..."

# jq \
#   --arg homepage "${NOTION_REPACKAGED_HOMEPAGE}" \
#   --arg repo "${NOTION_REPACKAGED_REPO}" \
#   --arg author "${NOTION_REPACKAGED_AUTHOR}" \
#   --arg version "${NOTION_REPACKAGED_VERSION_REV}" \
#   '.dependencies.cld="2.7.0" | 
#   .name="notion-app" | 
#   .homepage=$homepage | 
#   .repository=$repo | 
#   .author=$author | 
#   .version=$version' \
#   package.json | sponge package.json

log "Converting app icon to png..."

convert "unpacked/icon.ico[0]" "icon.png"

popd > /dev/null
