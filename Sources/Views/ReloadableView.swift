// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

// MARK: - ReloadableView

/**
 A view that can be reloaded with data.

 UITableView and UICollectionView conform to this protocol.
 */
public protocol ReloadableView: class {

    /// The bounds rectangle, which describes the view’s location and size in its own coordinate system.
    var bounds: CGRect { get }

    /// Returns whether the user has touched the content to initiate scrolling.
    var isTracking: Bool { get }

    /// Returns whether the content is moving in the scroll view after the user lifted their finger.
    var isDecelerating: Bool { get }

    /**
     Reloads the data synchronously.
     This means that it must be safe to immediately call other operations such as `insert`.
     */
    func reloadDataSynchronously()

    /// Registers views for the reuse identifier.
    func registerViews(withReuseIdentifier reuseIdentifier: String)

    /**
     Performs a set of updates in a batch.
     
     The reloadable view must follow the same semantics for handling the index paths
     of concurrent inserts/updates/deletes as UICollectionView documents in `performBatchUpdates`.
     */
    func perform(batchUpdates: BatchUpdates, completion: (() -> Void)?)
}

// MARK: - UICollectionView

/// Make UICollectionView conform to ReloadableView protocol.
extension UICollectionView: ReloadableView {

    @objc
    open func reloadDataSynchronously() {
        reloadData()

        // Force a layout so that it is safe to call insert after this.
        layoutIfNeeded()
    }

    @objc
    open func registerViews(withReuseIdentifier reuseIdentifier: String) {
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
        register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseIdentifier)
    }

    @objc
    open func perform(batchUpdates: BatchUpdates, completion: (() -> Void)?) {
        performBatchUpdates({
            if batchUpdates.insertItems.count > 0 {
                self.insertItems(at: batchUpdates.insertItems)
            }
            if batchUpdates.deleteItems.count > 0 {
                self.deleteItems(at: batchUpdates.deleteItems)
            }
            if batchUpdates.reloadItems.count > 0 {
                self.reloadItems(at: batchUpdates.reloadItems)
            }
            for move in batchUpdates.moveItems {
                self.moveItem(at: move.from, to: move.to)
            }

            if batchUpdates.insertSections.count > 0 {
                self.insertSections(batchUpdates.insertSections)
            }
            if batchUpdates.deleteSections.count > 0 {
                self.deleteSections(batchUpdates.deleteSections)
            }
            if batchUpdates.reloadSections.count > 0 {
                self.reloadSections(batchUpdates.reloadSections)
            }
            for move in batchUpdates.moveSections {
                self.moveSection(move.from, toSection: move.to)
            }
        }, completion: { _ in
            completion?()
        })
    }
}

// MARK: - UITableView

/// Make UITableView conform to ReloadableView protocol.
extension UITableView: ReloadableView {

    @objc
    open func reloadDataSynchronously() {
        reloadData()
    }

    @objc
    open func registerViews(withReuseIdentifier reuseIdentifier: String) {
        register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }

    @objc
    open func perform(batchUpdates: BatchUpdates, completion: (() -> Void)?) {
        beginUpdates()

        // Update items.
        if batchUpdates.insertItems.count > 0 {
            insertRows(at: batchUpdates.insertItems, with: .automatic)
        }
        if batchUpdates.deleteItems.count > 0 {
            deleteRows(at: batchUpdates.deleteItems, with: .automatic)
        }
        if batchUpdates.reloadItems.count > 0 {
            reloadRows(at: batchUpdates.reloadItems, with: .automatic)
        }
        for move in batchUpdates.moveItems {
            moveRow(at: move.from, to: move.to)
        }

        // Update sections.
        if batchUpdates.insertSections.count > 0 {
            insertSections(batchUpdates.insertSections, with: .automatic)
        }
        if batchUpdates.deleteSections.count > 0 {
            deleteSections(batchUpdates.deleteSections, with: .automatic)
        }
        if batchUpdates.reloadSections.count > 0 {
            reloadSections(batchUpdates.reloadSections, with: .automatic)
        }
        for move in batchUpdates.moveSections {
            moveSection(move.from, toSection: move.to)
        }

        endUpdates()

        completion?()
    }
}
