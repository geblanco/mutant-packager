#!/bin/bash

# Enter Working Dir (shall be project root)
# prevDir=$(dirname $0)
# cd "$1"

echo "==> Search theme..."
theme="Adwaita"
# Guess settings agent
if test `which gtk-query-settings`; then
  theme="$(gtk-query-settings gtk-icon-theme-name | awk '{print $2}')"
else
  theme="$(gsettings get org.gnome.desktop.interface icon-theme | sed -e 's/'\''/"/g')"
fi
echo "==> Found: $theme"
# Save theme
# echo "{\"theme\": $theme }" > ./misc/theme.json
echo "==> Compile..."
# chmod 755 "./gtkcc.sh"
# ./gtkcc.sh listApps
# echo "==> Move"
# mv listApps ./apps/native/listApps
# echo "==> Done"
# 
# cd prevDir
# 