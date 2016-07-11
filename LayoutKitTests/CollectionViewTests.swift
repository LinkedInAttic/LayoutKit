// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
import LayoutKit

/**
 Experiment with how UICollectionView works.
 */
class CollectionViewTests: XCTestCase, UICollectionViewDataSource {

    var sectionCounts = [Int]()

    let reuseIdentifier = "reuseIdentifier"

    func testCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), collectionViewLayout: layout)
        view.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.dataSource = self

        sectionCounts = [1]
        log("reload start")

        view.reloadData()
        layout.prepareLayout()
        log("reload end")

        let e = expectationWithDescription("main")
        dispatch_async(dispatch_get_main_queue()) {
            log("insert start")
            self.sectionCounts = [2]
            view.insertItemsAtIndexPaths([NSIndexPath(forItem: 1, inSection: 0)])
            log("insert end")

            dispatch_async(dispatch_get_main_queue(), { 
                log("insert start")
                self.sectionCounts = [2, 1]
                view.insertSections(NSIndexSet(index: 1))
                log("insert end")

                e.fulfill()
            })
        }

        waitForExpectationsWithTimeout(10, handler: nil)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        log("numberOfItemsInSection \(section) = \(sectionCounts[section])")
        return sectionCounts[section]
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        log("numberOfSections = \(sectionCounts.count)")
        return sectionCounts.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        log("cellForItemAtIndexPath \(indexPath)")
        return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    }
}

private func log(msg: String) {
    //NSLog("%@", msg)
}
