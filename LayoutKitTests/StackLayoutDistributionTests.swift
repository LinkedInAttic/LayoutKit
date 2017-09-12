// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest

/**
 Tests all permutations of vertical/horizontal and stack distributions when there is excess space along the stack's axis.
 */
class StackLayoutDistributionTests: XCTestCase {

    // MARK: - Vertical

    func testVerticalLeadingDistribution() {
        let stack = TestStack(axis: .vertical, distribution: .leading).arrangement(excessHeight: 10)

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: 14))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 0, y: 14, width: stack.intrinsicSize.width, height: 18.5))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 0, y: 14+18.5, width: stack.intrinsicSize.width, height: 23))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: stack.intrinsicSize.height + 10))
    }

    func testVerticalTrailingDistribution() {
        let stack = TestStack(axis: .vertical, distribution: .trailing).arrangement(excessHeight: 10)
        
        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 10, width: stack.intrinsicSize.width, height: 14))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 0, y: 10+14, width: stack.intrinsicSize.width, height: 18.5))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 0, y: 10+14+18.5, width: stack.intrinsicSize.width, height: 23))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: stack.intrinsicSize.height + 10))
    }

    func testVerticalCenterDistribution() {
        let stack = TestStack(axis: .vertical, distribution: .center).arrangement(excessHeight: 10)

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 5, width: stack.intrinsicSize.width, height: 14))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 0, y: 5+14, width: stack.intrinsicSize.width, height: 18.5))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 0, y: 5+14+18.5, width: stack.intrinsicSize.width, height: 23))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: stack.intrinsicSize.height + 10))
    }

    func testVerticalFillFlexingDistribution() {
        let stack = TestStack(axis: .vertical, distribution: .fillFlexing).arrangement(excessHeight: 10)

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: 14))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 0, y: 14, width: stack.intrinsicSize.width, height: 18.5))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 0, y: 14+18.5, width: stack.intrinsicSize.width, height: 23+10))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: stack.intrinsicSize.height + 10))
    }

    func testVerticalEqualSpacingDistribution() {
        let stack = TestStack(axis: .vertical, distribution: .fillEqualSpacing).arrangement(excessHeight: 10)

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: 14))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 0, y: 5+14, width: stack.intrinsicSize.width, height: 18.5))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 0, y: 10+14+18.5, width: stack.intrinsicSize.width, height: 23))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: stack.intrinsicSize.height + 10))
    }
    
    func testVerticalEqualSpacingDistributionNonZeroSpacing() {
        let stack = TestStack(axis: .vertical, distribution: .fillEqualSpacing, spacing: 10).arrangement(excessHeight: 10)
        
        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: 14))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 0, y: 10+5+14, width: stack.intrinsicSize.width, height: 18.5))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 0, y: 20+10+14+18.5, width: stack.intrinsicSize.width, height: 23))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: stack.intrinsicSize.height + 10))
    }

    func testVerticalEqualSizeDistribution() {
        let stack = TestStack(axis: .vertical, distribution: .fillEqualSize).arrangement(excessHeight: 16.5)

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: 24))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 0, y: 24, width: stack.intrinsicSize.width, height: 24))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 0, y: 48, width: stack.intrinsicSize.width, height: 24))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: stack.intrinsicSize.height + 16.5))
    }

    func testVerticalEqualSizeDistributionNonZeroSpacing() {
        let stack = TestStack(axis: .vertical, distribution: .fillEqualSize, spacing: 10).arrangement(excessHeight: 16.5)

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: 24))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 0, y: 34, width: stack.intrinsicSize.width, height: 24))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 0, y: 68, width: stack.intrinsicSize.width, height: 24))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: stack.intrinsicSize.height + 16.5))
    }

    func testVerticalEqualSizeDistributionRightAligned() {
        let stack = TestStack(axis: .vertical, distribution: .fillEqualSize, alignment: .bottomTrailing).arrangement(excessHeight: 1000)

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width, height: 23))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 0, y: 23, width: stack.intrinsicSize.width, height: 23))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 0, y: 46, width: stack.intrinsicSize.width, height: 23))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 986.5, width: stack.intrinsicSize.width, height: 69))
    }

    func testVerticalEqualSizeDistributionNoSpace() {
        let stack = TestStack(axis: .vertical, distribution: .fillEqualSize, alignment: .topTrailing)
        stack.stackLayout.arrangement(height: 0).makeViews()

        XCTAssertNil(stack.oneView)
        XCTAssertNil(stack.twoView)
        XCTAssertNil(stack.threeView)
        XCTAssertEqual(stack.stackView.frame, .zero)
    }
    
    func testVerticalEqualSizeDistributionOneLayoutDropped() {
        let stack = TestStack(axis: .vertical, distribution: .fillEqualSize, spacing: 10, alignment: .topTrailing)
        stack.stackLayout.arrangement(height: 19).makeViews()

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: 18, height: 4.5))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 0, y: 14.5, width: 18, height: 4.5))
        XCTAssertNil(stack.threeView)
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: 18, height: 19))
    }
    
    // MARK: - Horizontal

    func testHorizontalLeadingDistribution() {
        let stack = TestStack(axis: .horizontal, distribution: .leading).arrangement(excessWidth: 10)

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: 7, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 7, y: 0, width: 18, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 7+18, y: 0, width: 33.5, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width + 10, height: stack.intrinsicSize.height))
    }

    func testHorizontalTrailingDistribution() {
        let stack = TestStack(axis: .horizontal, distribution: .trailing).arrangement(excessWidth: 10)

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 10, y: 0, width: 7, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 10+7, y: 0, width: 18, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 10+7+18, y: 0, width: 33.5, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width + 10, height: stack.intrinsicSize.height))
    }

    func testHorizontalFillFlexingDistribution() {
        let stack = TestStack(axis: .horizontal, distribution: .fillFlexing).arrangement(excessWidth: 10)

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: 7, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 7, y: 0, width: 18, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 7+18, y: 0, width: 10+33.5, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width + 10, height: stack.intrinsicSize.height))
    }

    func testHorizontalCenterDistribution() {
        let stack = TestStack(axis: .horizontal, distribution: .center).arrangement(excessWidth: 10)

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 5, y: 0, width: 7, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 5+7, y: 0, width: 18, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 5+7+18, y: 0, width: 33.5, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width + 10, height: stack.intrinsicSize.height))
    }

    func testHorizontalEqualSpacingDistribution() {
        let stack = TestStack(axis: .horizontal, distribution: .fillEqualSpacing).arrangement(excessWidth: 10)

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: 7, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 5+7, y: 0, width: 18, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 10+7+18, y: 0, width: 33.5, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width + 10, height: stack.intrinsicSize.height))
    }
    
    func testHorizontalEqualSpacingDistributionNonZeroSpacing() {
        let stack = TestStack(axis: .horizontal, distribution: .fillEqualSpacing, spacing: 10).arrangement(excessWidth: 10)
        
        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: 7, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 10+5+7, y: 0, width: 18, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 20+10+7+18, y: 0, width: 33.5, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width + 10, height: stack.intrinsicSize.height))
    }

    func testHorizontalEqualSizeDistribution() {
        let stack = TestStack(axis: .horizontal, distribution: .fillEqualSize).arrangement(excessWidth: 16.5)

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: 25, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 25, y: 0, width: 25, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 50, y: 0, width: 25, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width + 16.5, height: stack.intrinsicSize.height))
    }

    func testHorizontalEqualSizeDistributionNonZeroSpacing() {
        let stack = TestStack(axis: .horizontal, distribution: .fillEqualSize, spacing: 10).arrangement(excessWidth: 16.5)

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: 25, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 35, y: 0, width: 25, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 70, y: 0, width: 25, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: stack.intrinsicSize.width + 16.5, height: stack.intrinsicSize.height))
    }

    func testHorizontalEqualSizeDistributionRightAligned() {
        let stack = TestStack(axis: .horizontal, distribution: .fillEqualSize, alignment: .topTrailing).arrangement(excessWidth: 1000)

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: 33.5, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 33.5, y: 0, width: 33.5, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.threeView.frame, CGRect(x: 67, y: 0, width: 33.5, height: stack.intrinsicSize.height))
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 958, y: 0, width: 100.5, height: stack.intrinsicSize.height))
    }

    func testHorizontalEqualSizeDistributionNoSpace() {
        let stack = TestStack(axis: .horizontal, distribution: .fillEqualSize, alignment: .topTrailing)
        stack.stackLayout.arrangement(width: 0).makeViews()

        XCTAssertNil(stack.oneView)
        XCTAssertNil(stack.twoView)
        XCTAssertNil(stack.threeView)
        XCTAssertEqual(stack.stackView.frame, .zero)
    }

    func testHorizontalEqualSizeDistributionOneLayoutDropped() {
        let stack = TestStack(axis: .horizontal, distribution: .fillEqualSize, spacing: 10, alignment: .topTrailing)
        stack.stackLayout.arrangement(width: 19).makeViews()

        XCTAssertEqual(stack.oneView.frame, CGRect(x: 0, y: 0, width: 4.5, height: 18.5))
        XCTAssertEqual(stack.twoView.frame, CGRect(x: 14.5, y: 0, width: 4.5, height: 18.5))
        XCTAssertNil(stack.threeView)
        XCTAssertEqual(stack.stackView.frame, CGRect(x: 0, y: 0, width: 19, height: 18.5))
    }
}
