// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
@testable import LayoutKit

class ReloadableViewLayoutAdapterTests: XCTestCase {

    // MARK: - UICollectionView tests

    func testCollectionViewReloadSync() {
        verifyReloadSync(TestCollectionView())
    }

    func testCollectionViewReloadSyncCancelsPreviousLayout() {
        verifyReloadSyncCancelsPreviousLayout(TestCollectionView())
    }

    func testCollectionViewReloadAsync() {
        verifyReloadAsync(TestCollectionView())
    }

    func testCollectionViewReloadAsyncCancelsPreviousLayout() {
        verifyReloadAsyncCancelsPreviousLayout(TestCollectionView())
    }

    func testCollectionViewReloadAsyncCancelledOnViewDeinit() {
        verifyReloadAsyncCancelledOnViewDeinit(TestCollectionView())
    }

    // MARK: - UITableView tests

    func testTableViewReloadSync() {
        verifyReloadSync(TestTableView())
    }

    func testTableViewReloadSyncCancelsPreviousLayout() {
        verifyReloadSyncCancelsPreviousLayout(TestCollectionView())
    }

    func testTableViewReloadAsync() {
        verifyReloadAsync(TestTableView())
    }

    func testTableViewReloadAsyncCancelsPreviousLayout() {
        verifyReloadAsyncCancelsPreviousLayout(TestCollectionView())
    }

    func testTableViewReloadAsyncCancelledOnViewDeinit() {
        verifyReloadAsyncCancelledOnViewDeinit(TestCollectionView())
    }

    // MARK: - Helper functions

    /**
     Loads two layouts synchronously one after the other and verifies the layout are correct.
     */
    private func verifyReloadSync(view: TestableReloadableView) {

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
            XCTAssertEqual(view.insertedSections.count, 0)
            XCTAssertEqual(view.insertedIndexPaths.count, 0)
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
            XCTAssertEqual(view.insertedSections.count, 0)
            XCTAssertEqual(view.insertedIndexPaths.count, 0)
            XCTAssertEqual(view.reloadDataCount, 1)
        }
    }

    /**
     Loads two layouts asynchronously one after the other and verifies the layouts are correct.
     */
    private func verifyReloadAsync(view: TestableReloadableView) {
        // Test loading layout one while the collection is empty.
        do {
            let completionExpectation = expectationWithDescription("completion")
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: false, layoutProvider: layoutProviderOne, completion: {
                completionExpectation.fulfill()
            })

            waitForExpectationsWithTimeout(1, handler: nil)

            verifyLayoutOne(view: view)

            // Expect items and sections to be inserted incrementally (except first reload).
            XCTAssertEqual(view.reloadDataCount, 1)
            XCTAssertEqual(view.insertedIndexPaths.count, 3)
            XCTAssertEqual(view.insertedSections.count, 1)
        }

        view.resetTestCounts()

        // Test loading layout two while the collection is not empty.
        do {
            let completionExpectation = expectationWithDescription("completion")
            view.layoutAdapter.reload(width: view.bounds.width, synchronous: false, layoutProvider: layoutProviderTwo, completion: {
                completionExpectation.fulfill()
            })

            waitForExpectationsWithTimeout(1, handler: nil)

            verifyLayoutTwo(view: view)

            // Expect reload since the view already has content.
            XCTAssertEqual(view.reloadDataCount, 1)
            XCTAssertEqual(view.insertedIndexPaths.count, 0)
            XCTAssertEqual(view.insertedSections.count, 0)
        }
    }

    /**
     Verifies that all asynchronous layouts are cancelled when a synchronous layout happens.
     */
    private func verifyReloadSyncCancelsPreviousLayout(view: TestableReloadableView) {
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
            XCTAssertEqual(view.insertedIndexPaths.count, 0)
            XCTAssertEqual(view.insertedSections.count, 0)
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
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    /**
     Verifies that all asynchronous layouts are cancelled when a asynchronous layout happens.
     */
    private func verifyReloadAsyncCancelsPreviousLayout(view: TestableReloadableView) {
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

        waitForExpectationsWithTimeout(1, handler: nil)

        // Verify that only the last asynchronous layout happened.
        verifyLayoutTwo(view: view)

        // Expect items and sections to be inserted incrementally (except first reload).
        XCTAssertEqual(view.reloadDataCount, 1)
        XCTAssertEqual(view.insertedIndexPaths.count, 6)
        XCTAssertEqual(view.insertedSections.count, 2)
    }

    /**
     Verifies that layout operations are cancelled if the reloadable view is deallocated.
     */
    private func verifyReloadAsyncCancelledOnViewDeinit(@autoclosure viewProvider: Void -> TestableReloadableView) {
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
    var insertedIndexPaths: [[NSIndexPath]] { get }
    var insertedSections: [NSIndexSet] { get }

    func resetTestCounts()

    func verifyHeader(section section: Int, text: String?, frame: CGRect?, line: UInt)
    func verifyFooter(section section: Int, text: String?, frame: CGRect?, line: UInt)
    func verifyVisibleItem(text text: String, frame: CGRect, line: UInt)
}

private class TestTableView: LayoutAdapterTableView, TestableReloadableView {
    var reloadDataCount = 0
    var insertedIndexPaths = [[NSIndexPath]]()
    var insertedSections = [NSIndexSet]()

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
        insertedIndexPaths.append(indexPaths)
    }

    private override func insertSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        super.insertSections(sections, withRowAnimation: animation)
        insertedSections.append(sections)
    }

    func resetTestCounts() {
        reloadDataCount = 0
        insertedIndexPaths = []
        insertedSections = []
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

private class TestCollectionView: LayoutAdapterCollectionView, TestableReloadableView {

    var reloadDataCount = 0
    var insertedIndexPaths = [[NSIndexPath]]()
    var insertedSections = [NSIndexSet]()

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

    override func insertItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        super.insertItemsAtIndexPaths(indexPaths)
        insertedIndexPaths.append(indexPaths)
    }

    override func insertSections(sections: NSIndexSet) {
        super.insertSections(sections)
        insertedSections.append(sections)
    }

    func resetTestCounts() {
        reloadDataCount = 0
        insertedIndexPaths = []
        insertedSections = []
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