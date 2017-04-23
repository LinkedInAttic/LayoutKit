// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation


/**
 A set of updates to apply to a `ReloadableView`.
 
 Inherits from NSObject in order to be exposable to Objective-C.
 Objective-C exposability is needed in order to override methods from extensions that use `BatchUpdates` as parameter.
 */
public class BatchUpdates: NSObject {
    public var insertItems = [IndexPath]()
    public var deleteItems = [IndexPath]()
    public var reloadItems = [IndexPath]()
    public var moveItems = [ItemMove]()

    public var insertSections = IndexSet()
    public var deleteSections = IndexSet()
    public var reloadSections = IndexSet()
    public var moveSections = [SectionMove]()

    public override init() {
        super.init()
    }
}

/// Instruction to move an item from one index path to another.
public struct ItemMove: Equatable {
    public let from: IndexPath
    public let to: IndexPath

    public init(from: IndexPath, to: IndexPath) {
        self.from = from
        self.to = to
    }
}

public func ==(lhs: ItemMove, rhs: ItemMove) -> Bool {
    return lhs.from == rhs.from && lhs.to == rhs.to
}

/// Instruction to move a section from one index to another.
public struct SectionMove: Equatable {
    public let from: Int
    public let to: Int

    public init(from: Int, to: Int) {
        self.from = from
        self.to = to
    }
}

public func ==(lhs: SectionMove, rhs: SectionMove) -> Bool {
    return lhs.from == rhs.from && lhs.to == rhs.to
}
