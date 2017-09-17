import XCTest
@testable import LayoutKit

class BatchUpdatesFromArrayDifferenceTest: XCTestCase {

    // Insert

    func test_SingleItem_Insert() {
        let oldArray = [[1, 2]]
        let newArray = [[1, 2, 3]]
        let expectedBatchUpdates = BatchUpdates()
        expectedBatchUpdates.insertItems = [IndexPath(row: 2, section: 0)]

        performTest(oldArray: oldArray, newArray: newArray, expectedBatchUpdates: expectedBatchUpdates)
    }

    func test_MultipleItems_Insert() {
        let oldArray = [[1, 2], []]
        let newArray = [[1, 2, 3], [4, 5], [6]]
        let expectedBatchUpdates = BatchUpdates()
        expectedBatchUpdates.insertItems = [
            IndexPath(row: 2, section: 0),
            IndexPath(row: 0, section: 1),
            IndexPath(row: 1, section: 1),
            IndexPath(row: 0, section: 2)
        ]
        expectedBatchUpdates.insertSections = [2]

        performTest(oldArray: oldArray, newArray: newArray, expectedBatchUpdates: expectedBatchUpdates)
    }

    func test_MultipleItems_Insert_Complex() {
        let oldArray = [[1, 2], [4]]
        let newArray = [[1, 2, 3], [4, 5], [6], [], [8, 9]]
        let expectedBatchUpdates = BatchUpdates()
        expectedBatchUpdates.insertItems = [
            IndexPath(row: 2, section: 0),
            IndexPath(row: 1, section: 1),
            IndexPath(row: 0, section: 2),
            IndexPath(row: 0, section: 4),
            IndexPath(row: 1, section: 4)
        ]
        expectedBatchUpdates.insertSections = [2, 3, 4]

        performTest(oldArray: oldArray, newArray: newArray, expectedBatchUpdates: expectedBatchUpdates)
    }

    // Deleted

    func test_SingleItem_Delete() {
        let oldArray = [[1, 2, 3]]
        let newArray = [[1, 2]]
        let expectedBatchUpdates = BatchUpdates()
        expectedBatchUpdates.deleteItems = [IndexPath(row: 2, section: 0)]

        performTest(oldArray: oldArray, newArray: newArray, expectedBatchUpdates: expectedBatchUpdates)
    }

    func test_MultipleItems_Delete() {
        let oldArray = [[1, 2, 3], [4, 5], [6]]
        let newArray = [[1, 2], []]
        let expectedBatchUpdates = BatchUpdates()
        expectedBatchUpdates.deleteItems = [
            IndexPath(row: 2, section: 0),
            IndexPath(row: 0, section: 1),
            IndexPath(row: 1, section: 1)
        ]
        expectedBatchUpdates.deleteSections = [2]

        performTest(oldArray: oldArray, newArray: newArray, expectedBatchUpdates: expectedBatchUpdates)
    }

    func test_MultipleItems_Delete_Complex() {
        let oldArray = [[1, 2, 3], [4, 5], [6], [], [8, 9]]
        let newArray = [[1, 2], [4]]
        let expectedBatchUpdates = BatchUpdates()
        expectedBatchUpdates.deleteItems = [
            IndexPath(row: 2, section: 0),
            IndexPath(row: 1, section: 1)
        ]
        expectedBatchUpdates.deleteSections = [2, 3, 4]

        performTest(oldArray: oldArray, newArray: newArray, expectedBatchUpdates: expectedBatchUpdates)
    }

    // Move

    func test_SingleItem_Move() {
        let oldArray = [[1, 2]]
        let newArray = [[2, 1]]
        let expectedBatchUpdates = BatchUpdates()
        expectedBatchUpdates.moveItems = [
            ItemMove(from: IndexPath(row: 0, section: 0), to: IndexPath(row: 1, section: 0)),
            ItemMove(from: IndexPath(row: 1, section: 0), to: IndexPath(row: 0, section: 0))
        ]

        performTest(oldArray: oldArray, newArray: newArray, expectedBatchUpdates: expectedBatchUpdates)
    }

