// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
import LayoutKit

class StackLayoutFlexibilityTests: XCTestCase {

    func testVerticalFlexibility() {
        let stack = StackLayout(
            axis: .vertical,
            sublayouts: [
                SizeLayout<View>(width: 1, height: 1, flexibility: .low),
                SizeLayout<View>(width: 1, height: 1, flexibility: .flexible),
                SizeLayout<View>(width: 1, height: 1, flexibility: .high),
            ]
        )
        XCTAssertEqual(stack.flexibility.horizontal, Flexibility.lowFlex)
        XCTAssertEqual(stack.flexibility.vertical, Flexibility.highFlex)
    }

    func testVerticalInflexibility() {
        let stack = StackLayout(
            axis: .vertical,
            sublayouts: [
                SizeLayout<View>(width: 1, height: 1, flexibility: .low),
                SizeLayout<View>(width: 1, height: 1, flexibility: .inflexible),
                SizeLayout<View>(width: 1, height: 1, flexibility: .high),
            ]
        )
        XCTAssertEqual(stack.flexibility.horizontal, nil)
        XCTAssertEqual(stack.flexibility.vertical, Flexibility.highFlex)
    }

    func testHorizontalFlexibility() {
        let stack = StackLayout(
            axis: .horizontal,
            sublayouts: [
                SizeLayout<View>(width: 1, height: 1, flexibility: .low),
                SizeLayout<View>(width: 1, height: 1, flexibility: .flexible),
                SizeLayout<View>(width: 1, height: 1, flexibility: .high),
            ]
        )
        XCTAssertEqual(stack.flexibility.horizontal, Flexibility.highFlex)
        XCTAssertEqual(stack.flexibility.vertical, Flexibility.lowFlex)
    }

    func testHorizontalInflexibility() {
        let stack = StackLayout(
            axis: .horizontal,
            sublayouts: [
                SizeLayout<View>(width: 1, height: 1, flexibility: .low),
                SizeLayout<View>(width: 1, height: 1, flexibility: .inflexible),
                SizeLayout<View>(width: 1, height: 1, flexibility: .high),
            ]
        )
        XCTAssertEqual(stack.flexibility.horizontal, Flexibility.highFlex)
        XCTAssertEqual(stack.flexibility.vertical, nil)
    }
}
