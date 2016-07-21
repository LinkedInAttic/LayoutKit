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

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return currentArrangement[indexPath.section].items[indexPath.item].frame.size
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return currentArrangement[section].header?.frame.size ?? CGSizeZero
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return currentArrangement[section].footer?.frame.size ?? CGSizeZero
    }
}

// MARK: - UICollectionViewDataSource

extension ReloadableViewLayoutAdapter: UICollectionViewDataSource {
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentArrangement[section].items.count
    }

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return currentArrangement.count
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = currentArrangement[indexPath.section].items[indexPath.item]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        item.makeViews(in: cell.contentView)
        return cell
    }

    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseIdentifier, forIndexPath: indexPath)
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