#!/bin/bash

set -e

declare -r SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
declare -r TTRPG_VERSION="2.2.17"
declare -r ARCH="linux-x86_64"
declare -r SOURCE_INPUT="${SCRIPT_DIR}/5etools-mirror/data"
declare -r HOMEBREW_INPUT="${SCRIPT_DIR}/homebrew"
declare -r CONVERT_BIN="${SCRIPT_DIR}/bin/ttrpg-convert-cli-${TTRPG_VERSION}-${ARCH}/bin/ttrpg-convert"
declare -r CONVERT_OUTPUT="${SCRIPT_DIR}/../vault/Mechanics/Generated"

function error {
	echo "$@"
	exit 1
}

echo "script is in $SCRIPT_DIR, bin is $CONVERT_BIN"
test -d "${SCRIPT_DIR}/ttrpg-convert-cli/examples/templates" || error "unable to detect ttrpg-convert-cli templates" 
test -d "${CONVERT_OUTPUT}" || error "unable to detect vault output dir"
test -d "${SOURCE_INPUT}" || error "unable to detect sources"
test -f "${CONVERT_BIN}" || error "unable to get ttrpg-convert-cli binary"

$CONVERT_BIN --version || error "can't run ttrpg-convert-cli"

(
	cd "${SCRIPT_DIR}"
	$CONVERT_BIN \
		--config="${SCRIPT_DIR}/ttrpg-config.json" \
		--game=5e \
		-o="${CONVERT_OUTPUT}" \
		"${SOURCE_INPUT}" "${HOMEBREW_INPUT}"
)

