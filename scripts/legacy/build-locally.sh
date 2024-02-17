#!/usr/bin/env bash
set -e

source `dirname $0`/_utils.sh
workdir ${WORKSPACE_BUILD_DIR}

NOTION_PKGDIR="../pkg"
BINDIR="/bin"
DATADIR="/share"
LIBDIR="/lib/notion-app"

check-env NOTION_VERSION NOTION_REPACKAGED_REVISION

if [ ! -d "${NOTION_SRC_NAME}" ]; then
  log "Could not find the directory for this edition's sources, please build them first"
  exit -1
fi

pushd "${NOTION_SRC_NAME}" > /dev/null

log "Creating filesystem structure..."
install -d "${NOTION_PKGDIR}${BINDIR}"
install -d "${NOTION_PKGDIR}${DATADIR}"
install -d "${NOTION_PKGDIR}${LIBDIR}"

log "Copying app..."
cp -a unpacked/{package.json,node_modules,.webpack} "${NOTION_PKGDIR}${LIBDIR}"

log "Downloading better-sqlite3..."
curl -o better-sqlite3.tar.gz -L https://github.com/WiseLibs/better-sqlite3/releases/download/v9.2.2/better-sqlite3-v9.2.2-electron-v119-linux-x64.tar.gz
bsdtar -xf better-sqlite3.tar.gz --strip-components=2
install -Dm644 better_sqlite3.node -t "${NOTION_PKGDIR}${LIBDIR}/node_modules/better-sqlite3/build/Release"

log "Installing dependencies..."

log "Running patch-package"
# npx patch-package

log "Install electron..."
install -d "${NOTION_PKGDIR}${LIBDIR}/electron"
npm install --prefix "${NOTION_PKGDIR}${LIBDIR}/electron" electron@28

log "Patching and installing run script..."
install -Dm755 "${WORKSPACE_DIR}/sources/notion-app" -t "${NOTION_PKGDIR}${BINDIR}"
sed -i "s~@electron@~${LIBDIR}/electron/node_modules/.bin/electron~g" "${NOTION_PKGDIR}${BINDIR}/notion-app"

popd > /dev/null
