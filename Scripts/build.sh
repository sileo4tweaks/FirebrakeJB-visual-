#!/usr/bin/env bash
#
# build.sh — Build FirebreakJBKawaii.ipa from source
#
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

BUILD_DIR="$PROJECT_ROOT/build"
DERIVED_DATA="$BUILD_DIR/DerivedData"
IPA_PATH="$BUILD_DIR/FirebreakJBKawaii.ipa"

echo "==> Step 1/4 — Generate Xcode project"
if ! command -v xcodegen >/dev/null 2>&1; then
    echo "xcodegen not found. Install: brew install xcodegen"
    exit 1
fi
xcodegen generate --spec project.yml

echo "==> Step 2/4 — Build .app (unsigned)"
mkdir -p "$BUILD_DIR"
xcodebuild \
    -project FirebreakJBKawaii.xcodeproj \
    -scheme FirebreakJBKawaii \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -derivedDataPath "$DERIVED_DATA" \
    -allowProvisioningUpdates \
    CODE_SIGNING_ALLOWED=NO \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGN_ENTITLEMENTS="" \
    build \
    | tee "$BUILD_DIR/build.log" \
    | tail -40

APP_PATH=$(find "$DERIVED_DATA/Build/Products" -name "FirebreakJBKawaii.app" -maxdepth 4 | head -1)
if [ -z "$APP_PATH" ]; then
    echo "FAILED: FirebreakJBKawaii.app not found" >&2
    exit 2
fi
echo "    .app: $APP_PATH"

echo "==> Step 3/4 — Package IPA"
rm -rf "$BUILD_DIR/Payload"
mkdir "$BUILD_DIR/Payload"
cp -R "$APP_PATH" "$BUILD_DIR/Payload/"
rm -rf "$BUILD_DIR/Payload/FirebreakJBKawaii.app/_CodeSignature"
find "$BUILD_DIR/Payload/FirebreakJBKawaii.app" -name "_CodeSignature" -type d -exec rm -rf {} + 2>/dev/null || true

(
    cd "$BUILD_DIR"
    rm -f FirebreakJBKawaii.ipa
    zip -qry FirebreakJBKawaii.ipa Payload/
)

echo "==> Step 4/4 — Done"
echo ""
echo "SUCCESS ✓"
echo "  IPA:    $IPA_PATH"
echo "  Size:   $(du -h "$IPA_PATH" | awk '{print $1}')"
echo ""
echo "Install via:"
echo "  - SideStore: drag FirebreakJBKawaii.ipa, enter Apple ID"
echo "  - AltStore:  same as SideStore"
echo "  - TrollStore: open .ipa directly"
