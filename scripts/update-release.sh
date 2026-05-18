#!/usr/bin/env bash
set -euo pipefail

UPSTREAM_REPO="mobile-dev-inc/maestro"
API_URL="https://api.github.com/repos/${UPSTREAM_REPO}/releases/latest"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    printf 'missing required command: %s\n' "$1" >&2
    exit 1
  }
}

download_sha256() {
  local url="$1"
  local tmp

  tmp="$(mktemp)"
  curl -fsSL "$url" -o "$tmp"
  sha256sum "$tmp" | cut -d ' ' -f 1
  rm -f "$tmp"
}

update_pkgbuild() {
  local version="$1"
  local checksum="$2"

  python - "$ROOT_DIR/PKGBUILD" "$version" "$checksum" <<'PY'
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
version = sys.argv[2]
checksum = sys.argv[3]
text = path.read_text()
text = re.sub(r"^pkgver=.*$", f"pkgver={version}", text, flags=re.M)
text = re.sub(r"^pkgrel=.*$", "pkgrel=1", text, flags=re.M)
text = re.sub(r"^sha256sums=\('[0-9a-fA-F]+'\)$", f"sha256sums=('{checksum}')", text, flags=re.M)
path.write_text(text)
PY
}

main() {
  need_cmd curl
  need_cmd jq
  need_cmd sha256sum
  need_cmd makepkg
  need_cmd python

  local release tag version bin_url bin_sum
  release="$(curl -fsSL "$API_URL")"
  tag="$(jq -r '.tag_name // empty' <<<"$release")"

  if [[ ! "$tag" =~ ^cli-([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
    printf 'latest release tag must match cli-X.Y.Z, got: %s\n' "${tag:-<empty>}" >&2
    exit 1
  fi

  version="${BASH_REMATCH[1]}"
  bin_url="https://github.com/${UPSTREAM_REPO}/releases/download/${tag}/maestro.zip"

  printf 'checking maestro %s binary package\n' "$version"
  bin_sum="$(download_sha256 "$bin_url")"

  update_pkgbuild "$version" "$bin_sum"
  (cd "$ROOT_DIR" && makepkg --printsrcinfo > .SRCINFO)

  printf 'updated maestro-bin to %s\n' "$version"
}

main "$@"
