// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit

/// Displays a feed using a UITableView
class FeedTableViewController: FeedBaseViewController {

    private var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds, style: .Grouped)
        tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        tableView.backgroundColor = UIColor.purpleColor()

        reloadableViewLayoutAdapter = ReloadableViewLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter

        view.addSubview(tableView)
        self.layoutFeed(width: tableView.frame.width, synchronous: false)
    }

    private func layoutFeed(width width: CGFloat, synchronous: Bool) {
        reloadableViewLayoutAdapter.reload(width: width, synchronous: synchronous, layoutProvider: { [weak self] in
            return [Section(header: nil, items: self?.getFeedItems() ?? [], footer: nil)]
        })
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        layoutFeed(width: size.width, synchronous: true)
    }
}