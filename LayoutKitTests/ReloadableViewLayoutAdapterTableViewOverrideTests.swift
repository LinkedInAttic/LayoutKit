// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
@testable import LayoutKit

class ReloadableViewLayoutAdapterTableViewOverrideTests: XCTestCase {

    var reloadableViewLayoutAdapter: MockReloadableTableViewAdapter!
    var tableView: UITableView!

    override func setUp() {
        tableView = UITableView()
        reloadableViewLayoutAdapter = MockReloadableTableViewAdapter(reloadableView: tableView)
    }

    func testCellForRowAt_Called_ShouldCallMock() {
        _ = reloadableViewLayoutAdapter.tableView(tableView, cellForRowAt: IndexPath(item: 0, section: 0))

        XCTAssert(reloadableViewLayoutAdapter.tableViewCellForRowAtCallCount == 1)
    }


    func testNumberOfRowsInSection_Called_ShouldCallMock() {
        _ = reloadableViewLayoutAdapter.tableView(tableView, numberOfRowsInSection: 0)

        XCTAssert(reloadableViewLayoutAdapter.tableViewNumberOfRowsInSectionCallCount == 1)
    }

    func testHeightForFooterInSection_Called_ShouldCallMock() {
        _ = reloadableViewLayoutAdapter.tableView(tableView, heightForFooterInSection: 0)

        XCTAssert(reloadableViewLayoutAdapter.tableViewHeightForFooterInSectionCallCount == 1)
    }
}

class MockReloadableTableViewAdapter: ReloadableViewLayoutAdapter {

    var tableViewHeightForFooterInSectionCallCount = 0

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        tableViewHeightForFooterInSectionCallCount += 1

        return 0
    }

    var tableViewNumberOfRowsInSectionCallCount = 0

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewNumberOfRowsInSectionCallCount += 1

        return 0
    }

    var tableViewCellForRowAtCallCount = 0

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableViewCellForRowAtCallCount += 1

        return UITableViewCell()
    }
}
