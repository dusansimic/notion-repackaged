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

if [ "${ADD_ELECTRON}" = "true" ]
then
  log "Installing electron..."
  install -d "${PKGDIR}${LIBDIR}/electron"
  npm install --prefix "${PKGDIR}${LIBDIR}/electron" electron@28
fi

pushd "${SRCDIR}/notion" > /dev/null

log "Copying app..."
cp -a unpacked/{package.json,node_modules,.webpack} "${PKGDIR}${LIBDIR}"

log "Installing and patching run script..."
install -Dm755 "${BASEDIR}/sources/notion-app" -t "${PKGDIR}${BINDIR}"
if [ "${ADD_ELECTRON}" = "true" ]
then
  sed -i "s~@electron@~${LIBDIR}/electron/node_modules/.bin/electron~g" "${PKGDIR}${BINDIR}/notion-app"
else
  log "Not adding electron... skipping patching step..."
fi

log "Installing icons and desktop file..."
install -Dm644 "${BASEDIR}/sources/notion-app.desktop" -t "${PKGDIR}${DATADIR}/applications"
ICON_SIZES=(16 32 48 64 128 256)
for i in "${!ICON_SIZES[@]}"
do
  install -Dm644 "icon-${i}.png" "${PKGDIR}${DATADIR}/icons/hicolor/${ICON_SIZES[$i]}x${ICON_SIZES[$i]}/notion-app.png"
done
install -Dm644 "trayIcon.png" -t "${PKGDIR}${DATADIR}/notion-app"

popd > /dev/null

pushd "${SRCDIR}/better-sqlite3" > /dev/null

install -Dm644 better_sqlite3.node -t "${PKGDIR}${LIBDIR}/node_modules/better-sqlite3/build/Release"

popd > /dev/null
