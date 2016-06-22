// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
import LayoutKit

class InsetLayoutTests: XCTestCase {

    func testInsetLabel() {
        let insetLabel = InsetLayout(
            insets: UIEdgeInsets(top: 2, left: 4, bottom: 8, right: 16),
            sublayout: LabelLayout(text: "Hi", font: UIFont.helvetica())
        )
        let arrangement = insetLabel.arrangement()
        AssertEqualDensity(arrangement.frame, [
            2.0: CGRect(x: 0, y: 0, width: 4+16.5+16, height: 2+20+8),
            3.0: CGRect(x: 0, y: 0, width: 4+16+oneThird+16, height: 2+20-oneThird+8),
        ])
        AssertEqualDensity(arrangement.sublayouts.first!.frame, [
            2.0:  CGRect(x: 4, y: 2, width: 16.5, height: 20),
            3.0:  CGRect(x: 4, y: 2, width: 16+oneThird, height: 20-oneThird),
        ])
    }

    func testInsetConvenience() {
        let insetLabel = InsetLayout(
            inset: 2,
            sublayout: LabelLayout(text: "Hi", font: UIFont.helvetica())
        )
        let arrangement = insetLabel.arrangement()
        AssertEqualDensity(arrangement.frame, [
            2.0: CGRect(x: 0, y: 0, width: 2+16.5+2, height: 2+20+2),
            3.0: CGRect(x: 0, y: 0, width: 2+16+oneThird+2, height: 2+20-oneThird+2),
            ])
        AssertEqualDensity(arrangement.sublayouts.first!.frame, [
            2.0:  CGRect(x: 2, y: 2, width: 16.5, height: 20),
            3.0:  CGRect(x: 2, y: 2, width: 16+oneThird, height: 20-oneThird),
            ])
    }

    func testConfig() {
        var configCount = 0
        let insetLayout = InsetLayout(
            insets: UIEdgeInsets(top: 2, left: 4, bottom: 8, right: 16),
            sublayout: LabelLayout(text: "Hi", font: UIFont.helvetica()),
            config: { view in
                configCount += 1
            }
        )
        let insetView = insetLayout.arrangement().makeViews()
        XCTAssertNotNil(insetView)
        XCTAssertEqual(configCount, 1)
    }
}
