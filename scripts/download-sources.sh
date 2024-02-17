#!/bin/bash
set -e
# Ubuntu reqs: jq curl

source _envs.sh
source _utils.sh

log "Downloading sources..."

jq -c '.[]' "${BASEDIR}/sources/sources.json" | while read -r source
do
  URL="$(jq -r '."url"' <<< "$source")"
  DEST_FILENAME="$(jq -r '."dest-filename"' <<< "$source")"
  DEST_DIRNAME="$(jq -r '."dest-dirname"' <<< "$source")"
  CHECKSUM="$(jq -r '."sha256"' <<< "$source")"
  PARAM="$(jq -r '."param"' <<< "$source")"

  while read -r key
  do
    value="$(jq -r ."$key" <<< "$PARAM")"
    URL="$(sed "s~@$key@~$value~g" <<< "$URL")"
    DEST_FILENAME="$(sed "s~@$key@~$value~g" <<< "$DEST_FILENAME")"
    DEST_DIRNAME="$(sed "s~@$key@~$value~g" <<< "$DEST_DIRNAME")"
  done < <(jq -r 'keys[]' <<< "$PARAM")

  log "Downloading $DEST_FILENAME..."

  install -d "$SRCDIR/$DEST_DIRNAME"
  curl --progress-bar -L "$URL" -o "$SRCDIR/$DEST_DIRNAME/$DEST_FILENAME"

  pushd "$SRCDIR/$DEST_DIRNAME" > /dev/null
  echo "$CHECKSUM  $DEST_FILENAME" | sha256sum --check -
  popd > /dev/null
done
