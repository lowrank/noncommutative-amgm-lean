#!/usr/bin/env bash
set -euo pipefail

# The default uses Comparator's sandbox. The explicit diagnostic override is
# useful on hosts whose user-namespace policy prevents bubblewrap from starting.
extra_args=()
if [[ $# -gt 0 ]]; then
  if [[ $# -ne 1 || $1 != --inadvisably-no-sandbox ]]; then
    echo "usage: $0 [--inadvisably-no-sandbox]" >&2
    exit 2
  fi
  extra_args=("$1")
fi

repository_root=$(cd "$(dirname "$0")/.." && pwd)
cd "$repository_root"
toolchain_prefix=$(lean --print-prefix)
for tool in leanexport leanchecker nanoda_bin con-ron; do
  if [[ ! -x "$toolchain_prefix/bin/$tool" ]]; then
    echo "The pinned Lean toolchain does not provide $tool" >&2
    exit 2
  fi
done

runtime_config=$(mktemp "${TMPDIR:-/tmp}/amgm-comparator.XXXXXX.json")
trap 'rm -f "$runtime_config"' EXIT
python3 - comparator.json "$runtime_config" "$toolchain_prefix" <<'PY'
import json
import pathlib
import sys

source, target, prefix = sys.argv[1:]
config = json.loads(pathlib.Path(source).read_text())
if "external_kernels" in config:
    raise SystemExit("external_kernels is not accepted in a Palomar submission configuration")
config.pop("enable_nanoda", None)
config["external_kernels"] = {
    "nanoda": [f"{prefix}/bin/nanoda_bin"],
    "con-ron": [f"{prefix}/bin/con-ron", "--jobs=1"],
}
pathlib.Path(target).write_text(json.dumps(config, indent=2) + "\n")
PY

# Dependencies can be mounted read-only by a verifier. Ordinary CI builds keep
# their writable artifact caching; the isolated comparison never writes caches.
LAKE_ARTIFACT_CACHE=false LAKE_RESTORE_ARTIFACTS=false \
  lake comparator --config "$runtime_config" "${extra_args[@]}"
