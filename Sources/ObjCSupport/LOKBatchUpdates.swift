// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation

/**
 A set of updates to apply to a `ReloadableView`.

 Inherits from `NSObject` in order to be exposable to Objective-C.
 Objective-C exposability is needed in order to override methods from extensions that use `BatchUpdates` as parameter.
 */
@objc open class LOKBatchUpdates: NSObject {
    @objc public var insertItems = [IndexPath]()
    @objc public var deleteItems = [IndexPath]()
    @objc public var reloadItems = [IndexPath]()
    @objc public var moveItems = [LOKBatchUpdateItemMove]()

    @objc public var insertSections = IndexSet()
    @objc public var deleteSections = IndexSet()
    @objc public var reloadSections = IndexSet()
    @objc public var moveSections = [LOKBatchUpdateSectionMove]()

    @objc public override init() {
        super.init()
    }

    var unwrapped: BatchUpdates {
        let updates = BatchUpdates()
        updates.insertItems = insertItems
        updates.deleteItems = deleteItems
        updates.reloadItems = reloadItems
        updates.moveItems = moveItems.map { $0.unwrapped }
        updates.insertSections = insertSections
        updates.deleteSections = deleteSections
        updates.reloadSections = reloadSections
        updates.moveSections = moveSections.map { $0.unwrapped }
        return updates
    }
}

/**
 Instruction to move an item from one index path to another.
 */
@objc open class LOKBatchUpdateItemMove: NSObject {
    @objc public let from: IndexPath
    @objc public let to: IndexPath

    @objc public init(from: IndexPath, to: IndexPath) {
        self.from = from
        self.to = to
    }

    var unwrapped: ItemMove {
        return ItemMove(from: from, to: to)
    }
}

/**
 Instruction to move a section from one index to another.
 */
@objc open class LOKBatchUpdateSectionMove: NSObject {
    @objc public let from: Int
    @objc public let to: Int

    @objc public init(from: Int, to: Int) {
        self.from = from
        self.to = to
    }

    var unwrapped: SectionMove {
        return SectionMove(from: from, to: to)
    }
}

