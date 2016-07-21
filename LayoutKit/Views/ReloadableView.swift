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
    var tracking: Bool { get }

    /// Returns whether the content is moving in the scroll view after the user lifted their finger.
    var decelerating: Bool { get }

    /**
     Reloads the data synchronously.
     This means that it must be safe to immediately call other operations such as `insert`.
     */
    func reloadDataSync()

    /// Registers views for the reuse identifier.
    func registerViews(reuseIdentifier reuseIdentifier: String)

    /// Performs a set of updates in a batch.
    func perform(batchUpdates batchUpdates: BatchUpdates)
}

// MARK: - UICollectionView

/// Make UICollectionView conform to ReloadableView protocol.
extension UICollectionView: ReloadableView {

    public func reloadDataSync() {
        reloadData()

        // Force a layout so that it is safe to call insert after this.
        layoutIfNeeded()
    }

    public func registerViews(reuseIdentifier reuseIdentifier: String) {
        registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
        registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: reuseIdentifier)
    }

    public func perform(batchUpdates batchUpdates: BatchUpdates) {
        performBatchUpdates({
            if batchUpdates.insertItemsAtIndexPaths.count > 0 {
                self.insertItemsAtIndexPaths(batchUpdates.insertItemsAtIndexPaths)
            }
            if batchUpdates.deleteItemsAtIndexPaths.count > 0 {
                self.deleteItemsAtIndexPaths(batchUpdates.deleteItemsAtIndexPaths)
            }
            for move in batchUpdates.moveItemsAtIndexPaths {
                self.moveItemAtIndexPath(move.from, toIndexPath: move.to)
            }

            if batchUpdates.insertSections.count > 0 {
                self.insertSections(batchUpdates.insertSections)
            }
            if batchUpdates.deleteSections.count > 0 {
                self.deleteSections(batchUpdates.deleteSections)
            }
            for move in batchUpdates.moveSections {
                self.moveSection(move.from, toSection: move.to)
            }
        }, completion: nil)
    }
}

// MARK: - UITableView

/// Make UITableView conform to ReloadableView protocol.
extension UITableView: ReloadableView {

    public func reloadDataSync() {
        reloadData()
    }

    public func registerViews(reuseIdentifier reuseIdentifier: String) {
        registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }

    public func perform(batchUpdates batchUpdates: BatchUpdates) {
        beginUpdates()

        // Update items.
        if batchUpdates.insertItemsAtIndexPaths.count > 0 {
            insertRowsAtIndexPaths(batchUpdates.insertItemsAtIndexPaths, withRowAnimation: .Automatic)
        }
        if batchUpdates.deleteItemsAtIndexPaths.count > 0 {
            deleteRowsAtIndexPaths(batchUpdates.deleteItemsAtIndexPaths, withRowAnimation: .Automatic)
        }
        for move in batchUpdates.moveItemsAtIndexPaths {
            moveRowAtIndexPath(move.from, toIndexPath: move.to)
        }

        // Update sections.
        if batchUpdates.insertSections.count > 0 {
            insertSections(batchUpdates.insertSections, withRowAnimation: .Automatic)
        }
        if batchUpdates.deleteSections.count > 0 {
            deleteSections(batchUpdates.deleteSections, withRowAnimation: .Automatic)
        }
        for move in batchUpdates.moveSections {
            moveSection(move.from, toSection: move.to)
        }

        endUpdates()
    }
}