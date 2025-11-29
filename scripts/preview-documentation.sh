#!/usr/bin/env bash
set -euo pipefail

swift package \
  --disable-sandbox \
  preview-documentation \
  --target AoCCommon
