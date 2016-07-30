// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit

/// Example of how batch updates work with a UITableView.
class BatchUpdatesTableViewController: BatchUpdatesBaseViewController {
    private var tableView: LayoutAdapterTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = LayoutAdapterTableView(frame: view.bounds, style: .Grouped)
        tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        view.addSubview(tableView)
        tableView.layoutAdapter.reload(width: tableView.bounds.width, synchronous: true, layoutProvider: layoutOne)

        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.tableView.layoutAdapter.reload(
                width: self.tableView.bounds.width,
                synchronous: true,
                batchUpdates: self.batchUpdates(),
                layoutProvider: self.layoutTwo)
        }
    }
}
