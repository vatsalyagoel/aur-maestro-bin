#!/usr/bin/env bash
set -euo pipefail

PKGNAME="maestro-bin"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AUR_URL="ssh://aur@aur.archlinux.org/${PKGNAME}.git"
TMP_DIR=""

cleanup() {
  [[ -n "${TMP_DIR:-}" ]] && rm -rf "$TMP_DIR"
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    printf 'missing required command: %s\n' "$1" >&2
    exit 1
  }
}

prepare_worktree() {
  local workdir="$1"
  local clone_log clone_error

  clone_log="$workdir.clone.log"
  if git clone "$AUR_URL" "$workdir" 2>"$clone_log"; then
    return
  fi

  clone_error="$(<"$clone_log" 2>/dev/null || true)"
  if [[ "$clone_error" == *"Host key verification failed"* || "$clone_error" == *"Permission denied"* || "$clone_error" == *"publickey"* || "$clone_error" == *"ssh_askpass"* ]]; then
    printf '%s\n' "$clone_error" >&2
    exit 1
  fi

  printf 'clone failed for %s; initializing temporary AUR repository\n' "$PKGNAME" >&2
  mkdir -p "$workdir"
  git -C "$workdir" init -b master
  git -C "$workdir" remote add origin "$AUR_URL"
}

ensure_git_identity() {
  local workdir="$1"

  if ! git -C "$workdir" config user.name >/dev/null; then
    git -C "$workdir" config user.name "${GIT_AUTHOR_NAME:-AUR publisher}"
  fi
  if ! git -C "$workdir" config user.email >/dev/null; then
    git -C "$workdir" config user.email "${GIT_AUTHOR_EMAIL:-aur-publisher@users.noreply.github.com}"
  fi
}

sync_package_files() {
  local workdir="$1"
  local tracked=()

  mapfile -d '' tracked < <(git -C "$workdir" ls-files -z)
  if ((${#tracked[@]})); then
    git -C "$workdir" rm -f -- "${tracked[@]}" >/dev/null
  fi

  install -m644 "$ROOT_DIR/PKGBUILD" "$workdir/PKGBUILD"
  install -m644 "$ROOT_DIR/.SRCINFO" "$workdir/.SRCINFO"
  git -C "$workdir" add -A
}

main() {
  need_cmd git
  need_cmd install

  [[ -f "$ROOT_DIR/PKGBUILD" && -f "$ROOT_DIR/.SRCINFO" ]] || {
    printf 'missing PKGBUILD or .SRCINFO\n' >&2
    exit 1
  }

  local workdir
  TMP_DIR="$(mktemp -d)"
  trap cleanup EXIT
  workdir="$TMP_DIR/$PKGNAME"

  prepare_worktree "$workdir"
  ensure_git_identity "$workdir"
  sync_package_files "$workdir"

  if git -C "$workdir" diff --cached --quiet; then
    printf '%s: no AUR changes\n' "$PKGNAME"
    exit 0
  fi

  printf '%s: staged AUR changes\n' "$PKGNAME"
  git -C "$workdir" diff --cached --name-only
  git -C "$workdir" commit -m "Update ${PKGNAME} package"
  git -C "$workdir" push origin master
  printf '%s: published to AUR\n' "$PKGNAME"
}

main "$@"
