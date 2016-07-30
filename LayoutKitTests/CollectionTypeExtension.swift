// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.


extension CollectionType {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    /// http://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }

    /// Returns the only element in the collection.
    /// It returns nil if there is not exactly one element in the collection.
    public var only: Self.Generator.Element? {
        if count == 1 {
            return first
        }
        return nil
    }
}
