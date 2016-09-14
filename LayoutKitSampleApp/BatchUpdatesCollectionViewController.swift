// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit

/// Example of how batch updates work with a UICollectionView.
class BatchUpdatesCollectionViewController: BatchUpdatesBaseViewController {
    private var collectionView: LayoutAdapterCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        layout.minimumLineSpacing = 2

        collectionView = LayoutAdapterCollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor.white

        view.addSubview(collectionView)
        collectionView.layoutAdapter.reload(width: collectionView.bounds.width, synchronous: true, layoutProvider: layoutOne)

        let delay = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.collectionView.layoutAdapter.reload(
                width: self.collectionView.bounds.width,
                synchronous: true,
                batchUpdates: self.batchUpdates(),
                layoutProvider: self.layoutTwo)
        }
    }
}
