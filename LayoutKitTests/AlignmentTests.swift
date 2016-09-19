// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
import LayoutKit

class AlignmentTests: XCTestCase {

    func testAspectFit() {
        let sdtvDisplayedOnHDTV = Alignment.aspectFit.position(size: CGSize(width: 4, height: 3), in: CGRect(x: 100, y: 200, width: 16, height: 9))
        XCTAssertEqual(sdtvDisplayedOnHDTV, CGRect(x: 102, y: 200, width: 12, height: 9))

        let hdtvDisplayedOnSDTV = Alignment.aspectFit.position(size: CGSize(width: 16, height: 9), in: CGRect(x: 100, y: 200, width: 4, height: 3))
        let expressionThatIsTooComplicatedForSwiftCompiler: CGFloat = (3 - 4*9/16.0)/2.0
        XCTAssertEqual(hdtvDisplayedOnSDTV, CGRect(x: 100, y: 200 + expressionThatIsTooComplicatedForSwiftCompiler, width: 4, height: 4*9/16.0))
    }
}
