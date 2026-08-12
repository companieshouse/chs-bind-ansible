#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_NAME="$(basename "$0")"

log_info() {
    echo "[INFO] ${SCRIPT_NAME}: $*"
}

log_error() {
    echo "[ERROR] ${SCRIPT_NAME}: $*" >&2
}

cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log_error "Zone validation failed"
    fi
}

trap cleanup EXIT

ZONE_DIR="${1:-}"

if [[ -z "${ZONE_DIR}" ]]; then
    log_error "Usage: ${SCRIPT_NAME} <zone-directory>"
    exit 1
fi

if [[ ! -d "${ZONE_DIR}" ]]; then
    log_error "Directory does not exist: ${ZONE_DIR}"
    exit 1
fi

if ! command -v named-checkzone >/dev/null 2>&1; then
    log_error "named-checkzone command not found"
    exit 1
fi

FAILURES=0
ZONE_COUNT=0

while IFS= read -r -d '' zone_file; do

    ((ZONE_COUNT+=1))

    zone_name="$(basename "${zone_file}")"
    zone_name="${zone_name%.zone}"
    zone_name="${zone_name#db.}"

    log_info "Validating ${zone_name}"

    OUTPUT_FILE=$(mktemp)

    if ! named-checkzone "${zone_name}" "${zone_file}" \
        > "${OUTPUT_FILE}" 2>&1; then

        log_error "Zone validation failed for ${zone_name}"
        cat "${OUTPUT_FILE}" >&2

        ((FAILURES+=1))
    else
        log_info "Zone ${zone_name} passed"
    fi

    rm -f "${OUTPUT_FILE}"

done < <(
    find "${ZONE_DIR}" \
        -type f \
        \( -name "*.zone" -o -name "db.*" \) \
        -print0
)

if [[ ${ZONE_COUNT} -eq 0 ]]; then
    log_error "No zone files found"
    exit 1
fi

if [[ ${FAILURES} -gt 0 ]]; then
    log_error "${FAILURES} zone(s) failed validation"
    exit 1
fi

log_info "All zones validated successfully"
