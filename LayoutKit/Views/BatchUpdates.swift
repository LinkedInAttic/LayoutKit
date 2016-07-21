// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation


/// A set of updates to apply to a `ReloadableView`.
public struct BatchUpdates {
    public var insertItemsAtIndexPaths = [NSIndexPath]()
    public var deleteItemsAtIndexPaths = [NSIndexPath]()
    public var moveItemsAtIndexPaths = [ItemMove]()

    public var insertSections = NSMutableIndexSet()
    public var deleteSections = NSMutableIndexSet()
    public var moveSections = [SectionMove]()

    public init() { }
}

/// Instruction to move an item from one index path to another.
public struct ItemMove: Hashable {
    public let from: NSIndexPath
    public let to: NSIndexPath

    public init(from: NSIndexPath, to: NSIndexPath) {
        self.from = from
        self.to = to
    }

    public var hashValue: Int {
        return intHashValue(from.hashValue, to.hashValue)
    }
}

public func ==(lhs: ItemMove, rhs: ItemMove) -> Bool {
    return lhs.from == rhs.from && lhs.to == rhs.to
}

/// Instruction to move a section from one index to another.
public struct SectionMove: Hashable {
    public let from: Int
    public let to: Int

    public init(from: Int, to: Int) {
        self.from = from
        self.to = to
    }

    public var hashValue: Int {
        return intHashValue(from, to)
    }
}

public func ==(lhs: SectionMove, rhs: SectionMove) -> Bool {
    return lhs.from == rhs.from && lhs.to == rhs.to
}

/// Returns a hash value for the two integers
/// by concatenating the lowest 32 bits of each integer.
private func intHashValue(left: Int, _ right: Int) -> Int {
    let leftLowBits = left % (1 << 32)
    let rightLowBits = right % (1 << 32)
    return leftLowBits + rightLowBits << 32
}