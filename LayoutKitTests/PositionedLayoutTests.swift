// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
import LayoutKit

class PositionedLayoutTests: XCTestCase {

    func testMakeViewSingle() {
        let layout = SizeLayout<View>(width: 50, height: 50)
        let view = layout.arrangement().makeViews()
        XCTAssertTrue(view.subviews.isEmpty)
        XCTAssertEqual(view.frame, CGRect(x: 0, y: 0, width: 50, height: 50))
    }

    func testMakeViewMultiple() {
        let insets = EdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let layout1 = InsetLayout(insets: insets, sublayout: SizeLayout<View>(width: 50, height: 50) { _ in })
        let layout2 = InsetLayout(insets: insets, sublayout: SizeLayout<View>(width: 50, height: 50) { _ in })
        let stack = StackLayout(axis: .horizontal, sublayouts: [layout1, layout2])
        let view = stack.arrangement(origin: CGPoint(x: 1, y: 2)).makeViews()
        XCTAssertEqual(view.frame, CGRect(x: 1, y: 2, width: 140, height: 70))
        XCTAssertEqual(view.subviews.count, 2)
        XCTAssertEqual(view.subviews[0].frame, CGRect(x: 10, y: 10, width: 50, height: 50))
        XCTAssertEqual(view.subviews[1].frame, CGRect(x: 80, y: 10, width: 50, height: 50))
    }
}
