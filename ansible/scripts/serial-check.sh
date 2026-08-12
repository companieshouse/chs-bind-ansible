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
        log_error "Validation failed with exit code ${exit_code}"
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

log_info "Starting serial validation"

FAILURES=0
ZONE_COUNT=0

while IFS= read -r -d '' zone_file; do

    ((ZONE_COUNT+=1))

    if [[ ! -s "${zone_file}" ]]; then
        log_error "Empty zone file: ${zone_file}"
        ((FAILURES+=1))
        continue
    fi

    SERIAL=$(grep -E '^[[:space:]]*[0-9]{10}[[:space:]]*;*' "${zone_file}" | head -1 | tr -d ' ' || true)

    if [[ -z "${SERIAL}" ]]; then
        log_error "No serial found in ${zone_file}"
        ((FAILURES+=1))
        continue
    fi

    SERIAL=$(echo "${SERIAL}" | sed 's/;.*//')

    if ! [[ "${SERIAL}" =~ ^[0-9]{10}$ ]]; then
        log_error "Invalid serial format in ${zone_file}: ${SERIAL}"
        ((FAILURES+=1))
        continue
    fi

    YEAR=${SERIAL:0:4}
    MONTH=${SERIAL:4:2}
    DAY=${SERIAL:6:2}

    if ((MONTH < 1 || MONTH > 12)); then
        log_error "Invalid month in serial ${SERIAL} (${zone_file})"
        ((FAILURES+=1))
        continue
    fi

    if ((DAY < 1 || DAY > 31)); then
        log_error "Invalid day in serial ${SERIAL} (${zone_file})"
        ((FAILURES+=1))
        continue
    fi

    log_info "OK: ${zone_file} serial ${SERIAL}"

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
    log_error "${FAILURES} validation failure(s) detected"
    exit 1
fi

log_info "Serial validation completed successfully"
