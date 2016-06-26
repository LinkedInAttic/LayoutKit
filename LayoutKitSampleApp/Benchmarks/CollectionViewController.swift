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
        self.manequinCell = CellType(frame: CGRect.zero)
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
class CollectionCell<ContentView: UIView where ContentView: DataBinder>: UICollectionViewCell, DataBinder {

    let wrappedContentView: ContentView

    override init(frame: CGRect) {
        wrappedContentView = ContentView()
        super.init(frame: frame)
        wrappedContentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wrappedContentView)
        let views = ["v": wrappedContentView]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v]-0-|", options: [], metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v]-0-|", options: [], metrics: nil, views: views))
        contentView.backgroundColor = UIColor.white()
    }

    func setData(_ data: ContentView.DataType) {
        wrappedContentView.setData(data)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return wrappedContentView.sizeThatFits(size)
    }
}
