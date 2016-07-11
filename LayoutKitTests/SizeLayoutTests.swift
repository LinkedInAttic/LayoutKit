// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
import LayoutKit

class SizeLayoutTests: XCTestCase {

    func testExtraSpace() {
        let layout = SizeLayout<View>(width: 50, height: 50)
        let frame = layout.arrangement(width: 60, height: 60).frame
        XCTAssertEqual(frame, CGRect(x: 5, y: 5, width: 50, height: 50))
    }

    func testInsufficientSpace() {
        let layout = SizeLayout<View>(width: 50, height: 50)
        let frame = layout.arrangement(width: 40, height: 40).frame
        XCTAssertEqual(frame, CGRect(x: 0, y: 0, width: 40, height: 40))
    }

    func testCenterAlignment() {
        let layout = SizeLayout<View>(width: 50, height: 50, alignment: .center)
        let frame = layout.arrangement(width: 60, height: 60).frame
        XCTAssertEqual(frame, CGRect(x: 5, y: 5, width: 50, height: 50))
    }

    func testLargerSublayout() {
        let child = SizeLayout<View>(width: 100, height: 100, alignment: .center)
        let parent = SizeLayout<View>(width: 50, height: 50, alignment: .center, sublayout: child)
        let arrangement = parent.arrangement()
        let parentFrame = arrangement.frame
        let childFrame = arrangement.sublayouts.first?.frame
        XCTAssertEqual(parentFrame, CGRect(x: 0, y: 0, width: 50, height: 50))
        XCTAssertEqual(childFrame, CGRect(x: 0, y: 0, width: 50, height: 50))
    }

    func testSmallerSublayout() {
        let child = SizeLayout<View>(width: 50, height: 50, alignment: .center)
        let parent = SizeLayout<View>(width: 100, height: 100, alignment: .center, sublayout: child)
        let arrangement = parent.arrangement()
        let parentFrame = arrangement.frame
        let childFrame = arrangement.sublayouts.first?.frame
        XCTAssertEqual(parentFrame, CGRect(x: 0, y: 0, width: 100, height: 100))
        XCTAssertEqual(childFrame, CGRect(x: 25, y: 25, width: 50, height: 50))
    }

    func testOnlyHeight() {
        let layout = SizeLayout<View>(height: 1)

        let measurement = layout.measurement(within: CGSize(width: 10, height: 10))
        XCTAssertEqual(measurement.size, CGSize(width: 0, height: 1))

        let frame = layout.arrangement(width: 10, height: 10).frame
        XCTAssertEqual(frame, CGRect(x: 0, y: 4.5, width: 10, height: 1))
    }

    func testOnlyWidth() {
        let layout = SizeLayout<View>(width: 1)

        let measurement = layout.measurement(within: CGSize(width: 10, height: 10))
        XCTAssertEqual(measurement.size, CGSize(width: 1, height: 0))

        let frame = layout.arrangement(width: 10, height: 10).frame
        XCTAssertEqual(frame, CGRect(x: 4.5, y: 0, width: 1, height: 10))
    }

    func testWidthConstrainedSublayout() {
        let sublayout = SizeLayout<View>(width: 5, height: 5)
        let layout = SizeLayout<View>(width: 1, sublayout: sublayout)

        let measurement = layout.measurement(within: CGSize(width: 10, height: 10))
        XCTAssertEqual(measurement.size, CGSize(width: 1, height: 5))

        let frame = layout.arrangement(width: 10, height: 10).frame
        XCTAssertEqual(frame, CGRect(x: 4.5, y: 0, width: 1, height: 10))
    }

    func testHeightConstrainedSublayout() {
        let sublayout = SizeLayout<View>(width: 5, height: 5)
        let layout = SizeLayout<View>(height: 1, sublayout: sublayout)

        let measurement = layout.measurement(within: CGSize(width: 10, height: 10))
        XCTAssertEqual(measurement.size, CGSize(width: 5, height: 1))

        let frame = layout.arrangement(width: 10, height: 10).frame
        XCTAssertEqual(frame, CGRect(x: 0, y: 4.5, width: 10, height: 1))
    }

    func testNoWidthNoHeightNoSublayout() {
        // Initializing SizeLayout with no width/height isn't really useful,
        // but we still want to make sure it behaves as expected (zero size).
        let layout = SizeLayout<View>()

        let measurement = layout.measurement(within: CGSize(width: 10, height: 10))
        XCTAssertEqual(measurement.size, CGSizeZero)

        let frame = layout.arrangement().frame
        XCTAssertEqual(frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testNoWidthNoHeightWithSublayout() {
        // Initializing SizeLayout with no width/height isn't really useful,
        // but we still want to make sure it behaves as expected (inherits size of sublayout).
        let sublayout = SizeLayout<View>(width: 5, height: 5)
        let layout = SizeLayout<View>(sublayout: sublayout)

        let measurement = layout.measurement(within: CGSize(width: 10, height: 10))
        XCTAssertEqual(measurement.size, CGSize(width: 5, height: 5))

        let frame = layout.arrangement().frame
        XCTAssertEqual(frame, CGRect(x: 0, y: 0, width: 5, height: 5))
    }
}
