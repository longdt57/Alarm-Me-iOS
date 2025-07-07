#!/bin/sh

# Exit on error
set -e

# Replace with your actual token and project ID
LOKALISE_TOKEN=""
PROJECT_ID=""

# Pull translations from Lokalise
unzip_folder="lokalise"
resource_folder="iOSApp/Resources"

if ! command -v lokalise2 &> /dev/null; then
  echo "lokalise2 CLI not found, installing with Homebrew..."
  if command -v brew &> /dev/null; then
    brew tap lokalise/cli-2
    brew install lokalise2 || { echo "Failed to install lokalise2 CLI"; exit 1; }
  else
    echo "Homebrew not found. Please install Homebrew first: https://brew.sh/"
    exit 1
  fi
fi

lokalise2 \
  --token "$LOKALISE_TOKEN" \
  --project-id "$PROJECT_ID" \
  file download \
  --format strings \
  --original-filenames=true \
  --bundle-structure "%LANG_ISO%/Localizable.strings" \
  --unzip-to "$resource_folder" \
  --export-sort first_added \
