import XCTest
@testable import LayoutKit

class LayoutAdapterCacheHandlerTest: XCTestCase {
    var layoutAdapterHandler: LayoutAdapterCacheHandler!
    var layoutAdapter: MockLayoutAdapter!

    override func setUp() {
        layoutAdapter = MockLayoutAdapter()
        layoutAdapterHandler = LayoutAdapterCacheHandler(layoutAdapter: layoutAdapter)
    }

    func testLayoutProvider_SingleItem_Insert() {
        let batchUpdates = BatchUpdates()
        batchUpdates.insertItems = [IndexPath(row: 0, section: 0)]
        let layoutProvider = { indexPath in
            return MockSizeLayout(indexPath: indexPath)
        }

        let expectedLayouts = [MockSizeLayout(indexPath: IndexPath(row: 0, section: 0))]

        let newLayout = layoutAdapterHandler
            .cachedLayout(batchUpdates: batchUpdates, layoutProvider: layoutProvider)

        if let firstItems = newLayout[0].items as? [MockSizeLayout] {
            XCTAssert(firstItems == expectedLayouts)
        } else {
            XCTAssertTrue(false)
        }
    }

    func testLayoutProvider_MultipleItems_Insert() {
        let batchUpdates = BatchUpdates()
        batchUpdates.insertItems = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 0, section: 1)]
        let layoutProvider = { indexPath in
            return MockSizeLayout(indexPath: indexPath)
        }

        let expectedLayouts = [
            [MockSizeLayout(indexPath: IndexPath(row: 0, section: 0)), MockSizeLayout(indexPath: IndexPath(row: 1, section: 0))],
            [MockSizeLayout(indexPath: IndexPath(row: 0, section: 1))]
        ]

        let newLayout = layoutAdapterHandler
            .cachedLayout(batchUpdates: batchUpdates, layoutProvider: layoutProvider)

        if let firstItems = newLayout[0].items as? [MockSizeLayout],
            let secondItems = newLayout[1].items as? [MockSizeLayout] {

            XCTAssert(firstItems == expectedLayouts[0])
            XCTAssert(secondItems == expectedLayouts[1])
        } else {
            XCTAssertTrue(false)
        }
    }

    func testLayoutProvider_SingleItem_Delete() {
        let batchUpdates = BatchUpdates()
        batchUpdates.deleteItems = [IndexPath(row: 0, section: 0)]
        let layoutProvider = { indexPath in
            return MockSizeLayout(indexPath: indexPath)
        }
        layoutAdapterHandler.layouts = [Section(items: [MockSizeLayout(indexPath: IndexPath(row: 0, section: 0))])]

        let expectedLayouts = [MockSizeLayout]()

        let newLayout = layoutAdapterHandler
            .cachedLayout(batchUpdates: batchUpdates, layoutProvider: layoutProvider)

        if let firstItems = newLayout[0].items as? [MockSizeLayout] {
            XCTAssert(firstItems == expectedLayouts)
        } else {
            XCTAssertTrue(false)
        }
    }

    func testLayoutProvider_MultipleItem_Delete() {
        let batchUpdates = BatchUpdates()
        batchUpdates.deleteItems = [IndexPath(row: 0, section: 0), IndexPath(row: 2, section: 0), IndexPath(row: 1, section: 2)]
        let layoutProvider = { indexPath in
            return MockSizeLayout(indexPath: indexPath)
        }
        layoutAdapterHandler.layouts = [
            Section(items: [MockSizeLayout(indexPath: IndexPath(row: 0, section: 0)),
                            MockSizeLayout(indexPath: IndexPath(row: 1, section: 0)),
                            MockSizeLayout(indexPath: IndexPath(row: 2, section: 0))]),
            Section(items: [MockSizeLayout(indexPath: IndexPath(row: 0, section: 1)),
                            MockSizeLayout(indexPath: IndexPath(row: 1, section: 1)),
                            MockSizeLayout(indexPath: IndexPath(row: 2, section: 1))]),
            Section(items: [MockSizeLayout(indexPath: IndexPath(row: 0, section: 2)),
                            MockSizeLayout(indexPath: IndexPath(row: 1, section: 2)),
                            MockSizeLayout(indexPath: IndexPath(row: 2, section: 2))])
        ]

        let expectedLayouts = [
            [MockSizeLayout(indexPath: IndexPath(row: 1, section: 0))],
            [MockSizeLayout(indexPath: IndexPath(row: 0, section: 1)),
             MockSizeLayout(indexPath: IndexPath(row: 1, section: 1)),
             MockSizeLayout(indexPath: IndexPath(row: 2, section: 1))],
            [MockSizeLayout(indexPath: IndexPath(row: 0, section: 2)),
             MockSizeLayout(indexPath: IndexPath(row: 2, section: 2))]
        ]

        let newLayout = layoutAdapterHandler
            .cachedLayout(batchUpdates: batchUpdates, layoutProvider: layoutProvider)

        if let firstItems = newLayout[0].items as? [MockSizeLayout],
            let secondItems = newLayout[1].items as? [MockSizeLayout],
            let thirdItems = newLayout[2].items as? [MockSizeLayout] {

            XCTAssert(firstItems == expectedLayouts[0])
            XCTAssert(secondItems == expectedLayouts[1])
            XCTAssert(thirdItems == expectedLayouts[2])
        } else {
            XCTAssertTrue(false)
        }
    }
}

class MockLayoutAdapter: LayoutAdapter {
    var reloadLayouts = [Any]()

    func reload<T: Collection, U: Collection>(
        width: CGFloat?,
        height: CGFloat?,
        synchronous: Bool,
        batchUpdates: BatchUpdates?,
        layoutProvider: @escaping (Void) -> T,
        completion: (() -> Void)?) where U.Iterator.Element == Layout, T.Iterator.Element == Section<U> {
        reloadLayouts.append(layoutProvider())
    }
}

class MockSizeLayout: SizeLayout<View> {
    let indexPath: IndexPath

    init(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
}

extension MockSizeLayout: Equatable {}

func == (lhs: MockSizeLayout, rhs: MockSizeLayout) -> Bool {
    return lhs.indexPath == rhs.indexPath
}
