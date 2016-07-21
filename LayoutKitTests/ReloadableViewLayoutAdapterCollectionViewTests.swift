// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
@testable import LayoutKit

class ReloadableViewLayoutAdapterCollectionViewTests: ReloadableViewLayoutAdapterTestCase {

    func testCollectionViewReloadSync() {
        verifyReloadSync(TestCollectionView())
    }

    func testCollectionViewReloadBatchUpdatesSync() {
        verifyReloadBatchUpdatesSync(TestCollectionView())
    }

    func testCollectionViewReloadSyncCancelsPreviousLayout() {
        verifyReloadSyncCancelsPreviousLayout(TestCollectionView())
    }

    func testCollectionViewReloadAsync() {
        verifyReloadAsync(TestCollectionView())
    }

    func testCollectionViewReloadBatchUpdatesAsync() {
        verifyReloadBatchUpdatesAsync(TestCollectionView())
    }

    func testCollectionViewReloadAsyncCancelsPreviousLayout() {
        verifyReloadAsyncCancelsPreviousLayout(TestCollectionView())
    }

    func testCollectionViewReloadAsyncCancelledOnViewDeinit() {
        verifyReloadAsyncCancelledOnViewDeinit(TestCollectionView())
    }
}

private class TestCollectionView: LayoutAdapterCollectionView, TestableReloadableView {

    var reloadDataCount = 0
    var batchUpdates = BatchUpdates()

    init() {
        let frame = CGRect(x: 0, y: 0, width: 320, height: 1000)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        super.init(frame: frame, collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func reloadData() {
        super.reloadData()
        reloadDataCount += 1
    }

    private override func insertItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        super.insertItemsAtIndexPaths(indexPaths)
        batchUpdates.insertItemsAtIndexPaths.appendContentsOf(indexPaths)
    }

    private override func deleteItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        super.deleteItemsAtIndexPaths(indexPaths)
        batchUpdates.deleteItemsAtIndexPaths.appendContentsOf(indexPaths)
    }

    private override func moveItemAtIndexPath(indexPath: NSIndexPath, toIndexPath newIndexPath: NSIndexPath) {
        super.moveItemAtIndexPath(indexPath, toIndexPath: newIndexPath)
        batchUpdates.moveItemsAtIndexPaths.append(ItemMove(from: indexPath, to: newIndexPath))
    }

    private override func insertSections(sections: NSIndexSet) {
        super.insertSections(sections)
        batchUpdates.insertSections.addIndexes(sections)
    }

    private override func deleteSections(sections: NSIndexSet) {
        super.deleteSections(sections)
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
        verifySupplementaryView(kind: UICollectionElementKindSectionHeader, section: section, text: text, frame: frame, line: line)
    }

    private func verifyFooter(section section: Int, text: String?, frame: CGRect?, line: UInt) {
        verifySupplementaryView(kind: UICollectionElementKindSectionFooter, section: section, text: text, frame: frame, line: line)
    }

    private func verifySupplementaryView(kind kind: String, section: Int, text: String?, frame: CGRect?, line: UInt) {
        let indexPath = NSIndexPath(forItem: 0, inSection: section)
        let attributes = layoutAttributesForSupplementaryElementOfKind(kind, atIndexPath: indexPath)
        if let frame = frame {
            XCTAssertEqual(attributes?.frame, frame, line: line)
        } else {
            XCTAssertEqual(attributes?.frame.size, CGSizeZero, line: line)
        }

        if #available(iOS 9.0, *) {
            func labelText(reusableView: UICollectionReusableView?) -> String? {
                guard let label = reusableView?.subviews.first as? UILabel else {
                    return nil
                }
                return label.text
            }

            let supplementaryViewTexts = visibleSupplementaryViewsOfKind(kind).flatMap(labelText)
            if let text = text {
                XCTAssertTrue(supplementaryViewTexts.contains(text))
            }
        }
    }

    private func verifyVisibleItem(text text: String, frame: CGRect, line: UInt) {
        let items = visibleCells().filter { cell -> Bool in
            guard let label = cell.contentView.subviews.first as? UILabel else {
                return false
            }
            return label.text == text
        }
        XCTAssertEqual(items.only?.frame, frame, line: line)
    }
}
