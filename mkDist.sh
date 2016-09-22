#!/bin/bash

# Enter Working Dir (shall be project root)
prevDir=$(dirname $0)
cd "$1"

arch=x64
./node_modules/.bin/electron-packager ./ mutant \
	--platform=linux \
	--arch=${arch} \
	--version=1.4.0 \
	--prune \
	--ignore=".gitignore" \
	--ignore=".git" \
	--ignore="Model.md" \
	--version-string.FileDescription="Mutant" \
	--version-string.FileVersion="0.1.0" \
	--version-string.ProductVersion="0.1.0" \
	--version-string.ProductName="Mutant" \
	--app-version="0.1.0" \
	--overwrite

# Ownership
# echo "Please change ownership of the executable with 'chmod 755 Mutant-linux-${arch}'"

cd $prevDir
