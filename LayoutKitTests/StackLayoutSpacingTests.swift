// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest

/**
 Tests spacing between sublayouts, including when there is insufficient space.
 */
class StackLayoutSpacingTests: XCTestCase {

    // MARK: - Vertical

    func testVerticalSpacing() {
        let stack = TestStack(axis: .vertical, distribution: .leading, spacing: 4).arrangement()

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: 14))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 0, y: 14+4, width: stack.intrinsicSize.width, height: 18.5))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 0, y: 14+4+18.5+4, width: stack.intrinsicSize.width, height: 23))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: stack.intrinsicSize.height))
    }

    func testVerticalNegativeSpacing() {
        let stack = TestStack(axis: .vertical, distribution: .leading, spacing: -4).arrangement()

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: 14))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 0, y: 14-4, width: stack.intrinsicSize.width, height: 18.5))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 0, y: 14-4+18.5-4, width: stack.intrinsicSize.width, height: 23))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: stack.intrinsicSize.height))
    }

    /**
     Tests to make sure that if sublayouts get collapsed due to insufficient space, then their spacing gets collapsed as well.
     */
    func testVerticalSpacingCollapses() {
        let stack = TestStack(axis: .vertical, distribution: .leading, spacing: 4)

        // The measured size should not include trailing spacing.
        let measurement = stack.stackLayout.measurement(within: CGSize(width: CGFloat.greatestFiniteMagnitude, height: stack.intrinsicSize.height - 23))
        XCTAssertEqual(measurement.size, CGSize(width: 18, height: CGFloat(14+4+18.5)))

        // Position the stack in the space it requested plus some spacing (but not enough to show the third label).
        stack.stackLayout.arrangement(within: CGRect(x: 0, y: 0, width: 18, height: CGFloat(14+4+18.5+4)), measurement: measurement).makeViews()

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: 18, height: 14))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 0, y: 14+4, width: 18, height: 18.5))
        XCTAssertNil(stack.threeView)
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: 18, height: CGFloat(14+4+18.5+4)))
    }

    // MARK: - Horizontal

    func testHorizontalSpacing() {
        let stack = TestStack(axis: .horizontal, distribution: .leading, spacing: 4).arrangement()
        
        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: 7, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 7+4, y: 0, width: 18, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 7+4+18+4, y: 0, width: 33.5, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: stack.intrinsicSize.height))
    }

    func testHorizontalNegativeSpacing() {
        let stack = TestStack(axis: .horizontal, distribution: .leading, spacing: -4).arrangement()

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: 7, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 7-4, y: 0, width: 18, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 7-4+18-4, y: 0, width: 33.5, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: stack.intrinsicSize.height))
    }

    /**
     Tests to make sure that if sublayouts get collapsed due to insufficient space, then their spacing gets collapsed as well.
     */
    func testHorizontalSpacingCollapses() {
        let stack = TestStack(axis: .horizontal, distribution: .leading, spacing: 4)

        // The measured size should not include trailing spacing.
        let measurement = stack.stackLayout.measurement(within: CGSize(width: stack.intrinsicSize.width - 33.5, height: CGFloat.greatestFiniteMagnitude))
        XCTAssertEqual(measurement.size, CGSize(width: 7+4+18, height: 18.5))

        // Position the stack in the space it requested plus some spacing (but not enough to show the third label).
        stack.stackLayout.arrangement(within: CGRect(x: 0, y: 0, width: 7+4+18+4, height: 18.5), measurement: measurement).makeViews()

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: 7, height: 18.5))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 7+4, y: 0, width: 18, height: 18.5))
        XCTAssertNil(stack.threeView)
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: 7+4+18+4, height: 18.5))
    }
}
