#!/bin/bash

set -euo pipefail

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
echo "$PROVISIONING_PROFILE_DATA_1" | base64 --decode > ~/Library/MobileDevice/Provisioning\ Profiles/profile1.mobileprovision
echo "$PROVISIONING_PROFILE_DATA_2" | base64 --decode > ~/Library/MobileDevice/Provisioning\ Profiles/profile2.mobileprovision
echo "$PROVISIONING_PROFILE_DATA_3" | base64 --decode > ~/Library/MobileDevice/Provisioning\ Profiles/profile3.mobileprovision
