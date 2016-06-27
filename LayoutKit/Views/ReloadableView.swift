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
     The axis which is scrollable.
     */
    func scrollAxis() -> Axis

    /**
     Reloads the data synchronously.
     This means that it must be safe to immediately call other operations such as `insert`.
     */
    func reloadDataSync()


    /**
     Registers views for the reuse identifier.
     */
    func registerViews(reuseIdentifier reuseIdentifier: String)

    /// Inserts sections into the reloadable view.
    func insert(sections sections: NSIndexSet)

    /// Inserts index paths into the reloadable view.
    func insert(indexPaths indexPaths: [NSIndexPath])
}

// MARK: - UICollectionView

/// Make UICollectionView conform to ReloadableView protocol.
extension UICollectionView: ReloadableView {
    
    public func scrollAxis() -> Axis {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            switch flowLayout.scrollDirection {
            case .Vertical:
                return .vertical
            case .Horizontal:
                return .horizontal
            }
        }
        return .vertical
    }

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

    public func insert(indexPaths indexPaths: [NSIndexPath]) {
        insertItemsAtIndexPaths(indexPaths)
    }

    public func insert(sections sections: NSIndexSet) {
        insertSections(sections)
    }
}

// MARK: - UITableView

/// Make UITableView conform to ReloadableView protocol.
extension UITableView: ReloadableView {

    public func scrollAxis() -> Axis {
        return .vertical
    }

    public func reloadDataSync() {
        reloadData()
    }

    public func registerViews(reuseIdentifier reuseIdentifier: String) {
        registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }

    public func insert(sections sections: NSIndexSet) {
        insertSections(sections, withRowAnimation: .None)
    }

    public func insert(indexPaths indexPaths: [NSIndexPath]) {
        insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
    }
}