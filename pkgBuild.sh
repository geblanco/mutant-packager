# Maintainer: Guillermo Blanco <guillermoechegoyenblanco@gmail.com>
# Contributor: Guillermo Blanco <guillermoechegoyenblanco@gmail.com>

pkgname=mutant
pkgrel=1
pkgver=0.1.0
pkgdesc="Linux Spotlight Productivity launcher, but more customizable."
url="https://github.com/m0n0l0c0/mutant"
provides=('mutant')
arch=('x86_64')
license=('MIT')
depends=('pkg-config' 'gtk+-3.0' 'librsvg2-dev' 'sqlite' 'git' 'base-devel')
makedepends=()
backup=()
install=''
source=(
    "https://github.com/m0n0l0c0/mutant/archive/v${pkgver}.tar.gz"
    "git+https://github.com/m0n0l0c0/mutant-packager.git"
)
md5sums=('')

package() {
    # Copy folder to fakeroot
    install -d "$pkgdir"/opt
    # Copy executable to fakeroot
    cp -R "$srcdir"/GitKraken "$pkgdir"/opt/gitkraken

    # Set permissions on pkdir
    find "$pkgdir"/opt/gitkraken/ -type f -exec chmod 644 {} \;
    chmod 755 "$pkgdir"/opt/gitkraken/gitkraken

    install -d "$pkgdir"/usr/bin
    ln -s ../../opt/gitkraken/gitkraken "$pkgdir"/usr/bin/gitkraken

    install -D -m644 "./eula.html" "${pkgdir}/usr/share/licenses/${pkgname}/eula.html"
    install -D -m644 "./GitKraken.desktop" "${pkgdir}/usr/share/applications/GitKraken.desktop"
    install -D -m644 "./gitkraken.png" "${pkgdir}/usr/share/pixmaps/gitkraken.png"
}
