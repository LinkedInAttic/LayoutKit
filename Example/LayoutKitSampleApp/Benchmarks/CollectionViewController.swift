// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/// Each view type of collection view should be a non-generic subclass from CollectionViewController
/// If each view type uses the generic CollectionViewController, it will cause the crash.
///
/// The crash reproduce steps: BenchmarkViewController -> UICollectionViewUIStackFeed
/// -> Back -> Any other UICollectionView
///
/// The reason behinds this is `DWURecyclingAlert` injects benchmark and label by using
/// method swizzling. Method swizzling doesn't work well with generics. The second time
/// of method sizzling would not work and bring into infinite loop if different view type
/// uses `CollectionViewController` directly.
///
@available(iOS 9, *)
class CollectionViewControllerFeedItemUIStackView: CollectionViewController<FeedItemUIStackView> {}

class CollectionViewControllerFeedItemAutoLayoutView: CollectionViewController<FeedItemAutoLayoutView> {}
class CollectionViewControllerFeedItemLayoutKitView: CollectionViewController<FeedItemLayoutKitView> {}
class CollectionViewControllerFeedItemManualView: CollectionViewController<FeedItemManualView> {}

/// A UICollectionView controller where each cell's content view is a DataBinder.
class CollectionViewController<ContentViewType: UIView>: UICollectionViewController, UICollectionViewDelegateFlowLayout where ContentViewType: DataBinder {

    typealias CellType = CollectionCell<ContentViewType>

    let reuseIdentifier = "cell"
    let data: [ContentViewType.DataType]
    let flowLayout: UICollectionViewFlowLayout
    let manequinCell: CellType
    let start: CFAbsoluteTime

    init(data: [ContentViewType.DataType]) {
        self.start = CFAbsoluteTimeGetCurrent()
        self.data = data
        self.flowLayout = UICollectionViewFlowLayout()
        self.manequinCell = CellType(frame: .zero)
        super.init(collectionViewLayout: flowLayout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(CellType.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellType = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CellType
        cell.setData(data[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        manequinCell.setData(data[indexPath.row])
        var size = manequinCell.sizeThatFits(CGSize(width: collectionView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        size.width = collectionView.bounds.width
        return size
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        flowLayout.invalidateLayout()
    }
}

/// A UICollectionView cell that adds a DataBinder to its content view.
class CollectionCell<ContentView: UIView>: UICollectionViewCell, DataBinder where ContentView: DataBinder {

    let wrappedContentView: ContentView

    override init(frame: CGRect) {
        wrappedContentView = ContentView()
        super.init(frame: frame)
        wrappedContentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wrappedContentView)
        let views = ["v": wrappedContentView]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v]-0-|", options: [], metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v]-0-|", options: [], metrics: nil, views: views))
        contentView.backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(_ data: ContentView.DataType) {
        wrappedContentView.setData(data)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return wrappedContentView.sizeThatFits(size)
    }
}
