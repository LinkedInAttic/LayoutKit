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
    var reloadableView: ReloadableView? { get }
    var currentArrangement: [Section<[LayoutArrangement]>] { get set }
}

/// An object that manages updates for a ReloadableView and its data source.
protocol ReloadableViewUpdateManager {

    /// The delegate that this manager performs updates on.
    var delegate: ReloadableViewUpdateManagerDelegate? { get }

    /// The operation that this update manager is associated with.
    /// The update manager will stop updating the delegate
    /// if the operation is cancelled or dellocated.
    var operation: Operation? { get }

    /// Applies a partial arrangement to the delegate's reloadable view and data source.
    func apply(partialArrangement arrangement: [Section<[LayoutArrangement]>], insertedIndexPaths: [IndexPath])

    /// Applies the final arrangement to the delegate's reloadable view and data source.
    func apply(finalArrangement arrangement: [Section<[LayoutArrangement]>], batchUpdates: BatchUpdates?, completion: (() -> Void)?)
}

extension ReloadableViewUpdateManager {

    /// Applies the updates closure to the reloadable view on the main thread
    /// if the reloadable view has not beed deallocationed and if the operation is not cancelled.
    func updateReloadableView(waitUntilFinished: Bool, updates: @escaping (_ reloadableView: ReloadableView) -> Void) {
        let mainOperation = BlockOperation()
        mainOperation.addExecutionBlock {
            let operationCancelled = self.operation?.isCancelled ?? true
            guard !operationCancelled, let reloadableView = self.delegate?.reloadableView else {
                return
            }
            updates(reloadableView)
        }
        OperationQueue.main.addOperations([mainOperation], waitUntilFinished: waitUntilFinished)
    }
}

/// Base class for implementations of ReloadableViewUpdateManager.
class BaseReloadableViewUpdateManager {
    weak var delegate: ReloadableViewUpdateManagerDelegate?
    weak var operation: Operation?

    init(delegate: ReloadableViewUpdateManagerDelegate, operation: Operation) {
        self.delegate = delegate
        self.operation = operation
    }
}

/// Updates the `ReloadableView` incrementally as items are inserted.
class IncrementalUpdateManager: BaseReloadableViewUpdateManager, ReloadableViewUpdateManager {

    private var pendingInsertedIndexPaths = [IndexPath]()

    func apply(partialArrangement arrangement: [Section<[LayoutArrangement]>], insertedIndexPaths: [IndexPath]) {
        updateReloadableView(waitUntilFinished: false) { (reloadableView: ReloadableView) in
            self.pendingInsertedIndexPaths += insertedIndexPaths

            // Don't modify the data while the view is moving.
            // Doing so causes weird artifacts (i.e. "bouncing" breaks).
            // We will try again on the next loop iteration or when the final arrangement is applied.
            if reloadableView.isTracking || reloadableView.isDecelerating {
                return
            }

            self.flushPendingInserts(arrangement: arrangement, reloadableView: reloadableView)
        }
    }

    func apply(finalArrangement arrangement: [Section<[LayoutArrangement]>], batchUpdates: BatchUpdates?, completion: (() -> Void)?) {
        updateReloadableView(waitUntilFinished: true) { (reloadableView: ReloadableView) in
            self.flushPendingInserts(arrangement: arrangement, reloadableView: reloadableView)
            completion?()
        }
    }

    private func flushPendingInserts(arrangement: [Section<[LayoutArrangement]>], reloadableView: ReloadableView) {
        assert(Thread.isMainThread, "flushPendingInserts must be called on the main thread")

        guard let delegate = self.delegate else {
            return
        }

        let oldArrangement = delegate.currentArrangement
        delegate.currentArrangement = arrangement

        if oldArrangement.isEmpty {
            // Can't do incremental updates on an empty reloadable view.
            reloadableView.reloadDataSynchronously()
        } else {
            // Compute the actual inserted index paths.
            // If indexes are inserted into a section that doesn't exist, then we insert the section instead.
            let batchUpdates = BatchUpdates()
            for pendingInsertedIndexPath in pendingInsertedIndexPaths {
                if pendingInsertedIndexPath.section >= oldArrangement.count {
                    batchUpdates.insertSections.insert(pendingInsertedIndexPath.section)
                } else {
                    batchUpdates.insertItems.append(pendingInsertedIndexPath)
                }
            }
            reloadableView.perform(batchUpdates: batchUpdates, completion: nil)
        }

        pendingInsertedIndexPaths.removeAll(keepingCapacity: true)
    }
}

/// Only updates the `ReloadableView` with the final arrangement.
class BatchUpdateManager: BaseReloadableViewUpdateManager, ReloadableViewUpdateManager {

    func apply(partialArrangement arrangement: [Section<[LayoutArrangement]>], insertedIndexPaths: [IndexPath]) {
        // Nothing to do here. This update strategy ignores partial arrangements.
    }

    func apply(finalArrangement arrangement: [Section<[LayoutArrangement]>], batchUpdates: BatchUpdates?, completion: (() -> Void)?) {
        updateReloadableView(waitUntilFinished: true) { (reloadableView: ReloadableView) in
            guard let delegate = self.delegate else {
                return
            }

            // Batch updates don't work on an empty collection.
            let canBatchUpdate = !delegate.currentArrangement.isEmpty

            // Perform the update.
            delegate.currentArrangement = arrangement
            if canBatchUpdate, let batchUpdates = batchUpdates {
                reloadableView.perform(batchUpdates: batchUpdates, completion: completion)
            } else {
                reloadableView.reloadDataSynchronously()
                completion?()
            }
        }
    }
}
