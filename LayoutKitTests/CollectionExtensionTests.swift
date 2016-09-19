// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
@testable import LayoutKit

class CollectionExtensionTests: XCTestCase {

    func testSafeIndex() {
        let elements = [9]
        XCTAssertNil(elements[safe: -1])
        XCTAssertEqual(elements[safe: 0], 9)
        XCTAssertNil(elements[safe: 1])
    }

    func testSafeIndexEmptyCollection() {
        let elements = [Int]()
        XCTAssertNil(elements[safe: -1])
        XCTAssertNil(elements[safe: 0])
        XCTAssertNil(elements[safe: 1])
    }

    func testBinarySearchEmptyCollection() {
        let elements = [Int]()
        XCTAssertNil(elements.binarySearch(forFirstIndexMatchingPredicate: { _ in return true }))
        XCTAssertNil(elements.binarySearch(forFirstIndexMatchingPredicate: { _ in return false }))
    }

    func testBinarySearchOneElementCollection() {
        let elements = [1]
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 > 0 }), 0)
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 > 1 }), nil)
    }

    func testBinarySearchTwoElementCollection() {
        let elements = [1, 2]
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 > 0 }), 0)
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 > 1 }), 1)
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 > 2 }), nil)
    }

    func testBinarySearchLargeCollection() {
        let elements = [1, 3, 5, 7, 8, 9, 11]
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 >= 0 } ), 0)
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 >= 1 } ), 0)
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 >= 2 } ), 1)
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 >= 3 } ), 1)
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 >= 4 } ), 2)
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 >= 5 } ), 2)
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 >= 6 } ), 3)
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 >= 7 } ), 3)
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 >= 8 } ), 4)
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 >= 9 } ), 5)
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 >= 10 } ), 6)
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 >= 11 } ), 6)
        XCTAssertEqual(elements.binarySearch(forFirstIndexMatchingPredicate: { $0 >= 12 } ), nil)
    }

    /*

     func testEmptyCollection() {
     let elements = [Int]()
     XCTAssertNil(elements.binarySearch(forLastIndexMatchingPredicate: { _ in return true }))
     XCTAssertNil(elements.binarySearch(forLastIndexMatchingPredicate: { _ in return false }))
     }

     func testOneElementCollection() {
     let elements = [1]
     XCTAssertNil(elements.binarySearch(forLastIndexMatchingPredicate: { $0 < 1 }))
     XCTAssertEqual(elements.binarySearch(forLastIndexMatchingPredicate: { $0 < 2 }), 0)
     }

     func testTwoElementCollection() {
     let elements = [1, 2]
     XCTAssertNil(elements.binarySearch(forLastIndexMatchingPredicate: { $0 < 1 }))
     XCTAssertEqual(elements.binarySearch(forLastIndexMatchingPredicate: { $0 < 2 }), 0)
     XCTAssertEqual(elements.binarySearch(forLastIndexMatchingPredicate: { $0 < 3 }), 1)
     }

     func testLargeCollection() {
     let elements = [1, 3, 5, 7, 8, 9, 11]
     XCTAssertEqual(elements.binarySearch(forLastIndexMatchingPredicate: { $0 <= 0 } ), nil)
     XCTAssertEqual(elements.binarySearch(forLastIndexMatchingPredicate: { $0 <= 1 } ), 0)
     XCTAssertEqual(elements.binarySearch(forLastIndexMatchingPredicate: { $0 <= 2 } ), 0)
     XCTAssertEqual(elements.binarySearch(forLastIndexMatchingPredicate: { $0 <= 3 } ), 1)
     XCTAssertEqual(elements.binarySearch(forLastIndexMatchingPredicate: { $0 <= 4 } ), 1)
     XCTAssertEqual(elements.binarySearch(forLastIndexMatchingPredicate: { $0 <= 5 } ), 2)
     XCTAssertEqual(elements.binarySearch(forLastIndexMatchingPredicate: { $0 <= 6 } ), 2)
     XCTAssertEqual(elements.binarySearch(forLastIndexMatchingPredicate: { $0 <= 7 } ), 3)
     XCTAssertEqual(elements.binarySearch(forLastIndexMatchingPredicate: { $0 <= 8 } ), 4)
     XCTAssertEqual(elements.binarySearch(forLastIndexMatchingPredicate: { $0 <= 9 } ), 5)
     XCTAssertEqual(elements.binarySearch(forLastIndexMatchingPredicate: { $0 <= 10 } ), 5)
     XCTAssertEqual(elements.binarySearch(forLastIndexMatchingPredicate: { $0 <= 11 } ), 6)
     }
 */
}
