#!/usr/bin/env bash
# =============================================================================
# tag-release.sh
# One-shot script: cut v1.0.0 annotated tag and open GitHub Releases UI
# Repository: De-ASI-INTERFACE/x402-ethereum-extension
# Author: Richard Patterson
# Date: 2026-07-09
# =============================================================================
set -euo pipefail

REPO_URL="https://github.com/De-ASI-INTERFACE/x402-ethereum-extension"
TAG="v1.0.0"
MESSAGE="x402-Ethereum Extension v1.0.0 — Richard Patterson"

echo "[x402-ethereum-extension] Cutting tag $TAG"

if [ ! -f "lakefile.lean" ]; then
  echo "ERROR: Run this script from the root of x402-ethereum-extension."
  exit 1
fi

git fetch origin
COMMIT=$(git rev-parse HEAD)
git tag -a "$TAG" "$COMMIT" -m "$MESSAGE"
git push origin "$TAG"

echo ""
echo "Tag $TAG pushed successfully."
echo ""
echo "Now publish the release at:"
echo "  $REPO_URL/releases/new?tag=$TAG"
echo ""
echo "Set title: x402-Ethereum Extension v1.0.0 — Richard Patterson"
echo "Check: Set as latest release"
echo "Click: Publish release"
