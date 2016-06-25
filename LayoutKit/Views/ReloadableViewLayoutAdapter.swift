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
public class ReloadableViewLayoutAdapter: NSObject {

    let reuseIdentifier = String(ReloadableViewLayoutAdapter)

    /// The current layout arrangement.
    private(set) var currentArrangement = [Section<[LayoutArrangement]>]()

    /// The queue that layouts are computed on.
    let backgroundLayoutQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = String(ReloadableViewLayoutAdapter)
        // The queue is serial so we can do streaming properly.
        // If a new layout request comes it, the existing request will be cancelled and terminate as quickly as possible.
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
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
     It must be called on the main thread.

     The layout is computed given a width or height constraint
     (whichever is perpendicular to the view's layout axis).

     If synchronous is false and if the view doesn't already have data loaded, then reload will incrementally render the layout as cells are computed.
     layoutProvider will be called on a background thread in this case.

     If synchronous is true, then the view will be reloaded with the new layout.
     */
    public func reload<T: Collection, U: Collection where U.Iterator.Element == Layout, T.Iterator.Element == Section<U>>(
        width: CGFloat = CGFloat.greatestFiniteMagnitude,
              height: CGFloat = CGFloat.greatestFiniteMagnitude,
              synchronous: Bool = false,
              layoutProvider: (Void) -> T,
              completion: ((Void) -> Void)? = nil) {

        assert(Thread.isMainThread(), "reload must be called on the main thread")

        // All previous layouts are invalid.
        backgroundLayoutQueue.cancelAllOperations()

        guard width > 0 && height > 0 else {
            return
        }

        guard let reloadableView = reloadableView else {
            return
        }

        let axis = reloadableView.scrollAxis() // avoid capturing the reloadableView in the layout function.
        func layout(_ layout: Layout) -> LayoutArrangement {
            switch axis {
            case .vertical:
                return layout.arrangement(width: width)
            case .horizontal:
                return layout.arrangement(height: height)
            }
        }

        if synchronous {
            reloadSynchronously(layoutFunc: layout, layoutProvider: layoutProvider, completion: completion)
        } else {
            reloadAsynchronously(layoutFunc: layout, layoutProvider: layoutProvider, completion: completion)
        }
    }


    /**
     Reloads the view with a precomputed layout.
     It must be called on the main thread.

     This is useful if you want to precompute the layout for this collection view as part of another layout.
     One example is nested collection/table views (see NestedCollectionViewController.swift in the sample app).
     */
    public func reload(arrangement: [Section<[LayoutArrangement]>]) {
        assert(Thread.isMainThread(), "reload must be called on the main thread")
        backgroundLayoutQueue.cancelAllOperations()
        currentArrangement = arrangement
        reloadableView?.reloadDataSync()
    }

    private func reloadSynchronously<T: Collection, U: Collection where U.Iterator.Element == Layout, T.Iterator.Element == Section<U>>(
        layoutFunc: (Layout) -> LayoutArrangement,
                   layoutProvider: (Void) -> T,
                   completion: ((Void) -> Void)? = nil) {

        let start = CFAbsoluteTimeGetCurrent()
        currentArrangement = layoutProvider().map { sectionLayout in
            return sectionLayout.map(layoutFunc)
        }
        reloadableView?.reloadDataSync()
        let end = CFAbsoluteTimeGetCurrent()
        logger?("user: \((end-start).ms)")
        completion?()
    }

    private func reloadAsynchronously<T: Collection, U: Collection where U.Iterator.Element == Layout, T.Iterator.Element == Section<U>>(
        layoutFunc: (Layout) -> LayoutArrangement,
                   layoutProvider: (Void) -> T,
                   completion: ((Void) -> Void)? = nil) {

        let start = CFAbsoluteTimeGetCurrent()
        var timeOnMainThread: CFAbsoluteTime = 0
        defer {
            timeOnMainThread += CFAbsoluteTimeGetCurrent() - start
        }

        // Only do incremental rendering if there is currently no data.
        // Otherwise wait for layout to complete before updating the view.
        let incremental = currentArrangement.isEmpty

        let operation = BlockOperation()
        operation.addExecutionBlock { [weak self, weak operation] in

            // Any time we want to get the reloadable view, check to see if the operation has been cancelled.
            let reloadableView: (Void) -> ReloadableView? = {
                if operation?.isCancelled ?? true {
                    return nil
                }
                return self?.reloadableView
            }

            var pendingArrangement = [Section<[LayoutArrangement]>]()
            var pendingInserts = [IndexPath]() // Used for incremental rendering.
            for (sectionIndex, sectionLayout) in layoutProvider().enumerated() {
                let header = sectionLayout.header.map(layoutFunc)
                let footer = sectionLayout.footer.map(layoutFunc)
                var items = [LayoutArrangement]()

                for (itemIndex, itemLayout) in sectionLayout.items.enumerated() {
                    guard reloadableView() != nil else {
                        return
                    }

                    items.append(layoutFunc(itemLayout))

                    if !incremental {
                        continue
                    }

                    pendingInserts.append(IndexPath(item: itemIndex, section: sectionIndex))

                    // Create a copy of the pending layout and append the incremental layout state for this section.
                    var incrementalArrangement = pendingArrangement
                    incrementalArrangement.append(Section(header: header, items: items, footer: footer))

                    // Dispatch sync to main thread to render the incremental layout.
                    // Sync is necessary so that it can modify pendingInserts after the incremental render.
                    // If the incremental render is skipped, then pendingInserts will remain unchanged.
                    // TODO: this would probably be better as dispatch_async so that this thread can continue
                    // to compute layouts in the background. Changing this would require some more complex logic.
                    DispatchQueue.main.sync(execute: {
                        let startMain = CFAbsoluteTimeGetCurrent()
                        defer {
                            timeOnMainThread += CFAbsoluteTimeGetCurrent() - startMain
                        }

                        guard let reloadableView = reloadableView() else {
                            return
                        }

                        // Don't modify the data while the view is moving.
                        // Doing so causes weird artifacts (i.e. "bouncing" breaks).
                        // We will try again on the next loop iteration.
                        if reloadableView.tracking || reloadableView.decelerating {
                            return
                        }

                        self?.update(
                            pendingArrangement: incrementalArrangement,
                            insertedIndexPaths: pendingInserts,
                            reloadableView: reloadableView,
                            incremental: incremental
                        )

                        pendingInserts.removeAll()
                    })
                }

                pendingArrangement.append(Section(header: header, items: items, footer: footer))
            }

            // Do the final render.
            DispatchQueue.main.sync(execute: {
                let startMain = CFAbsoluteTimeGetCurrent()
                defer {
                    timeOnMainThread += CFAbsoluteTimeGetCurrent() - start
                }

                guard let reloadableView = reloadableView() else {
                    return
                }

                self?.update(pendingArrangement: pendingArrangement, insertedIndexPaths: pendingInserts, reloadableView: reloadableView, incremental: incremental)

                let end = CFAbsoluteTimeGetCurrent()
                // The amount of time spent on the main thread may be high, but the user impact is small because
                // we are dispatching small blocks and not doing any work if the user is interacting.
                self?.logger?("user: \((end-start).ms) (main: \((timeOnMainThread + end - startMain).ms))")
                completion?()
            })
        }

        backgroundLayoutQueue.addOperation(operation)
    }

    private func update(pendingArrangement: [Section<[LayoutArrangement]>],
                                           insertedIndexPaths: [IndexPath],
                                           reloadableView: ReloadableView,
                                           incremental: Bool) {

        let empty = currentArrangement.isEmpty
        let previousSectionCount = currentArrangement.count
        currentArrangement = pendingArrangement

        if empty || !incremental {
            reloadableView.reloadDataSync()
            return
        }

        let insertedSections = NSMutableIndexSet()
        var reducedInsertedIndexPaths = [IndexPath]()

        for insertedIndexPath in insertedIndexPaths {
            if (insertedIndexPath as NSIndexPath).section > previousSectionCount - 1 {
                insertedSections.add((insertedIndexPath as NSIndexPath).section)
            } else {
                reducedInsertedIndexPaths.append(insertedIndexPath)
            }
        }

        if reducedInsertedIndexPaths.count > 0 {
            reloadableView.insert(indexPaths: reducedInsertedIndexPaths)
        }

        if insertedSections.count > 0 {
            reloadableView.insert(sections: insertedSections as IndexSet)
        }
    }
}

// MARK: - Data structures

public struct Section<C: Collection> {

    typealias T = C.Iterator.Element

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
