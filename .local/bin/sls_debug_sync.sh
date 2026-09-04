#!/usr/bin/env bash
# sls_debug_sync — mirror the source tree to the machine where CCS runs,
# every time the linker produces a new binary.
#
#   usage: sls_debug_sync <host-dest> <src-repo> <targets>

set -euo pipefail

DEST="${1:?usage: sls_debug_sync <host-dest> <src-repo> <targets>}"
SRC="${2:?usage: sls_debug_sync <host-dest> <src-repo> <targets>}"
TARGETS="${3:?usage: sls_debug_sync <host-dest> <src-repo> <targets>}"

echo $DEST
echo $SRC
echo $TARGETS

command -v inotifywait >/dev/null \
    || { echo "need inotify-tools: sudo apt install inotify-tools" >&2; exit 1; }

[[ -d "$SRC" ]] || { echo "no source tree at $SRC" >&2; exit 1; }

IFS=":" read -ra _targets <<< ${TARGETS}
WATCH_DIRS=()
for t in "${_targets[@]}"; do
    [[ -z "$t" ]] && continue
    if [[ "$t" == /* ]]; then WATCH_DIRS+=("$t"); else WATCH_DIRS+=("$SRC/$t"); fi
done
(( ${#WATCH_DIRS[@]} > 0 )) \
    || { echo "TARGETS is empty (set it in $CONF)" >&2; exit 1; }

echo ${WATCH_DIRS}

log() {
    printf '[%(%H:%M:%S)T] %s\n' -1 "$*";
}

sync_now() {
    rsync \
        --archive \
        --delete \
        --include='build*/' \
        --include='build*/**/' \
        --include='build*/**/*.out' \
        --include='build*/**/*.map' \
        --exclude='build*/**' \
        --exclude='.git/' \
        --exclude='cmake/' \
        "$SRC/" "$DEST/"
}

mkdir -p "${WATCH_DIRS[@]}"
log "watching ${#WATCH_DIRS[@]} target dir(s) -> $DEST"
sync_now

while true; do
    ev=$(inotifywait -q --format '%w%f' \
        -e close_write,moved_to,delete \
        "${WATCH_DIRS[@]}") \
        || { echo "cannot watch target dirs" >&2; exit 1; }
    mkdir -p "${WATCH_DIRS[@]}"
    if [[ "$ev" == *.out ]]; then sync_now; fi
done

