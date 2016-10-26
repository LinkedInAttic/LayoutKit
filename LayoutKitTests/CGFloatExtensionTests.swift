// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
@testable import LayoutKit

class CGFloatExtensionTests: XCTestCase {

    struct TestCase {
        let rawValue: CGFloat

        /// Map of screen density to rounded value.
        let roundedValue: [CGFloat: CGFloat]
    }

    func testRoundedUpToFractionalPoint() {
        let scale = UIScreen.main.scale

        let testCases: [TestCase] = [
            TestCase(rawValue: -1.1, roundedValue: [1.0: -1.0, 2.0: -1.0, 3.0: -1.0]),
            TestCase(rawValue: -1.0, roundedValue: [1.0: -1.0, 2.0: -1.0, 3.0: -1.0]),
            TestCase(rawValue: -0.9, roundedValue: [1.0: 0.0, 2.0: -0.5, 3.0: -2.0/3.0]),
            TestCase(rawValue: -0.5, roundedValue: [1.0: 0.0, 2.0: -0.5, 3.0: -1.0/3.0]),
            TestCase(rawValue: -1.0/3.0, roundedValue: [1.0: 0.0, 2.0: 0.0, 3.0: -1.0/3.0]),
            TestCase(rawValue: -0.3, roundedValue: [1.0: 0.0, 2.0: 0.0, 3.0: 0.0]),
            TestCase(rawValue: 0.0, roundedValue: [1.0: 0.0, 2.0: 0.0, 3.0: 0.0]),
            TestCase(rawValue: 0.3, roundedValue: [1.0: 1.0, 2.0: 0.5, 3.0: 1.0/3.0]),
            TestCase(rawValue: 1.0/3.0, roundedValue: [1.0: 1.0, 2.0: 0.5, 3.0: 1.0/3.0]),
            TestCase(rawValue: 0.5, roundedValue: [1.0: 1.0, 2.0: 0.5, 3.0: 2.0/3.0]),
            TestCase(rawValue: 0.9, roundedValue: [1.0: 1.0, 2.0: 1.0, 3.0: 1.0]),
            TestCase(rawValue: 1.0, roundedValue: [1.0: 1.0, 2.0: 1.0, 3.0: 1.0]),
            TestCase(rawValue: 1.1, roundedValue: [1.0: 2.0, 2.0: 1.5, 3.0: 1.0 + 1.0/3.0])
        ]

        for testCase in testCases {
            let expected = testCase.roundedValue[scale]
            XCTAssertEqual(testCase.rawValue.roundedUpToFractionalPoint, expected)
        }
    }

    func testRoundedToFractionalPoint() {
        let scale = UIScreen.main.scale

        let testCases: [TestCase] = [
            TestCase(rawValue: -1.1, roundedValue: [1.0: -1.0, 2.0: -1.0, 3.0: -1.0]),
            TestCase(rawValue: -1.0, roundedValue: [1.0: -1.0, 2.0: -1.0, 3.0: -1.0]),
            TestCase(rawValue: -0.9, roundedValue: [1.0: -1.0, 2.0: -1.0, 3.0: -1.0]),
            TestCase(rawValue: -0.8, roundedValue: [1.0: -1.0, 2.0: -1.0, 3.0: -2.0/3.0]),
            TestCase(rawValue: -0.7, roundedValue: [1.0: -1.0, 2.0: -0.5, 3.0: -2.0/3.0]),
            TestCase(rawValue: -0.6, roundedValue: [1.0: -1.0, 2.0: -0.5, 3.0: -2.0/3.0]),
            TestCase(rawValue: -0.5, roundedValue: [1.0: 0.0, 2.0: -0.5, 3.0: -2.0/3.0]),
            TestCase(rawValue: -0.4, roundedValue: [1.0: 0.0, 2.0: -0.5, 3.0: -1.0/3.0]),
            TestCase(rawValue: -0.3, roundedValue: [1.0: 0.0, 2.0: -0.5, 3.0: -1.0/3.0]),
            TestCase(rawValue: -0.2, roundedValue: [1.0: 0.0, 2.0: -0.0, 3.0: -1.0/3.0]),
            TestCase(rawValue: -0.1, roundedValue: [1.0: 0.0, 2.0: -0.0, 3.0: 0.0]),
            TestCase(rawValue: 0.0, roundedValue: [1.0: 0.0, 2.0: 0.0, 3.0: 0.0]),
            TestCase(rawValue: 0.1, roundedValue: [1.0: 0.0, 2.0: 0.0, 3.0: 0.0]),
            TestCase(rawValue: 0.2, roundedValue: [1.0: 0.0, 2.0: 0.0, 3.0: 1.0/3.0]),
            TestCase(rawValue: 0.3, roundedValue: [1.0: 0.0, 2.0: 0.5, 3.0: 1.0/3.0]),
            TestCase(rawValue: 0.4, roundedValue: [1.0: 0.0, 2.0: 0.5, 3.0: 1.0/3.0]),
            TestCase(rawValue: 0.5, roundedValue: [1.0: 1.0, 2.0: 0.5, 3.0: 2.0/3.0]),
            TestCase(rawValue: 0.6, roundedValue: [1.0: 1.0, 2.0: 0.5, 3.0: 2.0/3.0]),
            TestCase(rawValue: 0.7, roundedValue: [1.0: 1.0, 2.0: 0.5, 3.0: 2.0/3.0]),
            TestCase(rawValue: 0.8, roundedValue: [1.0: 1.0, 2.0: 1.0, 3.0: 2.0/3.0]),
            TestCase(rawValue: 0.9, roundedValue: [1.0: 1.0, 2.0: 1.0, 3.0: 1.0]),
            TestCase(rawValue: 1.0, roundedValue: [1.0: 1.0, 2.0: 1.0, 3.0: 1.0]),
            TestCase(rawValue: 1.1, roundedValue: [1.0: 1.0, 2.0: 1.0, 3.0: 1.0]),
        ]

        for testCase in testCases {
            let expected = testCase.roundedValue[scale]
            XCTAssertEqual(testCase.rawValue.roundedToFractionalPoint, expected)
        }
    }
}
