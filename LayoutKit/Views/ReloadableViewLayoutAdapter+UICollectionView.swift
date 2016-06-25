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

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return currentArrangement[(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).item].frame.size
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return currentArrangement[section].header?.frame.size ?? CGSize.zero
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return currentArrangement[section].footer?.frame.size ?? CGSize.zero
    }
}

// MARK: - UICollectionViewDataSource

extension ReloadableViewLayoutAdapter: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentArrangement[section].items.count
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentArrangement.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = currentArrangement[(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        _ = item.makeViews(inView: cell.contentView)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
        let arrangement: LayoutArrangement?
        switch kind {
        case UICollectionElementKindSectionHeader:
            arrangement = currentArrangement[(indexPath as NSIndexPath).section].header
        case UICollectionElementKindSectionFooter:
            arrangement = currentArrangement[(indexPath as NSIndexPath).section].footer
        default:
            arrangement = nil
            assertionFailure("unknown supplementary view kind \(kind)")
        }
        _ = arrangement?.makeViews(inView: view)
        return view
    }
}
