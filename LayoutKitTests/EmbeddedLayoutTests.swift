// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
@testable import LayoutKit

class EmbeddedLayoutTests: XCTestCase {

    private let rootView = View()
    private let singleViewArrangement = SizeLayout(minSize: .zero, config: { _ in }).arrangement()

    override func setUp() {
        super.setUp()

        rootView.subviews.forEach { $0.removeFromSuperview() }
    }

    func testKeepsSubviewsForEmbeddedLayoutWithReuseId() {
        var parentView: View?
        let parentLayout = SizeLayout(minSize: .zero, viewReuseId: "test", config: { view in
            parentView = view
        })

        // Create Parent Layout
        parentLayout.arrangement().makeViews(in: rootView)

        // Create Embedded Layout
        XCTAssertNotNil(parentView)
        singleViewArrangement.makeViews(in: parentView)

        // Re-create Parent Layout
        parentLayout.arrangement().makeViews(in: rootView)

        XCTAssertEqual(parentView?.subviews.count, 1)
    }

    func testRemovesSubviewsForEmbeddedLayoutWithoutReuseId() {
        var parentView: View?
        let parentLayout = SizeLayout(minSize: .zero, config: { view in
            parentView = view
        })

        // Create Parent Layout
        parentLayout.arrangement().makeViews(in: rootView)

        // Create Embedded Layout
        XCTAssertNotNil(parentView)
        singleViewArrangement.makeViews(in: parentView)
        let originalParentView = parentView

        // Re-create Parent Layout
        parentLayout.arrangement().makeViews(in: rootView)

        XCTAssertNotEqual(originalParentView, parentView)
        XCTAssertEqual(parentView?.subviews.count, 0)
    }

    func testEmbeddedLayoutsAreRemoved() {
        var originalHostView: View?
        SizeLayout(
            minSize: .zero,
            viewReuseId: "foo",
            sublayout: SizeLayout(minSize: .zero, viewReuseId: "bar", config: { view in
                originalHostView = view
                self.singleViewArrangement.makeViews(in: view)
            }),
            config: { _ in }).arrangement().makeViews(in: rootView)

        XCTAssertEqual(rootView.subviews.count, 1)
        XCTAssertNotNil(originalHostView)
        XCTAssertEqual(originalHostView?.subviews.count, 1)

        var updatedHostView: View?
        SizeLayout(
            minSize: .zero,
            viewReuseId: "foo",
            sublayout: SizeLayout(minSize: .zero, viewReuseId: "baz", config: { view in
                updatedHostView = view
            }),
            config: { _ in }).arrangement().makeViews(in: rootView)

        XCTAssertEqual(rootView.subviews.count, 1)
        XCTAssertNotNil(updatedHostView)
        XCTAssertEqual(updatedHostView?.subviews.count, 0)
        XCTAssertNotEqual(originalHostView, updatedHostView)
    }
}
