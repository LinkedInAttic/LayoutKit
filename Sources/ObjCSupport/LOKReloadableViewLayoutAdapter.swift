// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

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

