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
arch="x64"

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
  install -D -m644 "./icns/mutant.png" "${pkgdir}/usr/share/pixmaps/mutant.png"
}

package