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
    let itemSpacing: CGFloat = 0
    let itemWidthInset: CGFloat = 0

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

    fileprivate override func insertItems(at indexPaths: [IndexPath]) {
        super.insertItems(at: indexPaths)
        batchUpdates.insertItems.append(contentsOf: indexPaths)
    }

    fileprivate override func deleteItems(at indexPaths: [IndexPath]) {
        super.deleteItems(at: indexPaths)
        batchUpdates.deleteItems.append(contentsOf: indexPaths)
    }

    fileprivate override func reloadItems(at indexPaths: [IndexPath]) {
        super.reloadItems(at: indexPaths)
        batchUpdates.reloadItems.append(contentsOf: indexPaths)
    }

    fileprivate override func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        super.moveItem(at: indexPath, to: newIndexPath)
        batchUpdates.moveItems.append(ItemMove(from: indexPath, to: newIndexPath))
    }

    fileprivate override func insertSections(_ sections: IndexSet) {
        super.insertSections(sections)
        batchUpdates.insertSections.formUnion(sections)
    }

    fileprivate override func deleteSections(_ sections: IndexSet) {
        super.deleteSections(sections)
        batchUpdates.deleteSections.formUnion(sections)
    }

    fileprivate override func reloadSections(_ sections: IndexSet) {
        super.reloadSections(sections)
        batchUpdates.reloadSections.formUnion(sections)
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
        verifySupplementaryView(UICollectionView.elementKindSectionHeader, section: section, text: text, frame: frame, file: file, line: line)
    }

    fileprivate func verifyFooter(_ section: Int, text: String?, frame: CGRect?, file: StaticString, line: UInt) {
        verifySupplementaryView(UICollectionView.elementKindSectionFooter, section: section, text: text, frame: frame, file: file, line: line)
    }

    private func verifySupplementaryView(_ kind: String, section: Int, text: String?, frame: CGRect?, file: StaticString, line: UInt) {
        let indexPath = IndexPath(item: 0, section: section)
        let attributes = layoutAttributesForSupplementaryElement(ofKind: kind, at: indexPath)
        if let frame = frame {
            XCTAssertEqual(attributes?.frame, frame, file: file, line: line)
        } else {
            XCTAssertEqual(attributes?.frame.size, .zero, file: file, line: line)
        }

        if #available(iOS 9.0, *) {
            func labelText(_ reusableView: UICollectionReusableView?) -> String? {
                guard let label = reusableView?.subviews.first as? UILabel else {
                    return nil
                }
                return label.text
            }

            let supplementaryViewTexts = visibleSupplementaryViews(ofKind: kind).compactMap(labelText)
            if let text = text {
                XCTAssertTrue(supplementaryViewTexts.contains(text), file: file, line: line)
            }
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
