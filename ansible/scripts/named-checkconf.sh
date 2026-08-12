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
        log_error "Configuration validation failed"
    fi
}

trap cleanup EXIT

CONFIG_DIR="${1:-}"

if [[ -z "${CONFIG_DIR}" ]]; then
    log_error "Usage: ${SCRIPT_NAME} <config-directory>"
    exit 1
fi

if [[ ! -d "${CONFIG_DIR}" ]]; then
    log_error "Directory does not exist: ${CONFIG_DIR}"
    exit 1
fi

if ! command -v named-checkconf >/dev/null 2>&1; then
    log_error "named-checkconf command not found"
    exit 1
fi

CONF_FILE=$(find "${CONFIG_DIR}" -type f -name "named.conf" | head -1)

if [[ -z "${CONF_FILE}" ]]; then
    log_error "named.conf not found beneath ${CONFIG_DIR}"
    exit 1
fi

if [[ ! -s "${CONF_FILE}" ]]; then
    log_error "named.conf exists but is empty"
    exit 1
fi

log_info "Validating ${CONF_FILE}"

OUTPUT_FILE=$(mktemp)

if ! named-checkconf "${CONF_FILE}" \
    > "${OUTPUT_FILE}" 2>&1; then

    log_error "named-checkconf validation failed"
    cat "${OUTPUT_FILE}" >&2
    rm -f "${OUTPUT_FILE}"
    exit 1
fi

rm -f "${OUTPUT_FILE}"

log_info "Configuration validation successful"
