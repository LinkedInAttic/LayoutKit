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
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.dataSource = self

        sectionCounts = [1]
        log("reload start")

        view.reloadData()
        layout.prepare()
        log("reload end")

        let e = expectation(description: "main")
        DispatchQueue.main.async {
            log("insert start")
            self.sectionCounts = [2]
            view.insertItems(at: [IndexPath(item: 1, section: 0)])
            log("insert end")

            DispatchQueue.main.async(execute: { 
                log("insert start")
                self.sectionCounts = [2, 1]
                view.insertSections(IndexSet(integer: 1))
                log("insert end")

                e.fulfill()
            })
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        log("numberOfItemsInSection \(section) = \(sectionCounts[section])")
        return sectionCounts[section]
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        log("numberOfSections = \(sectionCounts.count)")
        return sectionCounts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        log("cellForItemAtIndexPath \(indexPath)")
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    }
}

private func log(_ msg: String) {
    //NSLog("%@", msg)
}
