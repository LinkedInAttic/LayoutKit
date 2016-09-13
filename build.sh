#!/bin/sh
# Builds all targets and runs tests.

DERIVED_DATA=${1:-/tmp/LayoutKit}
echo "Derived data location: $DERIVED_DATA";

# TODO: need to fixup tests for iOS 10
#-destination 'platform=tvOS Simulator,name=Apple TV 1080p,OS=10.0' \

# Looks like iOS 8 simulator doesn't work in Xcode 8.
#    -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.4' \
#    -destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=8.4' \

set -o pipefail &&
rm -rf $DERIVED_DATA &&
time xcodebuild clean test \
    -project LayoutKit.xcodeproj \
    -scheme LayoutKit-macOS \
    -sdk macosx10.12 \
    -derivedDataPath $DERIVED_DATA \
    OTHER_SWIFT_FLAGS='-Xfrontend -debug-time-function-bodies' \
    | tee build.log \
    | xcpretty &&
cat build.log | sh debug-time-function-bodies.sh &&
rm -rf $DERIVED_DATA &&
time xcodebuild clean test \
    -project LayoutKit.xcodeproj \
    -scheme LayoutKit-tvOS \
    -sdk appletvsimulator10.0 \
    -derivedDataPath $DERIVED_DATA \
    -destination 'platform=tvOS Simulator,name=Apple TV 1080p,OS=9.2' \
    OTHER_SWIFT_FLAGS='-Xfrontend -debug-time-function-bodies' \
    | tee build.log \
    | xcpretty &&
cat build.log | sh debug-time-function-bodies.sh &&
rm -rf $DERIVED_DATA &&
time xcodebuild clean build \
    -project LayoutKit.xcodeproj \
    -scheme LayoutKitSampleApp \
    -sdk iphonesimulator10.0 \
    -derivedDataPath $DERIVED_DATA \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.3' \
    -destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=9.3' \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=10.0' \
    -destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=10.0' \
    OTHER_SWIFT_FLAGS='-Xfrontend -debug-time-function-bodies' \
    | tee build.log \
    | xcpretty &&
cat build.log | sh debug-time-function-bodies.sh &&
rm -rf $DERIVED_DATA &&
time xcodebuild clean test \
    -project LayoutKit.xcodeproj \
    -scheme LayoutKit-iOS \
    -sdk iphonesimulator10.0 \
    -derivedDataPath $DERIVED_DATA \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.3' \
    -destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=9.3' \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=10.0' \
    -destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=10.0' \
    OTHER_SWIFT_FLAGS='-Xfrontend -debug-time-function-bodies' \
    | tee build.log \
    | xcpretty &&
cat build.log | sh debug-time-function-bodies.sh
