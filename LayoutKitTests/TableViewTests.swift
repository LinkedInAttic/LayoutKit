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
 Experiment with how UITableView works.
 */
class TableViewTests: XCTestCase, UITableViewDataSource, UITableViewDelegate {
    
    var sectionCount = 0
    var dataCount = 1

    let reuseIdentifier = "reuseIdentifier"

    func testTableView() {
        let view = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), style: .grouped)
        view.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.dataSource = self
        view.delegate = self

        sectionCount = 1
        log("reload start")
        view.reloadData()
        log("reload end")

        log("insert start")
        dataCount += 1
        let indexPaths = [IndexPath(item: 1, section: 0)]
        view.insertRows(at: indexPaths, with: .none)
        log("insert end")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        log("numberOfSections = \(sectionCount)")
        return sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        log("numberOfRowsInSection \(section) = \(dataCount)")
        return dataCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    }
}

private func log(_ msg: String) {
    //NSLog("%@", msg)
}
