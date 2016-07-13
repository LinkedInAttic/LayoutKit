// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics
import XCTest
import LayoutKit

let oneThird = 1.0 / 3.0
let twoThirds = 2.0 / 3.0

private let densityAccuracy: CGFloat = 0.00001

func AssertEqualDensity(actual: CGRect, _ expected: [CGFloat: CGRect], file: StaticString = #file, line: UInt = #line) {
    guard let expected = expectationForCurrentDensity(expected, file: file, line: line) else {
        return
    }
    XCTAssertEqualWithAccuracy(actual.origin.x, expected.origin.x, accuracy: densityAccuracy, file: file, line: line)
    XCTAssertEqualWithAccuracy(actual.origin.y, expected.origin.y, accuracy: densityAccuracy, file: file, line: line)
    XCTAssertEqualWithAccuracy(actual.size.width, expected.size.width, accuracy: densityAccuracy, file: file, line: line)
    XCTAssertEqualWithAccuracy(actual.size.height, expected.size.height, accuracy: densityAccuracy, file: file, line: line)
}

func AssertEqualDensity(actual: CGSize, _ expected: [CGFloat: CGSize], file: StaticString = #file, line: UInt = #line) {
    guard let expected = expectationForCurrentDensity(expected, file: file, line: line) else {
        return
    }
    XCTAssertEqualWithAccuracy(actual.width, expected.width, accuracy: densityAccuracy, file: file, line: line)
    XCTAssertEqualWithAccuracy(actual.height, expected.height, accuracy: densityAccuracy, file: file, line: line)
}

func AssertEqualDensity(actual: CGFloat, _ expected: [CGFloat: CGFloat], file: StaticString = #file, line: UInt = #line) {
    guard let expected = expectationForCurrentDensity(expected, file: file, line: line) else {
        return
    }
    XCTAssertEqualWithAccuracy(actual, expected, accuracy: densityAccuracy, file: file, line: line)
}

/// Returns the expectation for the current density.
private func expectationForCurrentDensity<T>(expected: [CGFloat: T], file: StaticString, line: UInt) -> T? {
    #if os(iOS)
        let scale = UIScreen.mainScreen().scale
    #else
        let scale = NSScreen.mainScreen()?.backingScaleFactor ?? 2.0
    #endif

    guard let expected = expected[scale] else {
        XCTFail("test does not have an expectation for screen scale \(scale)", file: file, line: line)
        return nil
    }
    return expected
}
