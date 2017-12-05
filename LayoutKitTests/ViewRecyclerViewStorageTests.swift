// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
@testable import LayoutKit

class ViewRecyclerViewStorageTests: XCTestCase {

    func testViewWithReuseId_viewWithReuseIdExists_shouldReturnView() {
        let view1 = View(viewReuseId: "1")
        let view2 = View(viewReuseId: "2")
        let storage = ViewRecyclerViewStorage()
        storage.add(view: view1)
        storage.add(view: view2)

        let v = storage.popView(withReuseId: "2")
        XCTAssertEqual(view2, v)
    }

    func testViewWithReuseId_viewWithReuseIdExists_shouldNotBeAbleToPopSameViewTwice() {
        let view1 = View(viewReuseId: "1")
        let view2 = View(viewReuseId: "2")
        let storage = ViewRecyclerViewStorage()
        storage.add(view: view1)
        storage.add(view: view2)

        XCTAssertEqual(storage.popView(withReuseId: "2"), view2)
        XCTAssertNil(storage.popView(withReuseId: "2"), "View should already been popped")
    }

    func testViewWithReuseGroup_viewWithReuseGroupMultipleMatches_shouldKeepReturningViewsMatchingGroup() {
        let view1 = View(viewReuseId: "1", viewReuseGroup: "group1")
        let view2 = View(viewReuseId: "2", viewReuseGroup: "group1")
        let storage = ViewRecyclerViewStorage()
        storage.add(view: view1)
        storage.add(view: view2)

        XCTAssertEqual(storage.popView(withReuseGroup: "group1"), view1)
        XCTAssertEqual(storage.popView(withReuseGroup: "group1"), view2)
        XCTAssertNil(storage.popView(withReuseGroup: "group1"))
    }

    func testViewWithReuseGroup_viewWithReuseGroupMatch_shouldNotBeAbleToRetrieveThatViewAgain() {
        let view1 = View(viewReuseId: "1", viewReuseGroup: "group1")
        let view2 = View(viewReuseId: "2", viewReuseGroup: "group1")
        let storage = ViewRecyclerViewStorage()
        storage.add(view: view1)
        storage.add(view: view2)

        XCTAssertEqual(storage.popView(withReuseGroup: "group1"), view1)
        XCTAssertNil(storage.popView(withReuseId: "1"), "View should already been popped")
    }

    func testRemoveView() {
        let view1 = View(viewReuseId: "1")
        let view2 = View(viewReuseId: "2")
        let view3 = View(viewReuseId: "3", viewReuseGroup: "group")
        let storage = ViewRecyclerViewStorage()
        storage.add(view: view1)
        storage.add(view: view2)
        storage.add(view: view3)

        storage.remove(view: view2)
        XCTAssertNil(storage.popView(withReuseId: "2"), "View should have been removed")
    }

    func testRemoveAll_viewReuseIds() {
        let view1 = View(viewReuseId: "1")
        let view2 = View(viewReuseId: "2")
        let view3 = View(viewReuseId: "3", viewReuseGroup: "group")
        let storage = ViewRecyclerViewStorage()
        storage.add(view: view1)
        storage.add(view: view2)
        storage.add(view: view3)

        storage.removeAll()

        XCTAssertNil(storage.popView(withReuseId: "1"), "View should have been removed")
        XCTAssertNil(storage.popView(withReuseId: "2"), "View should have been removed")
        XCTAssertNil(storage.popView(withReuseGroup: "group"), "View should have been removed")
    }
}
