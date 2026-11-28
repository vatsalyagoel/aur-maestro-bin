pkgname=maestro-bin
pkgver=2.13.0
pkgrel=1
pkgdesc='Mobile UI testing framework (binary release)'
arch=('any')
url='https://maestro.dev'
license=('Apache-2.0')
depends=('bash' 'java-runtime-headless>=17')
provides=('maestro')
conflicts=('maestro' 'maestro-dev')
source=("maestro-${pkgver}.zip::https://github.com/mobile-dev-inc/maestro/releases/download/cli-${pkgver}/maestro.zip")
sha256sums=('ccc536679ed35e3a84b7e9e5c364f2371204c291fb331fec8c00e3e496dda5ff')

package() {
  install -d "$pkgdir/opt/maestro" "$pkgdir/usr/bin"
  cp -a maestro/. "$pkgdir/opt/maestro/"
  ln -s /opt/maestro/bin/maestro "$pkgdir/usr/bin/maestro"
}
