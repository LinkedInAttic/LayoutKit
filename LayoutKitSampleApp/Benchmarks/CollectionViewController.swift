// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/// A UICollectionView controller where each cell's content view is a DataBinder.
class CollectionViewController<ContentViewType: UIView where ContentViewType: DataBinder>: UICollectionViewController, UICollectionViewDelegateFlowLayout {

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
        self.manequinCell = CellType(frame: CGRectZero)
        super.init(collectionViewLayout: flowLayout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.registerClass(CellType.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CellType = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CellType
        cell.setData(data[indexPath.row])
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        manequinCell.setData(data[indexPath.row])
        var size = manequinCell.sizeThatFits(CGSize(width: collectionView.bounds.width, height: CGFloat.max))
        size.width = collectionView.bounds.width
        return size
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        flowLayout.invalidateLayout()
    }
}

/// A UICollectionView cell that adds a DataBinder to its content view.
class CollectionCell<ContentView: UIView where ContentView: DataBinder>: UICollectionViewCell, DataBinder {

    let wrappedContentView: ContentView

    override init(frame: CGRect) {
        wrappedContentView = ContentView()
        super.init(frame: frame)
        wrappedContentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wrappedContentView)
        let views = ["v": wrappedContentView]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[v]-0-|", options: [], metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[v]-0-|", options: [], metrics: nil, views: views))
        contentView.backgroundColor = UIColor.whiteColor()
    }

    func setData(data: ContentView.DataType) {
        wrappedContentView.setData(data)
    }

    override func sizeThatFits(size: CGSize) -> CGSize {
        return wrappedContentView.sizeThatFits(size)
    }
}