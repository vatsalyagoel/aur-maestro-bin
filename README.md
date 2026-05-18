# maestro-bin AUR package

This repository mirrors the `maestro-bin` AUR package. It installs the upstream
`maestro.zip` binary release from `mobile-dev-inc/maestro`.

## Update flow

`scripts/update-release.sh` checks the latest upstream GitHub release and only
accepts tags in the `cli-X.Y.Z` format. It downloads `maestro.zip`, updates
`pkgver`, resets `pkgrel` to `1`, updates `sha256sums`, and regenerates
`.SRCINFO` with `makepkg --printsrcinfo`.

The scheduled workflow `.github/workflows/sync-release.yml` runs in an Arch
container as a non-root builder user. If package files change, it opens or
updates a pull request. It does not publish to AUR.

## Publish flow

`scripts/publish-aur.sh` syncs only `PKGBUILD` and `.SRCINFO` to
`ssh://aur@aur.archlinux.org/maestro-bin.git`. It removes obsolete tracked files
in the temporary AUR worktree, commits only when changes exist, and pushes
normally to `master`.

Configure this GitHub Actions secret before publishing:

- `AUR_SSH_PRIVATE_KEY`: private key for an AUR account with maintainer access
  to `maestro-bin`.
