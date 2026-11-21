pkgname=maestro-bin
pkgver=2.12.1
pkgrel=1
pkgdesc='Mobile UI testing framework (binary release)'
arch=('any')
url='https://maestro.dev'
license=('Apache-2.0')
depends=('bash' 'java-runtime-headless>=17')
provides=('maestro')
conflicts=('maestro' 'maestro-dev')
source=("maestro-${pkgver}.zip::https://github.com/mobile-dev-inc/maestro/releases/download/cli-${pkgver}/maestro.zip")
sha256sums=('54dbb0716425626604973cbb374c585ca30272375d9ce15177a1152765ddd9d7')

package() {
  install -d "$pkgdir/opt/maestro" "$pkgdir/usr/bin"
  cp -a maestro/. "$pkgdir/opt/maestro/"
  ln -s /opt/maestro/bin/maestro "$pkgdir/usr/bin/maestro"
}
