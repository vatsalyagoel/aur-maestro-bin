pkgname=maestro-bin
pkgver=2.8.0
pkgrel=1
pkgdesc='Mobile UI testing framework (binary release)'
arch=('any')
url='https://maestro.dev'
license=('Apache-2.0')
depends=('bash' 'java-runtime-headless>=17')
provides=('maestro')
conflicts=('maestro' 'maestro-dev')
source=("maestro-${pkgver}.zip::https://github.com/mobile-dev-inc/maestro/releases/download/cli-${pkgver}/maestro.zip")
sha256sums=('b3e561161904fb391875ca5834d5b22cf0b01c052dd1b408ad83e30d8f8951b3')

package() {
  install -d "$pkgdir/opt/maestro" "$pkgdir/usr/bin"
  cp -a maestro/. "$pkgdir/opt/maestro/"
  ln -s /opt/maestro/bin/maestro "$pkgdir/usr/bin/maestro"
}
