// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/**
 Manages background layout for reloadable views, including UICollectionView and UITableView.

 Set it as a UICollectionView or UITableView's dataSource and delegate.
 */
public class ReloadableViewLayoutAdapter: NSObject, ReloadableViewUpdateManagerDelegate {

    let reuseIdentifier = String(ReloadableViewLayoutAdapter)

    /// The current layout arrangement.
    /// Must be accessed from the main thread only.
    public internal(set) var currentArrangement = [Section<[LayoutArrangement]>]()

    /// The queue that layouts are computed on.
    let backgroundLayoutQueue: NSOperationQueue = {
        let queue = NSOperationQueue()
        queue.name = String(ReloadableViewLayoutAdapter)
        // The queue is serial so we can do streaming properly.
        // If a new layout request comes it, the existing request will be cancelled and terminate as quickly as possible.
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .UserInitiated
        return queue
    }()

    weak var reloadableView: ReloadableView?

    /// Logs messages.
    public var logger: ((String) -> Void)? = nil

    public init(reloadableView: ReloadableView) {
        self.reloadableView = reloadableView
        reloadableView.registerViews(reuseIdentifier: reuseIdentifier)
    }

    /**
     Reloads the view with the new layout.

     If synchronous is false and if the view doesn't already have data loaded, then reload will incrementally insert cells into the reloadable view
     as layouts are computed to increase user perceived performance for large collections.

     - parameter width: The width of the layout's arrangement. Nil means no constraint. Default is nil.
     - parameter height: The height of the layout's arrangement. Nil means no constraint. Default is nil.
     - parameter synchronous: If true, `reload` will not return until the operation is complete. Default is false.
     - parameter batchUpdates: The updates to apply to the reloadable view after the layout is computed. If nil, then all data will be reloaded. Default is nil.
     - parameter layoutProvider: A closure that produces the layout. It is called on a background thread so it must be threadsafe.
     - parameter completion: A closure that is called on the main thread when the operation is complete.
     */
    public func reload<T: CollectionType, U: CollectionType where U.Generator.Element == Layout, T.Generator.Element == Section<U>>(
        width width: CGFloat? = nil,
              height: CGFloat? = nil,
              synchronous: Bool = false,
              batchUpdates: BatchUpdates? = nil,
              layoutProvider: Void -> T,
              completion: (() -> Void)? = nil) {

        assert(NSThread.isMainThread(), "reload must be called on the main thread")

        // All previous layouts are invalid.
        backgroundLayoutQueue.cancelAllOperations()

        let layoutFunc = { (layout: Layout) -> LayoutArrangement in
            return layout.arrangement(width: width, height: height)
        }

        if synchronous {
            reloadSynchronously(with: layoutProvider, layoutFunc: layoutFunc, batchUpdates: batchUpdates, completion: completion)
        } else {
            reloadAsynchronously(with: layoutProvider, layoutFunc: layoutFunc, batchUpdates: batchUpdates, completion: completion)
        }
    }

    private func reloadSynchronously<T: CollectionType, U: CollectionType where U.Generator.Element == Layout, T.Generator.Element == Section<U>>(
        with layoutProvider: Void -> T,
             layoutFunc: Layout -> LayoutArrangement,
             batchUpdates: BatchUpdates?,
             completion: (Void -> Void)?) {

        let start = CFAbsoluteTimeGetCurrent()
        currentArrangement = layoutProvider().map { sectionLayout in
            return sectionLayout.map(layoutFunc)
        }
        if let batchUpdates = batchUpdates {
            reloadableView?.perform(batchUpdates: batchUpdates)
        } else {
            reloadableView?.reloadDataSync()
        }
        let end = CFAbsoluteTimeGetCurrent()
        logger?("user: \((end-start).ms)")
        completion?()
    }

    private func reloadAsynchronously<T: CollectionType, U: CollectionType where U.Generator.Element == Layout, T.Generator.Element == Section<U>>(
        with layoutProvider: Void -> T,
             layoutFunc: Layout -> LayoutArrangement,
             batchUpdates: BatchUpdates?,
             completion: (Void -> Void)?) {

        let start = CFAbsoluteTimeGetCurrent()
        let operation = NSBlockOperation()

        // Only do incremental rendering if there is currently no data and if there are no batch updates.
        // Otherwise wait for layout to complete before updating the view.
        let incremental = currentArrangement.isEmpty && batchUpdates == nil
        let updateManager = ReloadableViewUpdateManager.make(delegate: self, operation: operation, incremental: incremental)

        operation.addExecutionBlock { [weak operation] in
            var pendingArrangement = [Section<[LayoutArrangement]>]()
            for (sectionIndex, sectionLayout) in layoutProvider().enumerate() {
                if operation?.cancelled ?? true {
                    return
                }

                let header = sectionLayout.header.map(layoutFunc)
                let footer = sectionLayout.footer.map(layoutFunc)
                var items = [LayoutArrangement]()

                for (itemIndex, itemLayout) in sectionLayout.items.enumerate() {
                    if operation?.cancelled ?? true {
                        return
                    }

                    items.append(layoutFunc(itemLayout))

                    let partialSection = Section(header: header, items: items, footer: footer)
                    var partialArrangement = pendingArrangement
                    partialArrangement.append(partialSection)
                    let insertedIndexPath = NSIndexPath(forItem: itemIndex, inSection: sectionIndex)
                    updateManager.apply(partialArrangement: partialArrangement, insertedIndexPath: insertedIndexPath)
                }

                let pendingSection = Section(header: header, items: items, footer: footer)
                pendingArrangement.append(pendingSection)
            }
            updateManager.apply(finalArrangement: pendingArrangement, batchUpdates: batchUpdates, completion: { [weak self] in
                let end = CFAbsoluteTimeGetCurrent()
                self?.logger?("user: \((end-start).ms)")
                completion?()
            })
        }

        backgroundLayoutQueue.addOperation(operation)
    }

    /**
     Reloads the view with a precomputed layout.
     It must be called on the main thread.

     This is useful if you want to precompute the layout for this collection view as part of another layout.
     One example is nested collection/table views (see NestedCollectionViewController.swift in the sample app).
     */
    public func reload(arrangement arrangement: [Section<[LayoutArrangement]>]) {
        assert(NSThread.isMainThread(), "reload must be called on the main thread")
        backgroundLayoutQueue.cancelAllOperations()
        currentArrangement = arrangement
        reloadableView?.reloadDataSync()
    }
}

/// A section in a `ReloadableView`.
public struct Section<C: CollectionType> {

    typealias T = C.Generator.Element

    public let header: T?
    public let items: C
    public let footer: T?

    public init(header: T? = nil, items: C, footer: T? = nil) {
        self.header = header
        self.items = items
        self.footer = footer
    }

    public func map<U>(mapper: T -> U) -> Section<[U]> {
        let header = self.header.map(mapper)
        let items = self.items.map(mapper)
        let footer = self.footer.map(mapper)
        return Section<[U]>(header: header, items: items, footer: footer)
    }
}