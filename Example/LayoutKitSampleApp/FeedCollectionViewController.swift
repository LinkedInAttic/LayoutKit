// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit

/// Displays the feed using a UICollectionView.
class FeedCollectionViewController: FeedBaseViewController {

    private var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor.purple

        reloadableViewLayoutAdapter = ReloadableViewLayoutAdapter(reloadableView: collectionView)
        collectionView.dataSource = reloadableViewLayoutAdapter
        collectionView.delegate = reloadableViewLayoutAdapter

        view.addSubview(collectionView)
        self.layoutFeed(width: collectionView.frame.width, synchronous: false)
    }

    private func layoutFeed(width: CGFloat, synchronous: Bool) {
        reloadableViewLayoutAdapter.reload(width: width, synchronous: synchronous, layoutProvider: { [weak self] in
            return [Section(header: nil, items: self?.getFeedItems() ?? [], footer: nil)]
        })
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        layoutFeed(width: size.width, synchronous: true)
    }
}


