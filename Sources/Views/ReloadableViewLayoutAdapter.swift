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
open class ReloadableViewLayoutAdapter: NSObject, ReloadableViewUpdateManagerDelegate {

    let reuseIdentifier = String(describing: ReloadableViewLayoutAdapter.self)

    /// The current layout arrangement.
    /// Must be accessed from the main thread only.
    open internal(set) var currentArrangement = [Section<[LayoutArrangement]>]()

    /// The queue that layouts are computed on.
    public let backgroundLayoutQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = String(describing: ReloadableViewLayoutAdapter.self)
        // The queue is serial so we can do streaming properly.
        // If a new layout request comes it, the existing request will be cancelled and terminate as quickly as possible.
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        return queue
    }()

    weak var reloadableView: ReloadableView?

    /// Logs messages.
    open var logger: ((String) -> Void)? = nil

    public init(reloadableView: ReloadableView) {
        self.reloadableView = reloadableView
        reloadableView.registerViews(withReuseIdentifier: reuseIdentifier)
    }

    /**
     Reloads the view with the new layout.

     If synchronous is false and the view doesn't already have data loaded and no batch updates are provided,
     then it will incrementally insert cells into the reloadable view as layouts are computed
     to increase user perceived performance for large collections. Pass an empty `BatchUpdates` object
     if you wish to disable this optimization for an asynchronous reload of an empty collection.

     - parameter width: The width of the layout's arrangement. Nil means no constraint. Default is nil.
     - parameter height: The height of the layout's arrangement. Nil means no constraint. Default is nil.
     - parameter synchronous: If true, `reload` will not return until the operation is complete. Default is false.
     - parameter batchUpdates: The updates to apply to the reloadable view after the layout is computed. If nil, then all data will be reloaded. Default is nil.
     - parameter layoutProvider: A closure that produces the layout. It is called on a background thread so it must be threadsafe.
     - parameter completion: A closure that is called on the main thread when the operation is complete.
     */
    open func reload<T: Collection, U: Collection>(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        synchronous: Bool = false,
        batchUpdates: BatchUpdates? = nil,
        layoutProvider: @escaping (Void) -> T,
        completion: (() -> Void)? = nil) where U.Iterator.Element == Layout, T.Iterator.Element == Section<U> {

        assert(Thread.isMainThread, "reload must be called on the main thread")

        // All previous layouts are invalid.
        backgroundLayoutQueue.cancelAllOperations()

        let layoutFunc = { (layout: Layout) -> LayoutArrangement in
            return layout.arrangement(width: width, height: height)
        }

        if synchronous {
            reloadSynchronously(layoutProvider: layoutProvider, layoutFunc: layoutFunc, batchUpdates: batchUpdates, completion: completion)
        } else {
            reloadAsynchronously(layoutProvider: layoutProvider, layoutFunc: layoutFunc, batchUpdates: batchUpdates, completion: completion)
        }
    }

    private func reloadSynchronously<T: Collection, U: Collection>(
        layoutProvider: (Void) -> T,
        layoutFunc: @escaping (Layout) -> LayoutArrangement,
        batchUpdates: BatchUpdates?,
        completion: ((Void) -> Void)?) where U.Iterator.Element == Layout, T.Iterator.Element == Section<U> {

        let start = CFAbsoluteTimeGetCurrent()
        currentArrangement = layoutProvider().map { sectionLayout in
            return sectionLayout.map(layoutFunc)
        }

        let completionAndLogEnd = {
            let end = CFAbsoluteTimeGetCurrent()
            self.logger?("user: \((end-start).ms)")
            completion?()
        }

        if let batchUpdates = batchUpdates {
            reloadableView?.perform(batchUpdates: batchUpdates, completion: completionAndLogEnd)
        } else {
            reloadableView?.reloadDataSynchronously()
            completionAndLogEnd()
        }
    }

    private func reloadAsynchronously<T: Collection, U: Collection>(
        layoutProvider: @escaping (Void) -> T,
        layoutFunc: @escaping (Layout) -> LayoutArrangement,
        batchUpdates: BatchUpdates?,
        completion: ((Void) -> Void)?) where U.Iterator.Element == Layout, T.Iterator.Element == Section<U> {

        let start = CFAbsoluteTimeGetCurrent()
        let operation = BlockOperation()

        // Only do incremental rendering if there is currently no data and if there are no batch updates.
        // Otherwise wait for layout to complete before updating the view.
        let incremental = currentArrangement.isEmpty && batchUpdates == nil
        let updateManager: ReloadableViewUpdateManager = incremental ?
            IncrementalUpdateManager(delegate: self, operation: operation) :
            BatchUpdateManager(delegate: self, operation: operation)

        operation.addExecutionBlock { [weak operation] in
            var pendingArrangement = [Section<[LayoutArrangement]>]()
            for (sectionIndex, sectionLayout) in layoutProvider().enumerated() {
                if operation?.isCancelled ?? true {
                    return
                }

                let header = sectionLayout.header.map(layoutFunc)
                let footer = sectionLayout.footer.map(layoutFunc)
                var items = [LayoutArrangement]()

                for (itemIndex, itemLayout) in sectionLayout.items.enumerated() {
                    if operation?.isCancelled ?? true {
                        return
                    }

                    items.append(layoutFunc(itemLayout))

                    let partialSection = Section(header: header, items: items, footer: footer)
                    var partialArrangement = pendingArrangement
                    partialArrangement.append(partialSection)
                    let insertedIndexPath = IndexPath(item: itemIndex, section: sectionIndex)
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
    open func reload(arrangement: [Section<[LayoutArrangement]>]) {
        assert(Thread.isMainThread, "reload must be called on the main thread")
        backgroundLayoutQueue.cancelAllOperations()
        currentArrangement = arrangement
        reloadableView?.reloadDataSynchronously()
    }

    /**
     Computes layouts without applying them on the view. Instead it returns a list of animations that
     that can be can be used to smoothly resize e.g CollectionViewCells.

     See Playground page CollectionView Animation in LayoutKit.playground for example
     */
    open func reload<T: Collection, U: Collection>(
        items: [IndexPath],
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        layoutProvider: @escaping (Void) -> T,
        completion: ([Animation]) -> Void) where U.Iterator.Element == Layout, T.Iterator.Element == Section<U> {

        let start = CFAbsoluteTimeGetCurrent()
        backgroundLayoutQueue.cancelAllOperations()

        let layoutFunc = { (layout: Layout) -> LayoutArrangement in
            return layout.arrangement(width: width, height: height)
        }

        currentArrangement = layoutProvider().map { sectionLayout in
            return sectionLayout.map(layoutFunc)
        }

        let animations: [Animation] = items.flatMap({ indexPath in
            guard let contentView = reloadableView?.contentView(forIndexPath: indexPath) else { return nil }
            let arrangement = currentArrangement[indexPath.section].items[indexPath.item]
            return arrangement.prepareAnimation(for: contentView)
        })

        let end = CFAbsoluteTimeGetCurrent()
        logger?("user: \((end-start).ms)")
        completion(animations)
    }
}

/// A section in a `ReloadableView`.
public struct Section<C: Collection> {

    public typealias T = C.Iterator.Element

    public let header: T?
    public let items: C
    public let footer: T?

    public init(header: T? = nil, items: C, footer: T? = nil) {
        self.header = header
        self.items = items
        self.footer = footer
    }

    public func map<U>(_ mapper: (T) -> U) -> Section<[U]> {
        let header = self.header.map(mapper)
        let items = self.items.map(mapper)
        let footer = self.footer.map(mapper)
        return Section<[U]>(header: header, items: items, footer: footer)
    }
}