    func test_MultipleItems_Move() {
        let oldArray = [[1, 2], [3, 4, 5], [6, 7, 8]]
        let newArray = [[2, 1], [4, 5, 3], [7, 6, 8]]
        let expectedBatchUpdates = BatchUpdates()
        expectedBatchUpdates.moveItems = [
            ItemMove(from: IndexPath(row: 0, section: 0), to: IndexPath(row: 1, section: 0)),
            ItemMove(from: IndexPath(row: 1, section: 0), to: IndexPath(row: 0, section: 0)),
            ItemMove(from: IndexPath(row: 0, section: 1), to: IndexPath(row: 2, section: 1)),
            ItemMove(from: IndexPath(row: 1, section: 1), to: IndexPath(row: 0, section: 1)),
            ItemMove(from: IndexPath(row: 2, section: 1), to: IndexPath(row: 1, section: 1)),
            ItemMove(from: IndexPath(row: 0, section: 2), to: IndexPath(row: 1, section: 2)),
            ItemMove(from: IndexPath(row: 1, section: 2), to: IndexPath(row: 0, section: 2))
        ]

        performTest(oldArray: oldArray, newArray: newArray, expectedBatchUpdates: expectedBatchUpdates)
    }

    // All

    func test_All_Complex() {
        let oldArray = [[-1, 0, 1, 2, 3], [4, 5, 6], [7], [], [8, 9, 10, 11]]
        let newArray = [[1, 2, 0, 3, 13], [5, 4, 12], [10, 11]]

        let expectedBatchUpdates = BatchUpdates()
        expectedBatchUpdates.deleteItems = [
            IndexPath(row: 0, section: 0),
            IndexPath(row: 2, section: 1),
            IndexPath(row: 0, section: 2)
        ]

        expectedBatchUpdates.insertItems = [
            IndexPath(row: 4, section: 0),
            IndexPath(row: 2, section: 1),
            IndexPath(row: 0, section: 2),
            IndexPath(row: 1, section: 2)
        ]

        expectedBatchUpdates.moveItems = [
            ItemMove(from: IndexPath(row: 1, section: 0), to: IndexPath(row: 2, section: 0)),
            ItemMove(from: IndexPath(row: 2, section: 0), to: IndexPath(row: 0, section: 0)),
            ItemMove(from: IndexPath(row: 3, section: 0), to: IndexPath(row: 1, section: 0)),
            ItemMove(from: IndexPath(row: 4, section: 0), to: IndexPath(row: 3, section: 0)),
            ItemMove(from: IndexPath(row: 0, section: 1), to: IndexPath(row: 1, section: 1)),
            ItemMove(from: IndexPath(row: 1, section: 1), to: IndexPath(row: 0, section: 1))
        ]

        expectedBatchUpdates.deleteSections = [3, 4]

        performTest(oldArray: oldArray, newArray: newArray, expectedBatchUpdates: expectedBatchUpdates)
    }

    // Helpers

    func performTest(oldArray: [[Int]], newArray: [[Int]], expectedBatchUpdates: BatchUpdates) {
        let batchUpdates = BatchUpdates.calculate(old: oldArray, new: newArray, elementCompareCallback: { lhs, rhs in
            return compareWithType(lhs: lhs, rhs: rhs, type: Int.self)
        })

        XCTAssert(batchUpdates == expectedBatchUpdates)
    }
}

func compareWithType<T: Equatable>(lhs: Any, rhs: Any, type: T.Type) -> Bool {
    if let lhs = lhs as? T, let rhs = rhs as? T {
        return lhs == rhs
    }

    return false
}

extension BatchUpdates {
    open override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? BatchUpdates {
            return object.insertItems == insertItems &&
                object.deleteItems == deleteItems &&
                object.moveItems == moveItems &&
                object.reloadItems == reloadItems &&

                object.deleteSections == deleteSections &&
                object.insertSections == insertSections &&
                object.moveSections == moveSections &&
                object.reloadSections == reloadSections
        }
        
        return false
    }
}
