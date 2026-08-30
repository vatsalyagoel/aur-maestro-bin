pkgname=maestro-bin
pkgver=2.9.0
pkgrel=1
pkgdesc='Mobile UI testing framework (binary release)'
arch=('any')
url='https://maestro.dev'
license=('Apache-2.0')
depends=('bash' 'java-runtime-headless>=17')
provides=('maestro')
conflicts=('maestro' 'maestro-dev')
source=("maestro-${pkgver}.zip::https://github.com/mobile-dev-inc/maestro/releases/download/cli-${pkgver}/maestro.zip")
sha256sums=('855bb2ce1399d82f4f4a73d84a4d945f70b0d43eb86127e027af82809f63f0bd')

package() {
  install -d "$pkgdir/opt/maestro" "$pkgdir/usr/bin"
  cp -a maestro/. "$pkgdir/opt/maestro/"
  ln -s /opt/maestro/bin/maestro "$pkgdir/usr/bin/maestro"
}
