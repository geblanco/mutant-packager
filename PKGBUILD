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
  'pkg-config'
  'sqlite'
  'git'
  'npm'
  'gtk+-3.0'
  'librsvg2-dev'
  'base-devel'
)
makedepends=()
backup=()
install=''
source=(
  "git+https://github.com/m0n0l0c0/mutant.git"
  "git+https://github.com/m0n0l0c0/mutant-packager.git"
)
md5sums=('SKIP' 'SKIP')

package() {
  # Prepare executable files
  echo "==> Make files executable"
  chmod 755 -R "$srcdir/mutant-packager/"
  # Launch npm installer
  echo "==> Launch installer"
  "$srcdir/mutant-packager/install.sh" "${srcdir}/mutant"
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
    echo "{\"theme\": $theme }" > "$srcdir/mutant/misc/theme.json"
    echo "==> Compile..."
    # Make compiler executable
    chmod 755 "$srcdir/mutant-packager/gtkcc.sh"
    "$srcdir/mutant-packager/gtkcc.sh" "$srcdir/mutant-packager/listApps"
    echo "==> Move"
    # Copy listApps to dst folder
    mv "$srcdir/mutant-packager/listApps" "$srcdir/mutant/apps/native/listApps"
    # Make listApps executable
    chmod 755 "$srcdir/mutant/apps/native/listApps"
    echo "==> Done"
  
  # Make the program itself
  "$srcdir/mutant-packager/mkDist.sh" "$srcdir/mutant"

  # Copy executable to fakeroot
  cp -r "$srcdir/mutant/mutant-linux-$arch" "$pkgdir/opt/mutant"

  # Set permissions on pkgdir
  find "$pkgdir/opt/mutant/" -type f -exec chmod 644 {} \;
  chmod 755 "$pkgdir/opt/mutant/mutant"

  ln -s ../../opt/mutant/mutant "$pkgdir"/usr/bin/mutant

  install -D -m644 "./Mutant.desktop" "${pkgdir}/usr/share/applications/Mutant.desktop"
  install -D -m644 "./mutant.png" "${pkgdir}/usr/share/pixmaps/mutant.png"
}

