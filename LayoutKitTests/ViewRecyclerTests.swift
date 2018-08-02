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
        zero.layoutKitRootView = nil    // default
        root.addSubview(zero)

        let recycler = ViewRecycler(rootView: root)
        let expectedView = View()
        let v: View? = recycler.makeOrRecycleView(havingViewReuseId: nil, viewProvider: {
            return expectedView
        })
        XCTAssertEqual(v, expectedView)

        recycler.purgeViews()
        XCTAssertNotNil(zero.superview, "`zero` should not be removed because `layoutKitRootView` is nil")
    }

    func testNilIdNotRecycledAndRemoved() {
        let root = View()
        let zero = View()
        zero.layoutKitRootView = root
        root.addSubview(zero)

        let recycler = ViewRecycler(rootView: root)
        let expectedView = View()
        let v: View? = recycler.makeOrRecycleView(havingViewReuseId: nil, viewProvider: {
            return expectedView
        })
        XCTAssertEqual(v, expectedView)

        recycler.purgeViews()
        XCTAssertNil(zero.superview, "`zero` should be removed because `layoutKitRootView` is set")
    }

    func testNonNilIdRecycled() {
        let root = View()
        let one = View(viewReuseId: "1")
        root.addSubview(one)
        one.layoutKitRootView = root

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

    /// Create a hierarchy (rootOne > middleView > rootTwo > someSubview) where rootOne and rootTwo
    /// are LayoutKit root nodes. Then ensure that purging rootOne doesn't remove someSubview.
    func testDoesntPurgeOtherNodesSubviews() {
        let rootOne = View(viewReuseId: "1")
        let middleView = View()
        let rootTwo = View(viewReuseId: "2")
        let someSubview = View()

        rootOne.addSubview(middleView)
        middleView.addSubview(rootTwo)
        rootTwo.addSubview(someSubview)

        let recycler = ViewRecycler(rootView: rootOne)
        _ = recycler.makeOrRecycleView(havingViewReuseId: "3") {
            return middleView
        }

        let recycler2 = ViewRecycler(rootView: rootTwo)
        _ = recycler2.makeOrRecycleView(havingViewReuseId: "4") {
            return someSubview
        }

        recycler.purgeViews()
        XCTAssertEqual(someSubview.superview, rootTwo)
    }

    /// Create a hierarchy (rootOne > middleView > rootTwo > someSubview) where rootOne and rootTwo
    /// are LayoutKit root nodes. Then ensure that rootOne can't recycle someSubview.
    func testDoesntRecycleOtherNodesViews() {
        let rootOne = View(viewReuseId: "1")
        let middleView = View(viewReuseId: "2")
        let rootTwo = View(viewReuseId: "3")
        let someSubview = View(viewReuseId: "4")

        rootOne.addSubview(middleView)
        middleView.layoutKitRootView = rootOne

        middleView.addSubview(rootTwo)

        rootTwo.addSubview(someSubview)
        someSubview.layoutKitRootView = rootTwo

        let recycler = ViewRecycler(rootView: rootOne)
        let aDifferentView = View()
        let v: View? = recycler.makeOrRecycleView(havingViewReuseId: "4") {
            return aDifferentView
        }
        XCTAssertEqual(v, aDifferentView)
    }

    /// Test for safe subview-purge in composite view e.g. UIButton.
    /// - SeeAlso: https://github.com/linkedin/LayoutKit/pull/85
    #if os(iOS) || os(tvOS)
    func testRecycledCompositeView() {
        let root = View()
        let button = UIButton(viewReuseId: "1")
        root.addSubview(button)
        button.layoutKitRootView = root

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
    #endif
}

extension View {
    convenience init(viewReuseId: String) {
        self.init(frame: .zero)
        self.viewReuseId = viewReuseId
    }
}
