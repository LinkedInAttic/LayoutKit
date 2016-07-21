// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
@testable import LayoutKit

class ReloadableViewLayoutAdapterTableViewTests: ReloadableViewLayoutAdapterTestCase {

    func testTableViewReloadSync() {
        verifyReloadSync(TestTableView())
    }

    func testTableViewReloadBatchUpdatesSync() {
        verifyReloadBatchUpdatesSync(TestTableView())
    }

    func testTableViewReloadSyncCancelsPreviousLayout() {
        verifyReloadSyncCancelsPreviousLayout(TestTableView())
    }

    func testTableViewReloadAsync() {
        verifyReloadAsync(TestTableView())
    }

    func testTableViewReloadBatchUpdatesAsync() {
        verifyReloadBatchUpdatesAsync(TestTableView())
    }

    func testTableViewReloadAsyncCancelsPreviousLayout() {
        verifyReloadAsyncCancelsPreviousLayout(TestTableView())
    }

    func testTableViewReloadAsyncCancelledOnViewDeinit() {
        verifyReloadAsyncCancelledOnViewDeinit(TestTableView())
    }
}

private class TestTableView: LayoutAdapterTableView, TestableReloadableView {
    var reloadDataCount = 0
    var batchUpdates = BatchUpdates()

    init() {
        let frame = CGRect(x: 0, y: 0, width: 320, height: 1000)
        super.init(frame: frame, style: .Plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func reloadData() {
        super.reloadData()
        reloadDataCount += 1
    }

    private override func insertRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        super.insertRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        batchUpdates.insertItemsAtIndexPaths.appendContentsOf(indexPaths)
    }

    private override func deleteRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        super.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        batchUpdates.deleteItemsAtIndexPaths.appendContentsOf(indexPaths)
    }

    private override func moveRowAtIndexPath(indexPath: NSIndexPath, toIndexPath newIndexPath: NSIndexPath) {
        super.moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath)
        batchUpdates.moveItemsAtIndexPaths.append(ItemMove(from: indexPath, to: newIndexPath))
    }

    private override func insertSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        super.insertSections(sections, withRowAnimation: animation)
        batchUpdates.insertSections.addIndexes(sections)
    }

    private override func deleteSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        super.deleteSections(sections, withRowAnimation: animation)
        batchUpdates.deleteSections.addIndexes(sections)
    }

    private override func moveSection(section: Int, toSection newSection: Int) {
        super.moveSection(section, toSection: newSection)
        batchUpdates.moveSections.append(SectionMove(from: section, to: newSection))
    }

    private func resetTestCounts() {
        reloadDataCount = 0
        batchUpdates = BatchUpdates()
    }

    private func verifyHeader(section section: Int, text: String?, frame: CGRect?, line: UInt) {
        verify(rectForHeaderInSection, section: section, text: text, frame: frame, line: line)
    }

    private func verifyFooter(section section: Int, text: String?, frame: CGRect?, line: UInt) {
        verify(rectForFooterInSection, section: section, text: text, frame: frame, line: line)
    }

    private func verify(getter: Int -> CGRect, section: Int, text: String?, frame: CGRect?, line: UInt) {
        let headerFrame = getter(section)
        if let frame = frame {
            XCTAssertEqual(headerFrame, frame, line: line)
        } else {
            XCTAssertEqual(headerFrame.size, CGSize(width: bounds.width, height: 0), line: line)
        }
    }

    private func verifyVisibleItem(text text: String, frame: CGRect, line: UInt) {
        let items = visibleCells.filter { cell -> Bool in
            guard let label = cell.contentView.subviews.first as? UILabel else {
                return false
            }
            return label.text == text
        }
        XCTAssertEqual(items.only?.frame, frame, line: line)
    }
}