// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

// MARK: - UICollectionViewDelegateFlowLayout

extension ReloadableViewLayoutAdapter: UICollectionViewDelegateFlowLayout {

    /// - Attention: Not calling super may result in unexpected behaviour
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return currentArrangement[indexPath.section].items[indexPath.item].frame.size
    }

    /// - Attention: Not calling super may result in unexpected behaviour
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return currentArrangement[section].header?.frame.size ?? .zero
    }

    /// - Attention: Not calling super may result in unexpected behaviour
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return currentArrangement[section].footer?.frame.size ?? .zero
    }
}

// MARK: - UICollectionViewDataSource

extension ReloadableViewLayoutAdapter: UICollectionViewDataSource {

    /// - Attention: Not calling super may result in unexpected behaviour
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentArrangement[section].items.count
    }

    /// - Attention: Not calling super may result in unexpected behaviour
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentArrangement.count
    }

    /// - Attention: Not calling super may result in unexpected behaviour
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = currentArrangement[indexPath.section].items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        item.makeViews(in: cell.contentView)
        return cell
    }

    /// - Attention: Not calling super may result in unexpected behaviour
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
        let arrangement: LayoutArrangement?
        switch kind {
        case UICollectionElementKindSectionHeader:
            arrangement = currentArrangement[indexPath.section].header
        case UICollectionElementKindSectionFooter:
            arrangement = currentArrangement[indexPath.section].footer
        default:
            arrangement = nil
            assertionFailure("unknown supplementary view kind \(kind)")
        }
        arrangement?.makeViews(in: view)
        return view
    }
}
