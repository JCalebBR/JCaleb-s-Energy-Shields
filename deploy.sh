#!/usr/bin/env bash
# Build and install the current checkout for local Arma testing.
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
release_zip="$script_dir/releases/CalebsShields-latest.zip"
mod_dir="/home/jcaleb/Mods/JCaleb's Energy Shields"

for dependency in hemtt unzip mktemp find install; do
    if ! command -v "$dependency" >/dev/null 2>&1; then
        printf 'Required command not found: %s\n' "$dependency" >&2
        exit 1
    fi
done

cd -- "$script_dir"
hemtt release

if [[ ! -f "$release_zip" ]]; then
    printf 'Release ZIP not found: %s\n' "$release_zip" >&2
    exit 1
fi

stage_dir=$(mktemp -d /tmp/tda-deploy.XXXXXX)
cleanup() {
    rm -rf -- "$stage_dir"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

unzip -q "$release_zip" -d "$stage_dir"
source_addons="$stage_dir/@CalebsShields/addons"
source_keys="$stage_dir/@CalebsShields/keys"
if [[ ! -d "$source_addons" || ! -d "$source_keys" ]]; then
    printf 'Release ZIP does not have the expected @CalebsShields layout.\n' >&2
    exit 1
fi

mapfile -d '' pbo_files < <(find "$source_addons" -maxdepth 1 -type f -name '*.pbo' -print0)
mapfile -d '' signature_files < <(find "$source_addons" -maxdepth 1 -type f -name '*.bisign' -print0)
mapfile -d '' key_files < <(find "$source_keys" -maxdepth 1 -type f -name '*.bikey' -print0)
if (( ${#pbo_files[@]} == 0 || ${#signature_files[@]} == 0 || ${#key_files[@]} == 0 )); then
    printf 'Release ZIP must contain PBOs, signatures and BI keys.\n' >&2
    exit 1
fi

install -d -- "$mod_dir/addons" "$mod_dir/keys"
install -m 644 -- "${pbo_files[@]}" "${signature_files[@]}" "$mod_dir/addons/"
install -m 644 -- "${key_files[@]}" "$mod_dir/keys/"
printf 'Deployed %d PBO(s), %d signature(s) and %d key(s) to %s.\n' \
    "${#pbo_files[@]}" "${#signature_files[@]}" "${#key_files[@]}" "$mod_dir"
