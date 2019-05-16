#!/bin/sh
# Builds all targets and runs tests.

# Defined default derived data location
DERIVED_DATA=${1:-/tmp/LayoutKit}
echo "Derived data location: $DERIVED_DATA";

set -o pipefail &&

echo "Run tests on iOS..." &&
rm -rf $DERIVED_DATA &&
time xcodebuild clean test \
    -project LayoutKit.xcodeproj \
    -scheme LayoutKit-iOS \
    -sdk iphonesimulator12.2 \
    -derivedDataPath $DERIVED_DATA \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=12.2' \
    -destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=12.2' \
    -destination 'platform=iOS Simulator,name=iPhone 7,OS=12.2' \
    -destination 'platform=iOS Simulator,name=iPhone 7 Plus,OS=12.2' \
    -disable-concurrent-destination-testing test-without-building \
    OTHER_SWIFT_FLAGS='-Xfrontend -debug-time-function-bodies' \
    | tee build.log \
    | xcpretty &&
cat build.log | sh debug-time-function-bodies.sh &&

echo "Run tests on macOS..." &&
time xcodebuild clean test \
    -project LayoutKit.xcodeproj \
    -scheme LayoutKit-macOS \
    -sdk macosx10.14 \
    -derivedDataPath $DERIVED_DATA \
    OTHER_SWIFT_FLAGS='-Xfrontend -debug-time-function-bodies' \
    | tee build.log \
    | xcpretty &&
cat build.log | sh debug-time-function-bodies.sh &&

echo "Run tests on tvOS..." &&
rm -rf $DERIVED_DATA &&
time xcodebuild clean test \
    -project LayoutKit.xcodeproj \
    -scheme LayoutKit-tvOS \
    -sdk appletvsimulator12.2 \
    -derivedDataPath $DERIVED_DATA \
    -destination 'platform=tvOS Simulator,name=Apple TV 4K (at 1080p),OS=12.2' \
    OTHER_SWIFT_FLAGS='-Xfrontend -debug-time-function-bodies' \
    | tee build.log \
    | xcpretty &&
cat build.log | sh debug-time-function-bodies.sh &&

echo "Building sample app..." &&
rm -rf $DERIVED_DATA &&
time xcodebuild clean build \
    -project LayoutKit.xcodeproj \
    -scheme LayoutKitSampleApp \
    -sdk iphonesimulator12.2 \
    -derivedDataPath $DERIVED_DATA \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=12.2' \
    -destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=12.2' \
    -destination 'platform=iOS Simulator,name=iPhone 7,OS=12.2' \
    -destination 'platform=iOS Simulator,name=iPhone 7 Plus,OS=12.2' \
    -disable-concurrent-destination-testing \
    OTHER_SWIFT_FLAGS='-Xfrontend -debug-time-function-bodies' \
    | tee ../build.log \
    | xcpretty &&
cat build.log | sh debug-time-function-bodies.sh &&

# Test Cocopods, Carthage, Swift Package Management

echo "Building an iOS empty project with cocoapods..." &&
rm -rf $DERIVED_DATA &&
cd Tests/cocoapods/ios &&
pod install &&
time xcodebuild clean build \
    -workspace LayoutKit-iOS.xcworkspace \
    -scheme LayoutKit-iOS \
    -sdk iphonesimulator12.2 \
    -derivedDataPath $DERIVED_DATA \
    -destination 'platform=iOS Simulator,name=iPhone 7,OS=12.2' \
    OTHER_SWIFT_FLAGS='-Xfrontend -debug-time-function-bodies' \
    | tee ../../../build.log \
    | xcpretty &&
cd ../../.. &&
cat build.log | sh debug-time-function-bodies.sh &&

echo "Building a macOS empty project with cocoapods..." &&
rm -rf $DERIVED_DATA &&
cd Tests/cocoapods/macos &&
pod install &&
time xcodebuild clean build \
    -workspace LayoutKit-macOS.xcworkspace \
    -scheme LayoutKit-macOS \
    -sdk macosx10.14 \
    -derivedDataPath $DERIVED_DATA \
    OTHER_SWIFT_FLAGS='-Xfrontend -debug-time-function-bodies' \
    | tee ../../../build.log \
    | xcpretty &&
cd ../../.. &&
cat build.log | sh debug-time-function-bodies.sh &&

echo "Building a tvOS empty project with cocoapods..." &&
rm -rf $DERIVED_DATA &&
cd Tests/cocoapods/tvos &&
pod install &&
time xcodebuild clean build \
    -workspace LayoutKit-tvOS.xcworkspace \
    -scheme LayoutKit-tvOS \
    -sdk appletvsimulator12.2 \
    -derivedDataPath $DERIVED_DATA \
    -destination 'platform=tvOS Simulator,name=Apple TV 4k (at 1080p),OS=12.2' \
    OTHER_SWIFT_FLAGS='-Xfrontend -debug-time-function-bodies' \
    | tee ../../../build.log \
    | xcpretty &&
cd ../../.. &&
cat build.log | sh debug-time-function-bodies.sh
