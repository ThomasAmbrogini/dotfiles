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
    || { echo "TARGETS is empty" >&2; exit 1; }

echo "Watch dirs: ${WATCH_DIRS}"

log() {
    printf '[%(%H:%M:%S)T] %s\n' -1 "$*";
}

sync_now() {
    rsync \
        --quiet \
        --archive \
        --delete \
        --include='build*/' \
        --include='build*/**/' \
        --include='build*/*.json' \
        --include='build*/**/*.out' \
        --include='build*/**/*.map' \
        --exclude='build*/**' \
        --exclude='.git/' \
        --exclude='cmake/' \
        "$SRC/" "$DEST/"
}

mkdir -p "${WATCH_DIRS[@]}"
sync_now

while true; do
    mkdir -p "${WATCH_DIRS[@]}"

    exec {inotify_fd}< <(inotifywait -m -q --format '%e %w %f' \
        -e delete,delete_self,close_write,moved_to "${WATCH_DIRS[@]}")
    inotify_pid=$!

    while read -r -u "${inotify_fd}" event dir file; do
        if [[ "${event}" == *DELETE_SELF* ]]; then
            break
        fi

        [[ "${file}" == *.out ]] || continue
        [[ "${dir}" =~ ^(.*/build_[^/]+) ]] || continue
        [[ "${event}" == *CLOSE_WRITE* ]] || continue

        build_dir="${BASH_REMATCH[1]}"
        echo "Build dir: ${build_dir}"

        python3 "${SRC}/tools/fix_compile_commands.py" "${build_dir}/compile_commands.json" \
            -f "${SRC}/.user/pathmap.txt" -o "${build_dir}/compile_commands.json" || log "fix_compile_commands failed"
        sync_now || log "rsync failed"
    done

    kill "${inotify_pid}" 2>/dev/null
    exec {inotify_fd}<&-

done

