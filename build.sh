#!/bin/sh
# Builds all targets and runs tests.

set -o pipefail &&
rm -rf /tmp/LayoutKit &&
time xcodebuild clean test \
    -project LayoutKit.xcodeproj \
    -scheme LayoutKit-macOS \
    -sdk macosx10.11 \
    -derivedDataPath /tmp/LayoutKit \
    OTHER_SWIFT_FLAGS='-Xfrontend -debug-time-function-bodies' \
    | tee build.log \
    | xcpretty
cat build.log | sh debug-time-function-bodies.sh &&
rm -rf /tmp/LayoutKit &&
time xcodebuild clean test \
    -project LayoutKit.xcodeproj \
    -scheme LayoutKit-iOS \
    -sdk iphonesimulator9.3 \
    -derivedDataPath /tmp/LayoutKit \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.3' \
    -destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=9.3' \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.4' \
    -destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=8.4' \
    OTHER_SWIFT_FLAGS='-Xfrontend -debug-time-function-bodies' \
    | tee build.log \
    | xcpretty &&
cat build.log | sh debug-time-function-bodies.sh &&
rm -rf /tmp/LayoutKit &&
time xcodebuild clean build \
    -project LayoutKit.xcodeproj \
    -scheme LayoutKitSampleApp-iOS \
    -sdk iphonesimulator9.3 \
    -derivedDataPath /tmp/LayoutKit \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.3' \
    -destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=9.3' \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.4' \
    -destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=8.4' \
    OTHER_SWIFT_FLAGS='-Xfrontend -debug-time-function-bodies' \
    | tee build.log \
    | xcpretty &&
cat build.log | sh debug-time-function-bodies.sh
