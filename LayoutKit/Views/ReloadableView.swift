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
    func scrollAxis() -> LayoutAxis

    /**
     Reloads the data synchronously.
     This means that it must be safe to immediately call other operations such as `insert`.
     */
    func reloadDataSync()


    /**
     Registers views for the reuse identifier.
     */
    func registerViews(reuseIdentifier: String)

    /// Inserts sections into the reloadable view.
    func insert(sections: IndexSet)

    /// Inserts index paths into the reloadable view.
    func insert(indexPaths: [IndexPath])
}

// MARK: - UICollectionView

/// Make UICollectionView conform to ReloadableView protocol.
extension UICollectionView: ReloadableView {
    
    public func scrollAxis() -> LayoutAxis {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            switch flowLayout.scrollDirection {
            case .vertical:
                return .vertical
            case .horizontal:
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

    public func registerViews(reuseIdentifier: String) {
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
        register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: reuseIdentifier)
    }

    public func insert(indexPaths: [IndexPath]) {
        insertItems(at: indexPaths)
    }

    public func insert(sections: IndexSet) {
        insertSections(sections)
    }
}

// MARK: - UITableView

/// Make UITableView conform to ReloadableView protocol.
extension UITableView: ReloadableView {

    public func scrollAxis() -> LayoutAxis {
        return .vertical
    }

    public func reloadDataSync() {
        reloadData()
    }

    public func registerViews(reuseIdentifier: String) {
        register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }

    public func insert(sections: IndexSet) {
        insertSections(sections, with: .none)
    }

    public func insert(indexPaths: [IndexPath]) {
        insertRows(at: indexPaths, with: .none)
    }
}
