#!/bin/bash

baseDir=$(pwd)

# mimic pkgbuild dirs
rm -rf "test"
mkdir "test"
cd "test"
rm -rf build
mkdir -p build/{src,pkg/opt}
cd build

# git clone, src
cp -r "$baseDir/mutant" "$baseDir/test/build/src/mutant"
cp -r "$baseDir/mutant-packager" "$baseDir/test/build/src/mutant-packager"

# git clone, pkg
cp -r "$baseDir/mutant" "$baseDir/test/build/pkg/mutant"
cp -r "$baseDir/mutant-packager" "$baseDir/test/build/pkg/mutant-packager"

srcdir="$(pwd)/src"
pkgdir="$(pwd)/pkg"
pkgname="mutant"
arch="x64"

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

package