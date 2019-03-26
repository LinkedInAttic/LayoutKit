// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/// Each view type of collection view should be a non-generic subclass from TableViewController
/// If each view type uses the generic TableViewController, it will cause the crash.
/// Please see `CollectionViewController.swift` for details
@available(iOS 9, *)
class TableViewControllerFeedItemUIStackView: TableViewController<FeedItemUIStackView> {}

class TableViewControllerFeedItemAutoLayoutView: TableViewController<FeedItemAutoLayoutView> {}
class TableViewControllerFeedItemLayoutKitView: TableViewController<FeedItemLayoutKitView> {}
class TableViewControllerFeedItemManualView: TableViewController<FeedItemManualView> {}

/// A TableViewController controller where each cell's content view is a DataBinder.
class TableViewController<ContentViewType: UIView>: UITableViewController where ContentViewType: DataBinder {

    typealias CellType = TableCell<ContentViewType>

    let reuseIdentifier = "cell"
    let data: [CellType.DataType]

    init(data: [CellType.DataType]) {
        self.data = data
        super.init(style: UITableView.Style.grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.register(CellType.self, forCellReuseIdentifier: reuseIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CellType = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CellType
        cell.setData(data[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

/// A UITableViewCell cell that adds a DataBinder to its content view.
class TableCell<ContentView: UIView>: UITableViewCell, DataBinder where ContentView: DataBinder {

    lazy var wrappedContentView: ContentView = {
        let v = ContentView()
        v.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(v)
        let views = ["v": v]
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v]-0-|", options: [], metrics: nil, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v]-0-|", options: [], metrics: nil, views: views))
        return v
    }()

    func setData(_ data: ContentView.DataType) {
        wrappedContentView.setData(data)
    }
}
