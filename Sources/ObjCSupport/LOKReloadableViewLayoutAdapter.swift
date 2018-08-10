// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/**
 Manages background layout for reloadable views, including `UICollectionView` and `UITableView`.

 Set it as a `UICollectionView` or `UITableView`s dataSource and delegate.
 */
@objc open class LOKReloadableViewLayoutAdapter: NSObject {
    @objc public var log: ((String) -> Void)? {
        get {
            return adapter.logger
        }
        set {
            adapter.logger = newValue
        }
    }

    let adapter: ReloadableViewLayoutAdapter

    @objc public init(collectionView: UICollectionView) {
        adapter = ReloadableViewLayoutAdapter(reloadableView: collectionView)
    }

    @objc public init(tableView: UITableView) {
        adapter = ReloadableViewLayoutAdapter(reloadableView: tableView)
    }

    /**
     Reloads the view with the new layout.

     If synchronous is `false` and the view doesn't already have data loaded and no batch updates are provided,
     then it will incrementally insert cells into the reloadable view as layouts are computed
     to increase user perceived performance for large collections. Pass an empty `BatchUpdates` object
     if you wish to disable this optimization for an asynchronous reload of an empty collection.

     - parameter synchronous: If true, `reload` will not return until the operation is complete.
     - parameter width: The width of the layout's arrangement. `Nil` means no constraint. Default is `infinity`.
     - parameter height: The height of the layout's arrangement. `Nil` means no constraint. Default is `infinity`.
     - parameter batchUpdates: The updates to apply to the reloadable view after the layout is computed. If `nil`, then all data will be reloaded. Default is `nil`.
     - parameter layoutProvider: A closure that produces the layout. It is called on a background thread so it must be threadsafe.
     - parameter completion: A closure that is called on the main thread when the operation is complete.
     */
    @objc open func reload(synchronous: Bool,
                           width: CGFloat = CGFloat.infinity,
                           height: CGFloat = CGFloat.infinity,
                           batchUpdates: LOKBatchUpdates? = nil,
                           layoutProvider: @escaping () -> [LOKLayoutSection],
                           completion: (() -> Void)? = nil) {
        adapter.reload(
            width: width.isFinite ? width : nil,
            height: height.isFinite ? height : nil,
            synchronous: synchronous,
            batchUpdates: batchUpdates?.unwrapped,
            layoutProvider: { return layoutProvider().map { $0.unwrapped } },
            completion: completion)
    }

    /**
     Reloads the view with a precomputed layout.
     It must be called on the main thread.

     This is useful if you want to precompute the layout for this collection view as part of another layout.
     One example is nested collection/table views (see `NestedCollectionViewController.swift` in the sample app).
     */
    @objc open func reload(arrangements: [LOKLayoutArrangementSection]) {
        adapter.reload(arrangement: arrangements.map { $0.unwrapped })
    }
}

extension LOKReloadableViewLayoutAdapter: UITableViewDelegate {

    @objc open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return adapter.tableView(tableView, heightForRowAt: indexPath)
    }

    @objc open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return adapter.tableView(tableView, heightForHeaderInSection: section)
    }

    @objc open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return adapter.tableView(tableView, heightForFooterInSection: section)
    }

    @objc open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return adapter.tableView(tableView, viewForHeaderInSection: section)
    }

    @objc open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return adapter.tableView(tableView, viewForFooterInSection: section)
    }
}

extension LOKReloadableViewLayoutAdapter: UITableViewDataSource {

    @objc open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adapter.tableView(tableView, numberOfRowsInSection: section)
    }

    @objc open func numberOfSections(in tableView: UITableView) -> Int {
        return adapter.numberOfSections(in: tableView)
    }

    @objc open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return adapter.tableView(tableView, cellForRowAt: indexPath)
    }
}

extension LOKReloadableViewLayoutAdapter: UICollectionViewDelegateFlowLayout {

    @objc open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return adapter.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }

    @objc open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return adapter.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
    }

    @objc open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return adapter.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForFooterInSection: section)
    }
}

extension LOKReloadableViewLayoutAdapter: UICollectionViewDataSource {
    @objc open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adapter.collectionView(collectionView, numberOfItemsInSection: section)
    }

    @objc open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return adapter.numberOfSections(in: collectionView)
    }

    @objc open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return adapter.collectionView(collectionView, cellForItemAt: indexPath)
    }

    @objc open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return adapter.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
}

