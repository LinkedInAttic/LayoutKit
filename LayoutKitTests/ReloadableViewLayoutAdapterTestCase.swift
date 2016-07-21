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
    func verifyReloadSync(view: TestableReloadableView) {

        // Test loading layout one while the collection is empty.
        do {
            var completed = false
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: true, layoutProvider: layoutProviderOne, completion: {
                completed = true
            })
            XCTAssertTrue(completed)

            // Need to trigger a layout on UICollectionViews so we can test the results.
            (view as? UICollectionView)?.layoutIfNeeded()

            verifyLayoutOne(view: view)

            // Expect reload since this is synchronous.
            XCTAssertEqual(view.batchUpdates.insertSections.count, 0)
            XCTAssertEqual(view.batchUpdates.insertItemsAtIndexPaths.count, 0)
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

            verifyLayoutTwo(view: view)

            // Expect reload since this is synchronous.
            XCTAssertEqual(view.batchUpdates.insertSections.count, 0)
            XCTAssertEqual(view.batchUpdates.insertItemsAtIndexPaths.count, 0)
            XCTAssertEqual(view.reloadDataCount, 1)
        }
    }

    /// Verifies that batch updates work when layouts are loaded synchronously.
    func verifyReloadBatchUpdatesSync(view: TestableReloadableView) {

        // Setup initial layout.
        view.layoutAdapter.reload(width: view.bounds.width, synchronous: true, layoutProvider: layoutProviderOne)

        // Need to trigger a layout on UICollectionViews so we can test the results.
        (view as? UICollectionView)?.layoutIfNeeded()

        view.resetTestCounts()

        // Test batch update to layout two.
        do {
            var completed = false
            let batchUpdates = batchUpdatesForLayoutTwo()
            view.layoutAdapter.reload(
                width: view.bounds.width,
                synchronous: true,
                batchUpdates: batchUpdates,
                layoutProvider: layoutProviderTwo,
                completion: {
                    completed = true
                }
            )
            XCTAssertTrue(completed)

            // Need to trigger a layout on UICollectionViews so we can test the results.
            (view as? UICollectionView)?.layoutIfNeeded()

            verifyLayoutTwo(view: view)

            // Expect batch update.
            XCTAssertEqual(view.batchUpdates.insertSections.count, 1)
            XCTAssertEqual(view.batchUpdates.insertItemsAtIndexPaths.count, 1)
            XCTAssertEqual(view.reloadDataCount, 0)
        }

        view.resetTestCounts()

        // Test batch update to layout three.
        do {
            var completed = false
            let batchUpdates = batchUpdatesForLayoutThree()
            view.layoutAdapter.reload(
                width: view.bounds.width,
                synchronous: true,
                batchUpdates: batchUpdates,
                layoutProvider: layoutProviderThree,
                completion: {
                    completed = true
                }
            )
            XCTAssertTrue(completed)

            // Need to trigger a layout on UICollectionViews so we can test the results.
            (view as? UICollectionView)?.layoutIfNeeded()

            verifyLayoutThree(view: view, batchUpdate: true)
        }
    }

    /// Loads two layouts asynchronously one after the other and verifies the layouts are correct.
    func verifyReloadAsync(view: TestableReloadableView) {
        // Test loading layout one while the collection is empty.
        do {
            let completionExpectation = expectationWithDescription("completion")
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: false, layoutProvider: layoutProviderOne, completion: {
                completionExpectation.fulfill()
            })

            waitForExpectationsWithTimeout(10, handler: nil)
            verifyLayoutOne(view: view)

            // Expect items and sections to be inserted incrementally (except first reload).
            XCTAssertEqual(view.reloadDataCount, 1)
            XCTAssertEqual(view.batchUpdates.insertItemsAtIndexPaths.count, 3)
            XCTAssertEqual(view.batchUpdates.insertSections.count, 1)
        }

        view.resetTestCounts()

        // Test loading layout two while the collection is not empty.
        do {
            let completionExpectation = expectationWithDescription("completion")
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: false, layoutProvider: layoutProviderTwo, completion: {
                completionExpectation.fulfill()
            })

            waitForExpectationsWithTimeout(10, handler: nil)
            verifyLayoutTwo(view: view)

            // Expect reload since the view already has content.
            XCTAssertEqual(view.reloadDataCount, 1)
            XCTAssertEqual(view.batchUpdates.insertItemsAtIndexPaths.count, 0)
            XCTAssertEqual(view.batchUpdates.insertSections.count, 0)
        }
    }

    /// Verifies that batch updates work when layouts are loaded asynchronously.
    func verifyReloadBatchUpdatesAsync(view: TestableReloadableView) {
        // Setup initial layout.
        view.layoutAdapter.reload(width: view.bounds.width, synchronous: true, layoutProvider: layoutProviderOne)

        // Need to trigger a layout on UICollectionViews so we can test the results.
        (view as? UICollectionView)?.layoutIfNeeded()

        view.resetTestCounts()

        // Test batch update to layout two.
        do {
            let completionExpectation = expectationWithDescription("completion")
            let batchUpdates = batchUpdatesForLayoutTwo()
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: false, batchUpdates: batchUpdates, layoutProvider: layoutProviderTwo, completion: {
                completionExpectation.fulfill()
            })

            waitForExpectationsWithTimeout(10, handler: nil)
            verifyLayoutTwo(view: view)

            // Expect batch update.
            XCTAssertEqual(view.batchUpdates.insertSections.count, 1)
            XCTAssertEqual(view.batchUpdates.insertItemsAtIndexPaths.count, 1)
            XCTAssertEqual(view.reloadDataCount, 0)
        }


        // Test batch update to layout two.
        do {
            let completionExpectation = expectationWithDescription("completion")
            let batchUpdates = batchUpdatesForLayoutThree()
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: false, batchUpdates: batchUpdates, layoutProvider: layoutProviderThree, completion: {
                completionExpectation.fulfill()
            })

            waitForExpectationsWithTimeout(10, handler: nil)
            verifyLayoutThree(view: view, batchUpdate: true)
        }
    }

    /// Verifies that all asynchronous layouts are cancelled when a synchronous layout happens.
    func verifyReloadSyncCancelsPreviousLayout(view: TestableReloadableView) {
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
            self.verifyLayoutTwo(view: view)

            // Expect reload since this is synchronous.
            XCTAssertEqual(view.reloadDataCount, 1)
            XCTAssertEqual(view.batchUpdates.insertItemsAtIndexPaths.count, 0)
            XCTAssertEqual(view.batchUpdates.insertSections.count, 0)
        }

        verify()
        waitForBackgroundOperations(view.layoutAdapter)
        verify()
    }

    private func waitForBackgroundOperations(adapter: ReloadableViewLayoutAdapter) {
        let expectation = expectationWithDescription("background layout operations")
        adapter.backgroundLayoutQueue.addOperationWithBlock {
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(10, handler: nil)
    }

    /// Verifies that all asynchronous layouts are cancelled when a asynchronous layout happens.
    func verifyReloadAsyncCancelsPreviousLayout(view: TestableReloadableView) {
        // Start some asynchronous layouts.
        for i in 0..<5 {
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: false, layoutProvider: layoutProviderOne, completion: {
                XCTFail("layout \(i) should have been cancelled")
            })
        }

        // Do an asynchronous layout.
        let completionExpectation = expectationWithDescription("completion")
        view.layoutAdapter.reload(width: view.bounds.width, synchronous: false, layoutProvider: layoutProviderTwo, completion: {
            completionExpectation.fulfill()
        })

        waitForExpectationsWithTimeout(10, handler: nil)

        // Verify that only the last asynchronous layout happened.
        verifyLayoutTwo(view: view)

        // Expect items and sections to be inserted incrementally (except first reload).
        XCTAssertEqual(view.reloadDataCount, 1)
        XCTAssertEqual(view.batchUpdates.insertItemsAtIndexPaths.count, 6)
        XCTAssertEqual(view.batchUpdates.insertSections.count, 2)
    }

    /// Verifies that layout operations are cancelled if the reloadable view is deallocated.
    func verifyReloadAsyncCancelledOnViewDeinit(@autoclosure viewProvider: Void -> TestableReloadableView) {
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

    private func verifySectionZero(view: TestableReloadableView) {
        view.verifyHeader(section: 0, text: "header 0", frame: CGRect(x: 0, y: 0, width: 320, height: 51), line: #line)
        view.verifyVisibleItem(text: "item 0", frame: CGRect(x: 0, y: 51, width: 320, height: 52), line: #line)
        view.verifyVisibleItem(text: "item 1", frame: CGRect(x: 0, y: 103, width: 320, height: 53), line: #line)
        view.verifyVisibleItem(text: "item 2", frame: CGRect(x: 0, y: 156, width: 320, height: 54), line: #line)
        view.verifyFooter(section: 0, text: "footer 0", frame: CGRect(x: 0, y: 210, width: 320, height: 55), line: #line)
    }

    private func verifyLayoutOne(view view: TestableReloadableView) {
        verifySectionZero(view)

        // Section 1
        view.verifyHeader(section: 1, text: nil, frame: nil, line: #line)
        view.verifyVisibleItem(text: "item 3", frame: CGRect(x: 0, y: 265, width: 320, height: 56), line: #line)
        view.verifyVisibleItem(text: "item 4", frame: CGRect(x: 0, y: 321, width: 320, height: 57), line: #line)
        view.verifyFooter(section: 1, text: nil, frame: nil, line: #line)
    }

    private func verifyLayoutTwo(view view: TestableReloadableView) {
        verifySectionZero(view)

        // Section 1
        view.verifyHeader(section: 1, text: nil, frame: nil, line: #line)
        view.verifyVisibleItem(text: "item 3", frame: CGRect(x: 0, y: 265, width: 320, height: 56), line: #line)
        view.verifyVisibleItem(text: "item 4", frame: CGRect(x: 0, y: 321, width: 320, height: 57), line: #line)
        view.verifyVisibleItem(text: "item 5", frame: CGRect(x: 0, y: 378, width: 320, height: 58), line: #line)
        view.verifyFooter(section: 1, text: nil, frame: nil, line: #line)

        // Section 2
        view.verifyHeader(section: 2, text: "header 2", frame: CGRect(x: 0, y: 436, width: 320, height: 59), line: #line)
        view.verifyVisibleItem(text: "item 6", frame: CGRect(x: 0, y: 495, width: 320, height: 60), line: #line)
        view.verifyVisibleItem(text: "item 7", frame: CGRect(x: 0, y: 555, width: 320, height: 61), line: #line)
        view.verifyVisibleItem(text: "item 8", frame: CGRect(x: 0, y: 616, width: 320, height: 62), line: #line)
        view.verifyFooter(section: 2, text: "footer 2", frame: CGRect(x: 0, y: 678, width: 320, height: 63), line: #line)
    }

    private func verifyLayoutThree(view view: TestableReloadableView, batchUpdate: Bool) {
        // Section 0
        view.verifyHeader(section: 0, text: "header 2", frame: CGRect(x: 0, y: 0, width: 320, height: 59), line: #line)
        view.verifyVisibleItem(text: "item 6", frame: CGRect(x: 0, y: 59, width: 320, height: 60), line: #line)
        view.verifyVisibleItem(text: "item 7", frame: CGRect(x: 0, y: 119, width: 320, height: 61), line: #line)
        view.verifyVisibleItem(text: "item 8", frame: CGRect(x: 0, y: 180, width: 320, height: 62), line: #line)
        view.verifyFooter(section: 0, text: "footer 2", frame: CGRect(x: 0, y: 242, width: 320, height: 63), line: #line)

        // Section 1
        view.verifyHeader(section: 1, text: nil, frame: nil, line: #line)
        view.verifyVisibleItem(text: "item 4", frame: CGRect(x: 0, y: 305, width: 320, height: 57), line: #line)
        view.verifyVisibleItem(text: "item 3", frame: CGRect(x: 0, y: 362, width: 320, height: 56), line: #line)
        view.verifyFooter(section: 1, text: nil, frame: nil, line: #line)

        if batchUpdate {
            let itemMove = ItemMove(from: NSIndexPath(forItem: 0, inSection: 1), to: NSIndexPath(forItem: 1, inSection: 1))
            XCTAssertEqual(view.batchUpdates.moveItemsAtIndexPaths.only, itemMove)
            XCTAssertEqual(view.batchUpdates.moveSections.only, SectionMove(from: 2, to: 0))
            XCTAssertEqual(view.batchUpdates.deleteItemsAtIndexPaths.only, NSIndexPath(forItem: 2, inSection: 1))
            XCTAssertEqual(view.batchUpdates.deleteSections.only, 0)
            XCTAssertEqual(view.reloadDataCount, 0)
        } else {
            XCTAssertEqual(view.batchUpdates.moveItemsAtIndexPaths.count, 0)
            XCTAssertEqual(view.batchUpdates.moveSections.count, 0)
            XCTAssertEqual(view.batchUpdates.deleteItemsAtIndexPaths.count, 0)
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
        var batchUpdates = BatchUpdates()
        batchUpdates.insertItemsAtIndexPaths.append(NSIndexPath(forItem: 2, inSection: 1))
        batchUpdates.insertSections.addIndex(2)
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
                    TestLabelLayout(text: "item 3", height: 56),
                ],
                footer: nil
            )
        ]
    }

    private func batchUpdatesForLayoutThree() -> BatchUpdates {
        var batchUpdates = BatchUpdates()
        batchUpdates.deleteSections.addIndex(0)
        batchUpdates.moveSections.append(SectionMove(from: 2, to: 0))
        batchUpdates.moveItemsAtIndexPaths.append(ItemMove(from: NSIndexPath(forItem: 0, inSection: 1), to: NSIndexPath(forItem: 1, inSection: 1)))
        batchUpdates.deleteItemsAtIndexPaths.append(NSIndexPath(forItem: 2, inSection: 1))
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
            width: 101,
            height: height,
            alignment: .fill,
            config: { label in
                label.text = text
            }
        )
    }
}

protocol TestableReloadableView: ReloadableView {

    var layoutAdapter: ReloadableViewLayoutAdapter { get }

    var reloadDataCount: Int { get }
    var batchUpdates: BatchUpdates { get }

    func resetTestCounts()

    func verifyHeader(section section: Int, text: String?, frame: CGRect?, line: UInt)
    func verifyFooter(section section: Int, text: String?, frame: CGRect?, line: UInt)
    func verifyVisibleItem(text text: String, frame: CGRect, line: UInt)
}