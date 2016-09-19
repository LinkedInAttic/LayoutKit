// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
import LayoutKit

class StackLayoutTests: XCTestCase {

    #if os(iOS)
    func testTwoLabelVerticalStack() {
        let stack = StackLayout(
            axis: .vertical,
            spacing: 4,
            distribution: .leading,
            sublayouts: [
                LabelLayout(text: "Hi", font: UIFont.helvetica()),
                LabelLayout(text: "Nick Snyder", font: UIFont.helvetica()),
            ]
        )
        let arrangement = stack.arrangement()

        AssertEqualDensity(arrangement.frame, [
            2.0: CGRect(x: 0, y: 0, width: 92, height: 44),
            3.0: CGRect(x: 0, y: 0, width: 91 + twoThirds, height: 43 + oneThird)
        ])
    }
    #endif

    func testConfig() {
        var configCount = 0
        let stack = StackLayout(
            axis: .vertical,
            sublayouts: [
                SizeLayout<View>(width: 1, height: 1)
            ],
            config: { view in
                configCount += 1
            }
        )
        let stackView = stack.arrangement().makeViews()
        XCTAssertNotNil(stackView)
        XCTAssertEqual(configCount, 1)
    }
}
