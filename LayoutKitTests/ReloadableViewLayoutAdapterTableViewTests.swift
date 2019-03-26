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

    #if os(tvOS)
    // tvOS adds padding around UITableViewCells
    // http://stackoverflow.com/questions/33364236/why-is-there-a-space-between-the-cells-in-my-uitableview
    let itemSpacing: CGFloat = 14
    let itemWidthInset: CGFloat = 16
    #else
    let itemSpacing: CGFloat = 0
    let itemWidthInset: CGFloat = 0
    #endif
    
    init() {
        let frame = CGRect(x: 0, y: 0, width: 320, height: 1000)
        super.init(frame: frame, style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func reloadData() {
        super.reloadData()
        reloadDataCount += 1
    }

    fileprivate override func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        super.insertRows(at: indexPaths, with: animation)
        batchUpdates.insertItems.append(contentsOf: indexPaths)
    }

    fileprivate override func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        super.deleteRows(at: indexPaths, with: animation)
        batchUpdates.deleteItems.append(contentsOf: indexPaths)
    }

    fileprivate override func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        super.reloadRows(at: indexPaths, with: animation)
        batchUpdates.reloadItems.append(contentsOf: indexPaths)
    }

    fileprivate override func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        super.moveRow(at: indexPath, to: newIndexPath)
        batchUpdates.moveItems.append(ItemMove(from: indexPath, to: newIndexPath))
    }

    fileprivate override func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        super.insertSections(sections, with: animation)
        batchUpdates.insertSections.formUnion(sections)
    }

    fileprivate override func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        super.reloadSections(sections, with: animation)
        batchUpdates.reloadSections.formUnion(sections)
    }

    fileprivate override func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        super.deleteSections(sections, with: animation)
        batchUpdates.deleteSections.formUnion(sections)
    }

    fileprivate override func moveSection(_ section: Int, toSection newSection: Int) {
        super.moveSection(section, toSection: newSection)
        batchUpdates.moveSections.append(SectionMove(from: section, to: newSection))
    }

    fileprivate func resetTestCounts() {
        reloadDataCount = 0
        batchUpdates = BatchUpdates()
    }

    fileprivate func verifyHeader(_ section: Int, text: String?, frame: CGRect?, file: StaticString, line: UInt) {
        verify(rectForHeader(inSection:), section: section, text: text, frame: frame, file: file, line: line)
    }

    fileprivate func verifyFooter(_ section: Int, text: String?, frame: CGRect?, file: StaticString, line: UInt) {
        verify(rectForFooter(inSection:), section: section, text: text, frame: frame, file: file, line: line)
    }

    private func verify(_ getter: (Int) -> CGRect, section: Int, text: String?, frame: CGRect?, file: StaticString, line: UInt) {
        let headerFrame = getter(section)
        if let frame = frame {
            XCTAssertEqual(headerFrame, frame, file: file, line: line)
        } else {
            XCTAssertEqual(headerFrame.size, CGSize(width: bounds.width, height: 0), file: file, line: line)
        }
    }

    fileprivate func verifyVisibleItem(_ text: String, frame: CGRect, file: StaticString, line: UInt) {
        let items = visibleCells.filter { cell -> Bool in
            guard let label = cell.contentView.subviews.first as? UILabel else {
                return false
            }
            return label.text == text
        }
        XCTAssertEqual(items.only?.frame, frame, file: file, line: line)
    }
}
