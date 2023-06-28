#!/usr/bin/env sh
if ! command -v carthage > /dev/null; then
	printf 'Carthage is not installed, See https://github.com/Carthage/Carthage for install instructions. Try: brew install carthage.\n'
	brew install carthage
fi
./carthage.sh update --platform iOS,macOS,tvOS,watchOS --no-use-binaries
./carthage.sh build --platform iOS,macOS,tvOS,watchOS --no-skip-current

if ! command -v pod > /dev/null; then
	printf 'CocoaPods is not installed, See https://github.com/CocoaPods/CocoaPods for install instructions. Try: brew install cocoapods.\n'
	brew install cocoapods
fi
cd Examples;
pod repo update;
pod install;
cd ..;
