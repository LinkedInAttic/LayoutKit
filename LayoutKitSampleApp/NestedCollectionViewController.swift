// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit
import LayoutKitExampleLayouts

/**
 A vertical collection view where each cell contains a horizontal collection view.
 
 The initial layout (including cells in the horizontal collection views) is computed asynchronously as soon as the view loads.
 */
class NestedCollectionViewController: UIViewController {
    private var collectionView = LayoutAdapterCollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.layoutAdapter.logger = { (msg: String) in
            NSLog("%@", msg)
        }

        collectionView.frame = view.bounds
        collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        collectionView.backgroundColor = UIColor.purpleColor()

        view.addSubview(collectionView)
        layout(width: collectionView.frame.width, synchronous: false)
    }

    private func layout(width width: CGFloat, synchronous: Bool) {
        collectionView.layoutAdapter.reload(width: width, synchronous: synchronous, layoutProvider: {
            return [Section(header: nil, items: NestedCollectionViewController.makeLayout(), footer: nil)]
        })
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        layout(width: size.width, synchronous: true)
    }

    // Static to avoid capturing a reference to self
    private static func makeLayout() -> LazyMapCollection<(Range<Int>), Layout> {
        return (1..<100).lazy.map { index in
            let layout = sectionLayout(sectionIndex: index, count: index)
            return FixedWidthCellCollectionViewLayout(cellWidth: 125, sectionLayouts: layout, config: { (collectionView: HorizontalCollectionView) in
                collectionView.backgroundColor = UIColor.whiteColor()
            })
        }
    }

    // Static to avoid capturing a reference to self
    private static func sectionLayout(sectionIndex sectionIndex: Int, count: Int) -> [Section<LazyMapCollection<Range<Int>, Layout>>] {
        let items = (0..<count).lazy.map { rowIndex -> Layout in
            let text = "\(sectionIndex)-\(rowIndex) " + String(byRepeatingString: "long word ", count: rowIndex)
            let urlText = text.stringByReplacingOccurrencesOfString(" ", withString: "+")
            let url = "https://placeholdit.imgix.net/~text?txtsize=16&bg=ff0000&txtclr=000000&w=100&h=100&txt=\(urlText)"
            return LabeledImageLayout(imageUrl: NSURL(string: url)!, imageSize: CGSize(width: 100, height: 100), labelText: text)
        }
        return [Section(header: nil, items: items, footer: nil)]
    }
}

extension String {
    init(byRepeatingString str: String, count: Int) {
        var newString = ""
        for _ in 0 ..< count {
            newString += str
        }
        self.init(newString)
    }
}

class HorizontalCollectionView: LayoutAdapterCollectionView {

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        super.init(frame: CGRectZero, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}