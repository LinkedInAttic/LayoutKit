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

    func testRecycledViewWithoutPurgingIndirectSubviews() {
        let root = View()
        let headerView = View()
        headerView.isLayoutKitView = true
        root.addSubview(headerView)
        let titleView = View(viewReuseId: "1")
        root.addSubview(titleView)
        let collectionView = View()
        let cellView = View()
        cellView.isLayoutKitView = true
        root.addSubview(collectionView)
        collectionView.addSubview(cellView)

        let recycler = ViewRecycler(rootView: root)
        let _ = recycler.makeOrRecycleView(havingViewReuseId: nil, viewProvider: {
            return View()
        })

        recycler.purgeViews()
        XCTAssertNil(headerView.superview)
        XCTAssertNil(titleView.superview)
        XCTAssertNotNil(cellView.superview)
    }

    #if os(iOS) || os(tvOS)
    /// Test that a reused view's frame shouldn't change if its transform and layer anchor point
    /// get set to the default values.
    /// - SeeAlso: https://github.com/linkedin/LayoutKit/pull/231
    func testReusedViewFrame() {
        let root = View()
        let one = View(viewReuseId: "1")
        one.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        one.layer.anchorPoint = CGPoint(x: 0, y: 0)
        let frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        one.frame = frame
        root.addSubview(one)

        let recycler = ViewRecycler(rootView: root)
        let v: View? = recycler.makeOrRecycleView(havingViewReuseId: "1", viewProvider: {
            XCTFail("view should have been recycled")
            return View()
        })
        XCTAssertTrue(v?.transform == CGAffineTransform.identity)
        XCTAssertTrue(v?.layer.anchorPoint == CGPoint(x: 0.5, y: 0.5))

        one.frame = frame
        one.transform = CGAffineTransform.identity
        one.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        XCTAssertTrue(one.frame == frame)
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
    #endif
}

extension View {
    convenience init(viewReuseId: String) {
        self.init(frame: .zero)
        self.viewReuseId = viewReuseId
        // All views created in the ViewRecycler should be marked as LayoutKitView.
        self.isLayoutKitView = true
    }
}
