// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
@testable import LayoutKit

class ViewRecyclerTests: XCTestCase {

    func testNilIdNotRecycledAndNotRemoved() {
        let root = View()
        let zero = View()
        zero.isLayoutKitView = false    // default
        root.addSubview(zero)

        let recycler = ViewRecycler(rootView: root)
        let expectedView = View()
        let v: View? = recycler.makeOrRecycleView(havingViewReuseId: nil, viewProvider: {
            return expectedView
        })
        XCTAssertEqual(v, expectedView)

        recycler.purgeViews()
        XCTAssertNotNil(zero.superview, "`zero` should not be removed because `isLayoutKitView` is false")
    }

    func testNilIdNotRecycledAndRemoved() {
        let root = View()
        let zero = View()
        zero.isLayoutKitView = true // requires this flag to be removed by `ViewRecycler`
        root.addSubview(zero)

        let recycler = ViewRecycler(rootView: root)
        let expectedView = View()
        let v: View? = recycler.makeOrRecycleView(havingViewReuseId: nil, viewProvider: {
            return expectedView
        })
        XCTAssertEqual(v, expectedView)

        recycler.purgeViews()
        XCTAssertNil(zero.superview, "`zero` should be removed because `isLayoutKitView` is true")
    }

    func testNonNilIdRecycled() {
        let root = View()
        let one = View(viewReuseId: "1")
        root.addSubview(one)

        let recycler = ViewRecycler(rootView: root)
        let v: View? = recycler.makeOrRecycleView(havingViewReuseId: "1", viewProvider: {
            XCTFail("view should have been recycled")
            return View()
        })
        XCTAssertEqual(v, one)

        recycler.purgeViews()
        XCTAssertNotNil(one.superview)
    }

    func testRecycledViewWithViewReuseId() {
        let root = View()
        let one = View(viewReuseId: "1")
        root.addSubview(one)

        let recycler = ViewRecycler(rootView: root)
        let v: View? = recycler.makeOrRecycleView(havingViewReuseId: nil, viewProvider: {
            return one
        })
        XCTAssertEqual(v, one)
        
        recycler.purgeViews()
        XCTAssertNotNil(one.superview)
    }

    func testRecycledViewWithoutViewReuseId() {
        let root = View()
        let one = View()
        root.addSubview(one)

        let recycler = ViewRecycler(rootView: root)
        let v: View? = recycler.makeOrRecycleView(havingViewReuseId: nil, viewProvider: {
            return one
        })
        XCTAssertEqual(v, one)

        recycler.purgeViews()
        XCTAssertNotNil(one.superview)
    }

    /// Test for safe subview-purge in composite view e.g. UIButton.
    /// - SeeAlso: https://github.com/linkedin/LayoutKit/pull/85
    func testRecycledCompositeView() {
        let root = View()
        let button = UIButton(viewReuseId: "1")
        root.addSubview(button)

        button.setTitle("dummy", for: .normal)
        button.layoutIfNeeded()
        XCTAssertEqual(button.subviews.count, 1, "UIButton should have 1 subview because `title` is set")

        let recycler = ViewRecycler(rootView: root)
        let v: View? = recycler.makeOrRecycleView(havingViewReuseId: "1", viewProvider: {
            XCTFail("button should have been recycled")
            return View()
        })
        XCTAssertEqual(v, button)

        recycler.purgeViews()

        XCTAssertNotNil(button.superview)
        XCTAssertEqual(button.subviews.count, 1, "UIButton's subviews should not be removed by `recycler`")
    }
}

extension View {
    convenience init(viewReuseId: String) {
        self.init(frame: .zero)
        self.viewReuseId = viewReuseId
    }
}
