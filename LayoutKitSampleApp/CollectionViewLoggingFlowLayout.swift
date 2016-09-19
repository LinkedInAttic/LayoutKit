// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

class CollectionViewLoggingFlowLayout: UICollectionViewFlowLayout {

    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
//        print("invalidateLayoutWithContext \(context)")
        super.invalidateLayout(with: context)
    }

    override func prepare() {
//        print("prepare \(collectionView?.bounds) \(collectionView?.contentOffset)")
        super.prepare()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let la = super.layoutAttributesForElements(in: rect)
        NSLog("layoutAttributesForElementes(in: \(rect) \(la?.first?.frame)")
        return la
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        NSLog("layoutAttributesForItem(at: \(indexPath))")
        return super.layoutAttributesForItem(at: indexPath)
    }

    override var collectionViewContentSize: CGSize {
        NSLog("collectionViewContentSize \(super.collectionViewContentSize)")
        return super.collectionViewContentSize
    }

//    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
//        return true
//    }
}
