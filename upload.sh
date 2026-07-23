#!/bin/bash

# check gh 
if ! command -v gh >/dev/null 2>&1; then
    echo "Installing gh..."
    curl -sS https://webi.sh/gh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

# check token.txt
if [ ! -f token.txt ]; then
    echo "Error: token.txt not found!"
    exit 1
fi

# login by token.txt
gh auth login --with-token < token.txt

# get first zip file
ZIP=$(ls out/target/product/flame/*.zip 2>/dev/null | head -n1)
if [ -z "$ZIP" ]; then
    echo "No zip file found."
    exit 1
fi

SIZE=$(stat -c%s "$ZIP")
LIMIT=2147483648
TAG="flame-$(date +%Y%m%d-%H%M%S)"

if [ "$SIZE" -le "$LIMIT" ]; then
    gh release create "$TAG" --repo woaiduling2/manifests --title "official flame" --notes "" "$ZIP"
    echo "zip uploaded."
else
    echo "File exceeds 2 GiB, splitting..."
    split -b 2G "$ZIP" "${ZIP}.part-"
    for part in "${ZIP}.part-"*; do
        gh release upload "$TAG" "$part" --repo woaiduling2/manifests --clobber
    done
    gh release edit "$TAG" --repo woaiduling2/manifests --notes "File exceeds 2 GiB, split into parts. To merge: cat ${ZIP##*/}.part-* > ${ZIP##*/}"
    echo "Split into parts and uploaded."
fi
