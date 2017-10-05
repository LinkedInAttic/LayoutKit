// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
@testable import LayoutKit

class ReloadableViewLayoutAdapterTestCase: XCTestCase {

    /// Loads two layouts synchronously one after the other and verifies the layout are correct.
    func verifyReloadSync(_ view: TestableReloadableView) {

        // Test loading layout one while the collection is empty.
        do {
            var completed = false
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: true, layoutProvider: layoutProviderOne, completion: {
                completed = true
            })
            XCTAssertTrue(completed)

            // Need to trigger a layout on UICollectionViews so we can test the results.
            (view as? UICollectionView)?.layoutIfNeeded()

            verifyLayoutOne(view)

            // Expect reload since this is synchronous.
            XCTAssertEqual(view.batchUpdates.insertSections.count, 0)
            XCTAssertEqual(view.batchUpdates.insertItems.count, 0)
            XCTAssertEqual(view.reloadDataCount, 1)
        }

        view.resetTestCounts()

        // Test loading layout two while the collection is not empty.
        do {
            var completed = false
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: true, layoutProvider: layoutProviderTwo, completion: {
                completed = true
            })
            XCTAssertTrue(completed)

            // Need to trigger a layout on UICollectionViews so we can test the results.
            (view as? UICollectionView)?.layoutIfNeeded()

            verifyLayoutTwo(view)

