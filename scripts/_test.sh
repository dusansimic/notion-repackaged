#!/bin/bash
set -e

source _envs.sh
source _utils.sh

bash download-sources.sh
bash prepare-sources.sh
bash build-app.sh
bash package-app.sh
