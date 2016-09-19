// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

extension Collection where Self.Index == Int {

    /// Returns the index N such that the predicate is false for all elements before index N
    /// and true for all other elements.
    /// It returns nil if the predicate is false for all elements in the collection.
    func binarySearch(forFirstIndexMatchingPredicate predicate: (Iterator.Element) -> Bool) -> Self.Index? {
        var low = startIndex
        var high = endIndex
        var index: Self.Index? = nil
        while low <= high {
            let mid = low + (high - low) / 2
            if mid < startIndex || mid >= endIndex {
                break;
            }
            if predicate(self[mid]) {
                index = mid
                high = mid - 1
            } else {
                low = mid + 1
            }
        }
        return index
    }
}

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    /// http://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings
    subscript(safe index: Index) -> _Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