            // Expect reload since this is synchronous.
            XCTAssertEqual(view.batchUpdates.insertSections.count, 0)
            XCTAssertEqual(view.batchUpdates.insertItems.count, 0)
            XCTAssertEqual(view.batchUpdates.reloadItems.count, 0)
            XCTAssertEqual(view.batchUpdates.reloadSections.count, 0)
            XCTAssertEqual(view.reloadDataCount, 1)
        }
    }

    /// Verifies that batch updates work when layouts are loaded synchronously.
    func verifyReloadBatchUpdatesSync(_ view: TestableReloadableView) {

        // Setup initial layout.
        view.layoutAdapter.reload(width: view.bounds.width, synchronous: true, layoutProvider: layoutProviderOne)

        // Need to trigger a layout on UICollectionViews so we can test the results.
        (view as? UICollectionView)?.layoutIfNeeded()

        view.resetTestCounts()

        // Test batch update to layout two.
        do {
            let completionExpectation = expectation(description: "completion")
            let batchUpdates = batchUpdatesForLayoutTwo()
            view.layoutAdapter.reload(
                width: view.bounds.width,
                synchronous: true,
                batchUpdates: batchUpdates,
                layoutProvider: layoutProviderTwo,
                completion: {
                    completionExpectation.fulfill()
                }
            )
            waitForExpectations(timeout: 10, handler: nil)

            // Need to trigger a layout on UICollectionViews so we can test the results.
            (view as? UICollectionView)?.layoutIfNeeded()

            verifyLayoutTwo(view)

            // Expect batch update.
            XCTAssertEqual(view.batchUpdates.insertSections.count, 1)
            XCTAssertEqual(view.batchUpdates.insertItems.count, 1)
            XCTAssertEqual(view.batchUpdates.reloadItems.count, 1)
            XCTAssertEqual(view.batchUpdates.reloadSections.count, 1)
            XCTAssertEqual(view.reloadDataCount, 0)
        }

        view.resetTestCounts()

        // Test batch update to layout three.
        do {
            let completionExpectation = expectation(description: "completion")
            let batchUpdates = batchUpdatesForLayoutThree()
            view.layoutAdapter.reload(
                width: view.bounds.width,
                synchronous: true,
                batchUpdates: batchUpdates,
                layoutProvider: layoutProviderThree,
                completion: {
                    completionExpectation.fulfill()
                }
            )
            waitForExpectations(timeout: 10, handler: nil)

            // Need to trigger a layout on UICollectionViews so we can test the results.
            (view as? UICollectionView)?.layoutIfNeeded()

            verifyLayoutThree(view, batchUpdate: true)
        }
    }

    /// Loads two layouts asynchronously one after the other and verifies the layouts are correct.
    func verifyReloadAsync(_ view: TestableReloadableView) {
        // Test loading layout one while the collection is empty.
        do {
            let completionExpectation = expectation(description: "completion")
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: false, layoutProvider: layoutProviderOne, completion: {
                completionExpectation.fulfill()
            })

            waitForExpectations(timeout: 10, handler: nil)
            verifyLayoutOne(view)

            // Expect items and sections to be inserted incrementally (except first reload).
            XCTAssertEqual(view.reloadDataCount, 1)
            XCTAssertEqual(view.batchUpdates.insertItems.count, 3)
            XCTAssertEqual(view.batchUpdates.insertSections.count, 1)
        }

        view.resetTestCounts()

        // Test loading layout two while the collection is not empty.
        do {
            let completionExpectation = expectation(description: "completion")
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: false, layoutProvider: layoutProviderTwo, completion: {
                completionExpectation.fulfill()
            })

            waitForExpectations(timeout: 10, handler: nil)
            verifyLayoutTwo(view)

            // Expect reload since the view already has content.
            XCTAssertEqual(view.reloadDataCount, 1)
            XCTAssertEqual(view.batchUpdates.insertItems.count, 0)
            XCTAssertEqual(view.batchUpdates.insertSections.count, 0)
        }
    }

    /// Verifies that batch updates work when layouts are loaded asynchronously.
    func verifyReloadBatchUpdatesAsync(_ view: TestableReloadableView) {
        // Setup initial layout.
        view.layoutAdapter.reload(width: view.bounds.width, synchronous: true, layoutProvider: layoutProviderOne)

        // Need to trigger a layout on UICollectionViews so we can test the results.
        (view as? UICollectionView)?.layoutIfNeeded()

        view.resetTestCounts()

        // Test batch update to layout two.
        do {
            let completionExpectation = expectation(description: "completion")
            let batchUpdates = batchUpdatesForLayoutTwo()
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: false, batchUpdates: batchUpdates, layoutProvider: layoutProviderTwo, completion: {
                completionExpectation.fulfill()
            })

            waitForExpectations(timeout: 10, handler: nil)
            verifyLayoutTwo(view)

            // Expect batch update.
            XCTAssertEqual(view.batchUpdates.insertSections.count, 1)
            XCTAssertEqual(view.batchUpdates.insertItems.count, 1)
            XCTAssertEqual(view.reloadDataCount, 0)
        }


        // Test batch update to layout two.
        do {
            let completionExpectation = expectation(description: "completion")
            let batchUpdates = batchUpdatesForLayoutThree()
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: false, batchUpdates: batchUpdates, layoutProvider: layoutProviderThree, completion: {
                completionExpectation.fulfill()
            })

            waitForExpectations(timeout: 10, handler: nil)
            verifyLayoutThree(view, batchUpdate: true)
        }
    }

    /// Verifies that all asynchronous layouts are cancelled when a synchronous layout happens.
    func verifyReloadSyncCancelsPreviousLayout(_ view: TestableReloadableView) {
        // Start some asynchronous layouts.
        for i in 0..<5 {
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: false, layoutProvider: layoutProviderOne, completion: {
                XCTFail("layout \(i) should have been cancelled")
            })
        }

        // Do a synchronous layout.
        view.layoutAdapter.reload(width: view.bounds.width, synchronous: true, layoutProvider: layoutProviderTwo)

        // Verify that only the synchronous layout happened.
        let verify = {
            self.verifyLayoutTwo(view)

            // Expect reload since this is synchronous.
            XCTAssertEqual(view.reloadDataCount, 1)
            XCTAssertEqual(view.batchUpdates.insertItems.count, 0)
            XCTAssertEqual(view.batchUpdates.insertSections.count, 0)
        }

        verify()
        waitForBackgroundOperations(view.layoutAdapter)
        verify()
    }

    private func waitForBackgroundOperations(_ adapter: ReloadableViewLayoutAdapter) {
        let expectation = self.expectation(description: "background layout operations")
        adapter.backgroundLayoutQueue.addOperation {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    /// Verifies that all asynchronous layouts are cancelled when a asynchronous layout happens.
    func verifyReloadAsyncCancelsPreviousLayout(_ view: TestableReloadableView) {
        // Start some asynchronous layouts.
        for i in 0..<5 {
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: false, layoutProvider: layoutProviderOne, completion: {
                XCTFail("layout \(i) should have been cancelled")
            })
        }

        // Do an asynchronous layout.
        let completionExpectation = expectation(description: "completion")
        view.layoutAdapter.reload(width: view.bounds.width, synchronous: false, layoutProvider: layoutProviderTwo, completion: {
            completionExpectation.fulfill()
        })

        waitForExpectations(timeout: 10, handler: nil)

        // Verify that only the last asynchronous layout happened.
        verifyLayoutTwo(view)

        // Expect items and sections to be inserted incrementally (except first reload).
        XCTAssertEqual(view.reloadDataCount, 1)
        XCTAssertEqual(view.batchUpdates.insertItems.count, 6)
        XCTAssertEqual(view.batchUpdates.insertSections.count, 2)
    }

    /// Verifies that layout operations are cancelled if the reloadable view is deallocated.
    func verifyReloadAsyncCancelledOnViewDeinit(_ viewProvider: @autoclosure () -> TestableReloadableView) {
        var adapter: ReloadableViewLayoutAdapter!
        autoreleasepool {
            let view = viewProvider()
            adapter = view.layoutAdapter
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: false, layoutProvider: layoutProviderOne, completion: {
                XCTFail("should not have completed")
            })
        }
        waitForBackgroundOperations(adapter)
    }

    private func verifySectionZero(_ view: TestableReloadableView, updated: Bool = false) {
        let itemWidth = 320 - view.itemWidthInset
        let suffix = updated ? " updated" : ""
        if #available(tvOS 10, *) {
            view.verifyHeader(0, text: "header 0" + suffix, frame: CGRect(x: 0, y: 0, width: 320, height: 51), file: #file, line: #line)
            view.verifyVisibleItem("item 0", frame: CGRect(x: 0, y: 51, width: itemWidth, height: 52), file: #file, line: #line)
            view.verifyVisibleItem("item 1" + suffix, frame: CGRect(x: 0, y: 103 + 1*view.itemSpacing, width: itemWidth, height: 53), file: #file, line: #line)
            view.verifyVisibleItem("item 2", frame: CGRect(x: 0, y: 156 + 2*view.itemSpacing, width: itemWidth, height: 54), file: #file, line: #line)
            view.verifyFooter(0, text: "footer 0", frame: CGRect(x: 0, y: 210 + 3*view.itemSpacing, width: 320, height: 55), file: #file, line: #line)
        } else {
            view.verifyHeader(0, text: "header 0" + suffix, frame: CGRect(x: 0, y: 0, width: 320, height: 51), file: #file, line: #line)
            view.verifyVisibleItem("item 0", frame: CGRect(x: 0, y: 51 + view.itemSpacing, width: itemWidth, height: 52), file: #file, line: #line)
            view.verifyVisibleItem("item 1" + suffix, frame: CGRect(x: 0, y: 103 + 2*view.itemSpacing, width: itemWidth, height: 53), file: #file, line: #line)
            view.verifyVisibleItem("item 2", frame: CGRect(x: 0, y: 156 + 3*view.itemSpacing, width: itemWidth, height: 54), file: #file, line: #line)
            view.verifyFooter(0, text: "footer 0", frame: CGRect(x: 0, y: 210 + 4*view.itemSpacing, width: 320, height: 55), file: #file, line: #line)
        }
    }

    private func verifyLayoutOne(_ view: TestableReloadableView) {
        verifySectionZero(view)

        // Section 1
        let itemWidth = 320 - view.itemWidthInset
        if #available(tvOS 10, *) {
            view.verifyHeader(1, text: nil, frame: nil, file: #file, line: #line)
            view.verifyVisibleItem("item 3", frame: CGRect(x: 0, y: 265 + 4*view.itemSpacing, width: itemWidth, height: 56), file: #file, line: #line)
            view.verifyVisibleItem("item 4", frame: CGRect(x: 0, y: 321 + 5*view.itemSpacing, width: itemWidth, height: 57), file: #file, line: #line)
            view.verifyFooter(1, text: nil, frame: nil, file: #file, line: #line)
        } else {
            view.verifyHeader(1, text: nil, frame: nil, file: #file, line: #line)
            view.verifyVisibleItem("item 3", frame: CGRect(x: 0, y: 265 + 5*view.itemSpacing, width: itemWidth, height: 56), file: #file, line: #line)
            view.verifyVisibleItem("item 4", frame: CGRect(x: 0, y: 321 + 6*view.itemSpacing, width: itemWidth, height: 57), file: #file, line: #line)
            view.verifyFooter(1, text: nil, frame: nil, file: #file, line: #line)
        }
    }

    private func verifyLayoutTwo(_ view: TestableReloadableView) {
        let itemWidth = 320 - view.itemWidthInset
        verifySectionZero(view, updated: true)

        // Section 1
        if #available(tvOS 10, *) {
            view.verifyHeader(1, text: nil, frame: nil, file: #file, line: #line)
            view.verifyVisibleItem("item 3 updated", frame: CGRect(x: 0, y: 265 + 4*view.itemSpacing, width: itemWidth, height: 56), file: #file, line: #line)
            view.verifyVisibleItem("item 4", frame: CGRect(x: 0, y: 321 + 5*view.itemSpacing, width: itemWidth, height: 57), file: #file, line: #line)
            view.verifyVisibleItem("item 5", frame: CGRect(x: 0, y: 378 + 6*view.itemSpacing, width: itemWidth, height: 58), file: #file, line: #line)
            view.verifyFooter(1, text: nil, frame: nil, file: #file, line: #line)
        } else {
            view.verifyHeader(1, text: nil, frame: nil, file: #file, line: #line)
            view.verifyVisibleItem("item 3 updated", frame: CGRect(x: 0, y: 265 + 5*view.itemSpacing, width: itemWidth, height: 56), file: #file, line: #line)
            view.verifyVisibleItem("item 4", frame: CGRect(x: 0, y: 321 + 6*view.itemSpacing, width: itemWidth, height: 57), file: #file, line: #line)
            view.verifyVisibleItem("item 5", frame: CGRect(x: 0, y: 378 + 7*view.itemSpacing, width: itemWidth, height: 58), file: #file, line: #line)
            view.verifyFooter(1, text: nil, frame: nil, file: #file, line: #line)
        }

        // Section 2
        if #available(tvOS 10, *) {
            view.verifyHeader(2, text: "header 2", frame: CGRect(x: 0, y: 436 + 7*view.itemSpacing, width: 320, height: 59), file: #file, line: #line)
            view.verifyVisibleItem("item 6", frame: CGRect(x: 0, y: 495 + 7*view.itemSpacing, width: itemWidth, height: 60), file: #file, line: #line)
            view.verifyVisibleItem("item 7", frame: CGRect(x: 0, y: 555 + 8*view.itemSpacing, width: itemWidth, height: 61), file: #file, line: #line)
            view.verifyVisibleItem("item 8", frame: CGRect(x: 0, y: 616 + 9*view.itemSpacing, width: itemWidth, height: 62), file: #file, line: #line)
            view.verifyFooter(2, text: "footer 2", frame: CGRect(x: 0, y: 678 + 10*view.itemSpacing, width: 320, height: 63), file: #file, line: #line)
        } else {
            view.verifyHeader(2, text: "header 2", frame: CGRect(x: 0, y: 436 + 8*view.itemSpacing, width: 320, height: 59), file: #file, line: #line)
            view.verifyVisibleItem("item 6", frame: CGRect(x: 0, y: 495 + 9*view.itemSpacing, width: itemWidth, height: 60), file: #file, line: #line)
            view.verifyVisibleItem("item 7", frame: CGRect(x: 0, y: 555 + 10*view.itemSpacing, width: itemWidth, height: 61), file: #file, line: #line)
            view.verifyVisibleItem("item 8", frame: CGRect(x: 0, y: 616 + 11*view.itemSpacing, width: itemWidth, height: 62), file: #file, line: #line)
            view.verifyFooter(2, text: "footer 2", frame: CGRect(x: 0, y: 678 + 12*view.itemSpacing, width: 320, height: 63), file: #file, line: #line)
        }

    }

    private func verifyLayoutThree(_ view: TestableReloadableView, batchUpdate: Bool) {
        let itemWidth = 320 - view.itemWidthInset

        // Section 0
        if #available(tvOS 10, *) {
            view.verifyHeader(0, text: "header 2", frame: CGRect(x: 0, y: 0, width: 320, height: 59), file: #file, line: #line)
            view.verifyVisibleItem("item 6", frame: CGRect(x: 0, y: 59 + 0*view.itemSpacing, width: itemWidth, height: 60), file: #file, line: #line)
            view.verifyVisibleItem("item 7", frame: CGRect(x: 0, y: 119 + 1*view.itemSpacing, width: itemWidth, height: 61), file: #file, line: #line)
            view.verifyVisibleItem("item 8", frame: CGRect(x: 0, y: 180 + 2*view.itemSpacing, width: itemWidth, height: 62), file: #file, line: #line)
            view.verifyFooter(0, text: "footer 2", frame: CGRect(x: 0, y: 242 + 3*view.itemSpacing, width: 320, height: 63), file: #file, line: #line)
        } else {
            view.verifyHeader(0, text: "header 2", frame: CGRect(x: 0, y: 0, width: 320, height: 59), file: #file, line: #line)
            view.verifyVisibleItem("item 6", frame: CGRect(x: 0, y: 59 + 1*view.itemSpacing, width: itemWidth, height: 60), file: #file, line: #line)
            view.verifyVisibleItem("item 7", frame: CGRect(x: 0, y: 119 + 2*view.itemSpacing, width: itemWidth, height: 61), file: #file, line: #line)
            view.verifyVisibleItem("item 8", frame: CGRect(x: 0, y: 180 + 3*view.itemSpacing, width: itemWidth, height: 62), file: #file, line: #line)
            view.verifyFooter(0, text: "footer 2", frame: CGRect(x: 0, y: 242 + 4*view.itemSpacing, width: 320, height: 63), file: #file, line: #line)
        }


        // Section 1
        if #available(tvOS 10, *) {
            view.verifyHeader(1, text: nil, frame: nil, file: #file, line: #line)
            view.verifyVisibleItem("item 4", frame: CGRect(x: 0, y: 305 + 4*view.itemSpacing, width: itemWidth, height: 57), file: #file, line: #line)
            view.verifyVisibleItem("item 3 updated", frame: CGRect(x: 0, y: 362 + 5*view.itemSpacing, width: itemWidth, height: 56), file: #file, line: #line)
            view.verifyFooter(1, text: nil, frame: nil, file: #file, line: #line)
        } else {
            view.verifyHeader(1, text: nil, frame: nil, file: #file, line: #line)
            view.verifyVisibleItem("item 4", frame: CGRect(x: 0, y: 305 + 5*view.itemSpacing, width: itemWidth, height: 57), file: #file, line: #line)
            view.verifyVisibleItem("item 3 updated", frame: CGRect(x: 0, y: 362 + 6*view.itemSpacing, width: itemWidth, height: 56), file: #file, line: #line)
            view.verifyFooter(1, text: nil, frame: nil, file: #file, line: #line)
        }


        if batchUpdate {
            let itemMove = ItemMove(from: IndexPath(item: 0, section: 1), to: IndexPath(item: 1, section: 1))
            XCTAssertEqual(view.batchUpdates.moveItems.only, itemMove)
            XCTAssertEqual(view.batchUpdates.moveSections.only, SectionMove(from: 2, to: 0))
            XCTAssertEqual(view.batchUpdates.deleteItems.only, IndexPath(item: 2, section: 1))
            XCTAssertEqual(view.batchUpdates.deleteSections.only, 0)
            XCTAssertEqual(view.reloadDataCount, 0)
        } else {
            XCTAssertEqual(view.batchUpdates.moveItems.count, 0)
            XCTAssertEqual(view.batchUpdates.moveSections.count, 0)
            XCTAssertEqual(view.batchUpdates.deleteItems.count, 0)
            XCTAssertEqual(view.batchUpdates.deleteSections.count, 0)
            XCTAssertEqual(view.reloadDataCount, 1)
        }
    }

    private func layoutProviderOne() -> [Section<[Layout]>] {
        return [
            Section(
                header: TestLabelLayout(text: "header 0", height: 51),
                items: [
                    TestLabelLayout(text: "item 0", height: 52),
                    TestLabelLayout(text: "item 1", height: 53),
                    TestLabelLayout(text: "item 2", height: 54),
                ],
                footer: TestLabelLayout(text: "footer 0", height: 55)
            ),
            Section(
                header: nil,
                items: [
                    TestLabelLayout(text: "item 3", height: 56),
                    TestLabelLayout(text: "item 4", height: 57),
                ],
                footer: nil
            )
        ]
    }

    private func layoutProviderTwo() -> [Section<[Layout]>] {
        return [
            Section(
                header: TestLabelLayout(text: "header 0 updated", height: 51),
                items: [
                    TestLabelLayout(text: "item 0", height: 52),
                    TestLabelLayout(text: "item 1 updated", height: 53),
                    TestLabelLayout(text: "item 2", height: 54),
                ],
                footer: TestLabelLayout(text: "footer 0", height: 55)
            ),
            Section(
                header: nil,
                items: [
                    TestLabelLayout(text: "item 3 updated", height: 56),
                    TestLabelLayout(text: "item 4", height: 57),
                    TestLabelLayout(text: "item 5", height: 58),
                ],
                footer: nil
            ),
            Section(
                header: TestLabelLayout(text: "header 2", height: 59),
                items: [
                    TestLabelLayout(text: "item 6", height: 60),
                    TestLabelLayout(text: "item 7", height: 61),
                    TestLabelLayout(text: "item 8", height: 62),
                ],
                footer: TestLabelLayout(text: "footer 2", height: 63)
            )
        ]
    }

    private func batchUpdatesForLayoutTwo() -> BatchUpdates {
        let batchUpdates = BatchUpdates()
        batchUpdates.insertItems.append(IndexPath(item: 2, section: 1))
        batchUpdates.insertSections.insert(2)
        batchUpdates.reloadItems.append(IndexPath(item: 0, section: 1))
        batchUpdates.reloadSections.insert(0)
        return batchUpdates
    }

    private func layoutProviderThree() -> [Section<[Layout]>] {
        return [
            Section(
                header: TestLabelLayout(text: "header 2", height: 59),
                items: [
                    TestLabelLayout(text: "item 6", height: 60),
                    TestLabelLayout(text: "item 7", height: 61),
                    TestLabelLayout(text: "item 8", height: 62),
                ],
                footer: TestLabelLayout(text: "footer 2", height: 63)
            ),
            Section(
                header: nil,
                items: [
                    TestLabelLayout(text: "item 4", height: 57),
                    TestLabelLayout(text: "item 3 updated", height: 56),
                ],
                footer: nil
            )
        ]
    }

    private func batchUpdatesForLayoutThree() -> BatchUpdates {
        let batchUpdates = BatchUpdates()
        batchUpdates.deleteSections.insert(0)
        batchUpdates.moveSections.append(SectionMove(from: 2, to: 0))
        batchUpdates.moveItems.append(ItemMove(from: IndexPath(item: 0, section: 1), to: IndexPath(item: 1, section: 1)))
        batchUpdates.deleteItems.append(IndexPath(item: 2, section: 1))
        return batchUpdates
    }
}

// MARK: - Helper classes

/**
 A label layout that has an intrinsic size.
 We don't want these tests to depend on variable font sizes across screen dimensions.
 */
private class TestLabelLayout: SizeLayout<UILabel> {
    init(text: String, height: CGFloat) {
        super.init(
            minWidth: 101,
            maxWidth: 101,
            minHeight: height,
            maxHeight: height,
            alignment: .fill,
            config: { label in
                label.text = text
            }
        )
    }
}

protocol TestableReloadableView: ReloadableView {

    var layoutAdapter: ReloadableViewLayoutAdapter { get }
    var itemSpacing: CGFloat { get }
    var itemWidthInset: CGFloat { get }
    var reloadDataCount: Int { get }
    var batchUpdates: BatchUpdates { get }

    func resetTestCounts()
    func verifyHeader(_ section: Int, text: String?, frame: CGRect?, file: StaticString, line: UInt)
    func verifyFooter(_ section: Int, text: String?, frame: CGRect?, file: StaticString, line: UInt)
    func verifyVisibleItem(_ text: String, frame: CGRect, file: StaticString, line: UInt)
}
