// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation

/// Delegate for a `ReloadableViewUpdateManager`.
protocol ReloadableViewUpdateManagerDelegate: class {
    weak var reloadableView: ReloadableView? { get }
    var currentArrangement: [Section<[LayoutArrangement]>] { get set }
}

/// Manages updating a `ReloadableView` and its backing data.
/// Updates may be applied incrementally, or in a batch.
class ReloadableViewUpdateManager {
    private weak var delegate: ReloadableViewUpdateManagerDelegate?
    private weak var operation: NSOperation?

    static func make(delegate delegate: ReloadableViewUpdateManagerDelegate,
                              operation: NSOperation,
                              incremental: Bool) -> ReloadableViewUpdateManager {
        return incremental ?
            IncrementalUpdateManager(delegate: delegate, operation: operation) :
            BatchUpdateManager(delegate: delegate, operation: operation)
    }

    private init(delegate: ReloadableViewUpdateManagerDelegate, operation: NSOperation) {
        self.delegate = delegate
        self.operation = operation
    }

    func apply(partialArrangement arrangement: [Section<[LayoutArrangement]>], insertedIndexPath: NSIndexPath) {
        // implemented by subclass
    }

    func apply(finalArrangement arrangement: [Section<[LayoutArrangement]>], batchUpdates: BatchUpdates?, completion: (() -> Void)?) {
        // implemented by subclass
    }

    final func updateReloadableView(waitUntilFinished waitUntilFinished: Bool, updates: (reloadableView: ReloadableView) -> Void) {
        let mainOperation = NSBlockOperation()
        mainOperation.addExecutionBlock {
            let operationCancelled = self.operation?.cancelled ?? true
            guard !operationCancelled, let reloadableView = self.delegate?.reloadableView else {
                return
            }
            updates(reloadableView: reloadableView)
        }
        NSOperationQueue.mainQueue().addOperations([mainOperation], waitUntilFinished: waitUntilFinished)
    }
}

/// Updates the `ReloadableView` incrementally as items are inserted.
private class IncrementalUpdateManager: ReloadableViewUpdateManager {

    private var pendingInsertedIndexPaths = [NSIndexPath]()

    override func apply(partialArrangement arrangement: [Section<[LayoutArrangement]>], insertedIndexPath: NSIndexPath) {
        updateReloadableView(waitUntilFinished: false) { (reloadableView: ReloadableView) in
            self.pendingInsertedIndexPaths.append(insertedIndexPath)

            // Don't modify the data while the view is moving.
            // Doing so causes weird artifacts (i.e. "bouncing" breaks).
            // We will try again on the next loop iteration or when the final arrangement is applied.
            if reloadableView.tracking || reloadableView.decelerating {
                return
            }

            self.flushPendingInserts(arrangement: arrangement, reloadableView: reloadableView)
        }
    }

    override func apply(finalArrangement arrangement: [Section<[LayoutArrangement]>], batchUpdates: BatchUpdates?, completion: (() -> Void)?) {
        updateReloadableView(waitUntilFinished: true) { (reloadableView: ReloadableView) in
            self.flushPendingInserts(arrangement: arrangement, reloadableView: reloadableView)
            completion?()
        }
    }

    private func flushPendingInserts(arrangement arrangement: [Section<[LayoutArrangement]>], reloadableView: ReloadableView) {
        assert(NSThread.isMainThread(), "flushPendingInserts must be called on the main thread")

        guard let delegate = self.delegate else {
            return
        }

        let oldArrangement = delegate.currentArrangement
        delegate.currentArrangement = arrangement

        if oldArrangement.isEmpty {
            // Can't do incremental updates on an empty reloadable view.
            reloadableView.reloadDataSync()
        } else {
            // Compute the actual inserted index paths.
            // If indexes are inserted into a section that doesn't exist, then we insert the section instead.
            var batchUpdates = BatchUpdates()
            for pendingInsertedIndexPath in pendingInsertedIndexPaths {
                if pendingInsertedIndexPath.section >= oldArrangement.count {
                    batchUpdates.insertSections.addIndex(pendingInsertedIndexPath.section)
                } else {
                    batchUpdates.insertItems.append(pendingInsertedIndexPath)
                }
            }
            reloadableView.perform(batchUpdates: batchUpdates)
        }

        pendingInsertedIndexPaths.removeAll()
    }
}

/// Only updates the `ReloadableView` with the final arrangement.
private class BatchUpdateManager: ReloadableViewUpdateManager {

    override func apply(finalArrangement arrangement: [Section<[LayoutArrangement]>], batchUpdates: BatchUpdates?, completion: (() -> Void)?) {
        updateReloadableView(waitUntilFinished: true) { (reloadableView: ReloadableView) in
            guard let delegate = self.delegate else {
                return
            }

            // Batch updates don't work on an empty collection.
            let canBatchUpdate = !delegate.currentArrangement.isEmpty

            // Perform the update.
            delegate.currentArrangement = arrangement
            if canBatchUpdate, let batchUpdates = batchUpdates {
                reloadableView.perform(batchUpdates: batchUpdates)
            } else {
                reloadableView.reloadDataSync()
            }
            
            completion?()
        }
    }
}
