#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root. Please use sudo." 
   exit 1
fi

set -e

DEST_DIR="/usr/share/fonts/TTF"
WORK_DIR=$(mktemp -d -t font_install_XXXXXX)

LINK_MONO="https://release-assets.githubusercontent.com/github-production-release-asset/27574418/edc5961a-80d3-4135-9055-c41c2df93d08?sp=r&sv=2018-11-09&sr=b&spr=https&se=2026-01-30T09%3A12%3A20Z&rscd=attachment%3B+filename%3DCascadiaMono.zip&rsct=application%2Foctet-stream&skoid=96c2d410-5711-43a1-aedd-ab1947aa7ab0&sktid=398a6654-997b-47e9-b12b-9515b896b4de&skt=2026-01-30T08%3A11%3A45Z&ske=2026-01-30T09%3A12%3A20Z&sks=b&skv=2018-11-09&sig=60QBZp%2BKfOzefPaP6g3tIwLELGYpI%2BFSnjhy943gpXU%3D&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmVsZWFzZS1hc3NldHMuZ2l0aHVidXNlcmNvbnRlbnQuY29tIiwia2V5Ijoia2V5MSIsImV4cCI6MTc2OTc2MzM4NywibmJmIjoxNzY5NzYxNTg3LCJwYXRoIjoicmVsZWFzZWFzc2V0cHJvZHVjdGlvbi5ibG9iLmNvcmUud2luZG93cy5uZXQifQ.zmqu2mJ1Sf7foM6hmiv6nzDPaPJ6deKgL0r64T96Qnw&response-content-disposition=attachment%3B%20filename%3DCascadiaMono.zip&response-content-type=application%2Foctet-stream"

LINK_CODE="https://release-assets.githubusercontent.com/github-production-release-asset/27574418/5ea835be-01a0-41e2-8881-db8eba349581?sp=r&sv=2018-11-09&sr=b&spr=https&se=2026-01-30T09%3A21%3A39Z&rscd=attachment%3B+filename%3DCascadiaCode.zip&rsct=application%2Foctet-stream&skoid=96c2d410-5711-43a1-aedd-ab1947aa7ab0&sktid=398a6654-997b-47e9-b12b-9515b896b4de&skt=2026-01-30T08%3A20%3A47Z&ske=2026-01-30T09%3A21%3A39Z&sks=b&skv=2018-11-09&sig=HsrEK0tVPwI5pUK%2F4MNNO2t9GlhVtfnxLn5tZeBlPG4%3D&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmVsZWFzZS1hc3NldHMuZ2l0aHVidXNlcmNvbnRlbnQuY29tIiwia2V5Ijoia2V5MSIsImV4cCI6MTc2OTc2MzM4NCwibmJmIjoxNzY5NzYxNTg0LCJwYXRoIjoicmVsZWFzZWFzc2V0cHJvZHVjdGlvbi5ibG9iLmNvcmUud2luZG93cy5uZXQifQ.jYJykjdvBfFFzw_3_Kq8Jr1Qq1rSQat3glhHDHu7Y4A&response-content-disposition=attachment%3B%20filename%3DCascadiaCode.zip&response-content-type=application%2Foctet-stream"

echo "Starting Font Installation..."
echo "Working directory: $WORK_DIR"

if [ ! -d "$DEST_DIR" ]; then
    echo "Creating destination directory: $DEST_DIR"
    mkdir -p "$DEST_DIR"
fi

echo "Downloading Cascadia Mono..."
wget -q --show-progress -O "$WORK_DIR/CascadiaMono.zip" "$LINK_MONO"

echo "Downloading Cascadia Code..."
wget -q --show-progress -O "$WORK_DIR/CascadiaCode.zip" "$LINK_CODE"

echo "Extracting files..."
unzip -q "$WORK_DIR/CascadiaMono.zip" -d "$WORK_DIR/extracted_mono"
unzip -q "$WORK_DIR/CascadiaCode.zip" -d "$WORK_DIR/extracted_code"

echo "Installing fonts to $DEST_DIR..."

find "$WORK_DIR/extracted_mono" -name "*.ttf" -exec mv {} "$DEST_DIR/" \;
find "$WORK_DIR/extracted_code" -name "*.ttf" -exec mv {} "$DEST_DIR/" \;

echo "Files moved successfully."

echo "Cleaning up temporary files..."
rm -rf "$WORK_DIR"

echo "Updating font cache..."
fc-cache -fv

echo "========================================"
echo "Done! Fonts installed and cache updated."
echo "========================================"
