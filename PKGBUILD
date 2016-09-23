# Maintainer & Contributor: Guillermo Blanco <guillermoechegoyenblanco@gmail.com>
# Upstream URL: https://github.com/m0n0l0c0/mutant
#
# For improvements/fixes to this package, please send a pull request:
# https://github.com/m0n0l0c0/mutant

pkgname=mutant
pkgrel=1
pkgver=0.1.0
pkgdesc="Linux Spotlight Productivity launcher, but more customizable."
url="https://github.com/m0n0l0c0/mutant"
provides=('mutant')
arch=('x86_64')
license=('MIT')
depends=(
#  'pkg-config'
#  'sqlite'
#  'git'
#  'npm'
#  'gtk+-3.0'
#  'librsvg2-dev'
#  'base-devel'
)
makedepends=()
backup=()
install=''
source=(
  "mutant::https://github.com/m0n0l0c0/$pkgname/archive/v$pkgver.tar.gz"
  "mutant-packager::https://github.com/m0n0l0c0/mutant-packager/archive/v0.1.0.tar.gz"
)
sha256sums=(
  'a2d8ce8c386043b4579decbfd0602d77fa628775a568af6804c9a7782bcd1ea0'
  '8611468edd0169ac1ee7b84f3fa5850129e28231366da5841af20df59f8caef0'
)

package() {
  # Prepare executable files
  #chmod 755 -R "$srcdir/mutant-packager-0.1.0/"
  # Launch npm installer
  echo "==> Launch installer"
  "$srcdir/mutant-packager-0.1.0/install.sh" "$srcdir/Mutant-$pkgver"
  # Generate theme and list apps
    echo "==> Search theme..."
    # Default theme in most distros
    theme="Adwaita"
    # Guess settings agent
    if test `which gtk-query-settings`; then
      theme="$(gtk-query-settings gtk-icon-theme-name | awk '{print $2}')"
    else
      theme="$(gsettings get org.gnome.desktop.interface icon-theme | sed -e 's/'\''/"/g')"
    fi
    echo "==> Found: $theme"
    # Save theme
    echo "{\"theme\": $theme }" > "$srcdir/Mutant-$pkgver/misc/theme.json"
    echo "==> Compile..."
    # Make compiler executable
    chmod 755 "$srcdir/mutant-packager-0.1.0/gtkcc.sh"
    "$srcdir/mutant-packager-0.1.0/gtkcc.sh" "$srcdir/mutant-packager-0.1.0/listApps"
    echo "==> Move"
    # Copy listApps to dst folder
    mv "$srcdir/mutant-packager-0.1.0/listApps" "$srcdir/Mutant-$pkgver/apps/native/listApps"
    # Make listApps executable
    chmod 755 "$srcdir/Mutant-$pkgver/apps/native/listApps"
    echo "==> Done"
  
  # Make the program itself
  "$srcdir/mutant-packager-0.1.0/mkDist.sh" "$srcdir/Mutant-$pkgver"
  # Create necessary dirs
  install -dm755 "$pkgdir"/{opt,usr/{bin,share}}
  # Copy executable to fakeroot
  cp -R "$srcdir/Mutant-$pkgver/$pkgname-linux-x64" "$pkgdir/opt/$pkgname"
  # Set permissions on pkgdir
  chmod 755 "$pkgdir/opt/$pkgname/$pkgname"
  install -Dm644 "$srcdir/mutant-packager-0.1.0/mutant.desktop" "${pkgdir}/usr/share/applications/$pkgname.desktop"
  install -Dm644 "$srcdir/mutant-packager-0.1.0/icns/$pkgname.png" "${pkgdir}/usr/share/pixmaps/$pkgname.png"

  ln -s "/opt/$pkgname/$pkgname" "$pkgdir/usr/bin/$pkgname"

}
