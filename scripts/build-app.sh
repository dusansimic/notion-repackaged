#!/bin/bash
set -e
# Ubuntu reqs: npm

source _envs.sh
source _utils.sh

BINDIR="/bin"
DATADIR="/share"
LIBDIR="/lib/notion-app"

log "Create filesystem structure..."
install -d "${PKGDIR}${BINDIR}"
install -d "${PKGDIR}${DATADIR}"
install -d "${PKGDIR}${LIBDIR}"

log "Install electron..."
install -d "${PKGDIR}${LIBDIR}/electron"
npm install --prefix "${PKGDIR}${LIBDIR}/electron" electron@28

pushd "${SRCDIR}/notion" > /dev/null

log "Copying app..."
cp -a unpacked/{package.json,node_modules,.webpack} "${PKGDIR}${LIBDIR}"

log "Installing and patching run script..."
install -Dm755 "${BASEDIR}/sources/notion-app" -t "${PKGDIR}${BINDIR}"
sed -i "s~@electron@~${LIBDIR}/electron/node_modules/.bin/electron~g" "${PKGDIR}${BINDIR}/notion-app"

popd > /dev/null

pushd "${SRCDIR}/better-sqlite3" > /dev/null

install -Dm644 better_sqlite3.node -t "${PKGDIR}${LIBDIR}/node_modules/better-sqlite3/build/Release"

popd > /dev/null
