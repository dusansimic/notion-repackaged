#!/bin/bash
set -e
# Ubutnu reqs: bsdtar npm:asar imagemagick

source _envs.sh
source _utils.sh

pushd "${SRCDIR}/notion" > /dev/null

log "Extract Windows installer contents..."
install -d setup
bsdtar -xf NotionSetup.exe -C setup

log "Unpack asar archive..."
asar e setup/resources/app.asar unpacked

log "Patching sources..."
sed -ie 's/"win32"===process.platform/(true)/g' unpacked/.webpack/main/index.js
sed -ie 's/_.Store.getState().app.preferences?.isAutoUpdaterDisabled/(true)/g' unpacked/.webpack/main/index.js
sed -ie 's~extra-resources~/usr/share/notion-app~g' unpacked/.webpack/main/index.js
sed -ie 's/trayIcon.ico/trayIcon.png/g' unpacked/.webpack/main/index.js

log "Convert app icon to png..."
convert "unpacked/icon.ico[0]" "icon.png"

log "Cleanup source directory..."
rm -rf NotionSetup.exe setup

popd > /dev/null

pushd "${SRCDIR}/better-sqlite3" > /dev/null

log "Unpack downloaded archive..."
install -d archive
bsdtar -xf better-sqlite3.tar.gz --strip-components=2 -C archive
mv archive/better_sqlite3.node .

log "Cleanup source directory..."
rm -rf better-sqlite3.tar.gz archive

popd > /dev/null
