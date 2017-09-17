import XCTest
@testable import LayoutKit

class BatchUpdatesArrayUpdateTest: XCTestCase {

    // Delete item

    func test_SingleItem_Delete() {
        let oldArray = BatchUpdatesViewModel(strings: [["test 1", "test 2"]])
        let expectedArray = BatchUpdatesViewModel(strings: [["test 1"]])
        let batchUpdates = BatchUpdates()
        batchUpdates.deleteItems = [IndexPath(row: 1, section: 0)]

        performTest(oldArray: oldArray, expectedArray: expectedArray, batchUpdates: batchUpdates)
    }

    func test_MultipleItems_Delete() {
        let oldArray = BatchUpdatesViewModel(strings: [["test 1", "test 2", "test 3", "test 4"]])
        let expectedArray = BatchUpdatesViewModel(strings: [["test 1", "test 4"]])
        let batchUpdates = BatchUpdates()
        batchUpdates.deleteItems = [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)]

        performTest(oldArray: oldArray, expectedArray: expectedArray, batchUpdates: batchUpdates)
    }

    func test_MultipleItems_MultipleSections_Delete() {
        let oldArray = BatchUpdatesViewModel(strings: [["test 1", "test 2", "test 3", "test 4"], ["test 5", "test 6"]])
        let expectedArray = BatchUpdatesViewModel(strings: [["test 1", "test 4"], []])
        let batchUpdates = BatchUpdates()
        batchUpdates.deleteItems = [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0), IndexPath(row: 0, section: 1), IndexPath(row: 1, section: 1)]

        performTest(oldArray: oldArray, expectedArray: expectedArray, batchUpdates: batchUpdates)
    }

    // Delete section

    func test_SingleSection_Delete() {
        let oldArray = BatchUpdatesViewModel(strings: [["test 1", "test 2"]])
        let expectedArray = BatchUpdatesViewModel(strings: [])
        let batchUpdates = BatchUpdates()
        batchUpdates.deleteSections = [0]

        performTest(oldArray: oldArray, expectedArray: expectedArray, batchUpdates: batchUpdates)
    }

    func test_SingleSection_DeleteSecond() {
        let oldArray = BatchUpdatesViewModel(strings: [["test 1", "test 2"], ["test 3", "test 4"]])
        let expectedArray = BatchUpdatesViewModel(strings: [["test 1", "test 2"]])
        let batchUpdates = BatchUpdates()
        batchUpdates.deleteSections = [1]

        performTest(oldArray: oldArray, expectedArray: expectedArray, batchUpdates: batchUpdates)
    }

    func test_MultipleSection_Delete() {
        let oldArray = BatchUpdatesViewModel(strings: [["test 1", "test 2"], ["test 3", "test 4"], ["test 5", "test 6"]])
        let expectedArray = BatchUpdatesViewModel(strings: [["test 3", "test 4"]])
        let batchUpdates = BatchUpdates()
        batchUpdates.deleteSections = [0, 2]

        performTest(oldArray: oldArray, expectedArray: expectedArray, batchUpdates: batchUpdates)
    }

    // Insert item

    func test_SingleItem_Insert() {
        let oldArray = BatchUpdatesViewModel(strings: [["test 1"]])
        let expectedArray = BatchUpdatesViewModel(strings: [["test 1", "row: 1 section: 0"]])
        let batchUpdates = BatchUpdates()
        batchUpdates.insertItems = [IndexPath(row: 1, section: 0)]

        performTest(oldArray: oldArray, expectedArray: expectedArray, batchUpdates: batchUpdates)
    }

    func test_MultipleItem_Insert() {
        let oldArray = BatchUpdatesViewModel(strings: [["test 1"], ["test 2"]])
        let expectedArray = BatchUpdatesViewModel(strings: [["row: 0 section: 0", "test 1", "row: 2 section: 0"],
                                                            ["row: 0 section: 1", "row: 1 section: 1", "test 2"]])
        let batchUpdates = BatchUpdates()
        batchUpdates.insertItems = [IndexPath(row: 0, section: 0), IndexPath(row: 2, section: 0), IndexPath(row: 0, section: 1), IndexPath(row: 1, section: 1)]

        performTest(oldArray: oldArray, expectedArray: expectedArray, batchUpdates: batchUpdates)
    }

    func test_SingleItem_Insert_SectionDoesNotExist() {
        let oldArray = BatchUpdatesViewModel(strings: [[]])
        let expectedArray = BatchUpdatesViewModel(strings: [["row: 0 section: 0"]])
        let batchUpdates = BatchUpdates()
        batchUpdates.insertItems = [IndexPath(row: 0, section: 0)]

        performTest(oldArray: oldArray, expectedArray: expectedArray, batchUpdates: batchUpdates)
    }

    // Insert section

    func test_SingleSection_Insert() {
        let oldArray = BatchUpdatesViewModel(strings: [])
        let expectedArray = BatchUpdatesViewModel(strings: [[]])
        let batchUpdates = BatchUpdates()
        batchUpdates.insertSections = [0]

        performTest(oldArray: oldArray, expectedArray: expectedArray, batchUpdates: batchUpdates)
    }

    func test_MultipleSection_Insert() {
        let oldArray = BatchUpdatesViewModel(strings: [])
        let expectedArray = BatchUpdatesViewModel(strings: [[], [], []])
        let batchUpdates = BatchUpdates()
        batchUpdates.insertSections = [0, 1, 2]

        performTest(oldArray: oldArray, expectedArray: expectedArray, batchUpdates: batchUpdates)
    }

    // Item reload

    func test_SingleItem_Reload() {
        let oldArray = BatchUpdatesViewModel(strings: [["test 1"]])
        let expectedArray = BatchUpdatesViewModel(strings: [["row: 0 section: 0"]])
        let batchUpdates = BatchUpdates()
        batchUpdates.reloadItems = [IndexPath(row: 0, section: 0)]

        performTest(oldArray: oldArray, expectedArray: expectedArray, batchUpdates: batchUpdates)
    }

    func test_MultipleItems_Reload() {
        let oldArray = BatchUpdatesViewModel(strings: [["test 1"], ["test 2", "test 3"]])
        let expectedArray = BatchUpdatesViewModel(strings: [["row: 0 section: 0"], ["test 2", "row: 1 section: 1"]])
        let batchUpdates = BatchUpdates()
        batchUpdates.reloadItems = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 1)]

        performTest(oldArray: oldArray, expectedArray: expectedArray, batchUpdates: batchUpdates)
    }

    // Section reload

    func test_SingleSection_Reload() {
        let oldArray = BatchUpdatesViewModel(strings: [["test 1"]])
        let expectedArray = BatchUpdatesViewModel(strings: [["row: 0 section: 0"]])
        let batchUpdates = BatchUpdates()
        batchUpdates.reloadSections = [0]

        performTest(oldArray: oldArray, expectedArray: expectedArray, batchUpdates: batchUpdates)
    }

    // Helpers

    func performTest(oldArray: BatchUpdatesViewModel, expectedArray: BatchUpdatesViewModel, batchUpdates: BatchUpdates) {
        if let newArray = try? batchUpdates.updateArray(oldArray.strings, elementCreationCallback: { indexPath in
            return "row: \(indexPath.row) section: \(indexPath.section)"
        }) {
            XCTAssert(BatchUpdatesViewModel(strings: newArray) == expectedArray)
        } else {
            XCTAssertTrue(false)
        }
    }
}

struct BatchUpdatesViewModel {
    let strings: [[String]]
}

extension BatchUpdatesViewModel: Equatable {}

func == (lhs: BatchUpdatesViewModel, rhs: BatchUpdatesViewModel) -> Bool {
    guard lhs.strings.count == rhs.strings.count else { return false }

    for i in 0..<lhs.strings.count {
        guard lhs.strings[i].count == rhs.strings[i].count else { return false }
        
        for j in 0..<lhs.strings[i].count {
            guard lhs.strings[i][j] == rhs.strings[i][j] else { return false }
        }
    }
    
    return true
}
