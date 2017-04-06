// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/// A TableViewController controller where each cell's content view is a DataBinder.
class TableViewController: UITableViewController {

    let reuseIdentifier = "cell"
    let data: [FeedItemData]
    let contentViewClass: UIView.Type

    init(data: [FeedItemData], contentViewClass: UIView.Type) {
        self.data = data
        self.contentViewClass = contentViewClass
        super.init(style: UITableViewStyle.grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.register(TableCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TableCell
        cell.setupWrappedContentView(withContentViewClass: contentViewClass)
        cell.setData(data[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

/// A UITableViewCell cell that adds a DataBinder to its content view.
class TableCell: UITableViewCell {

    var wrappedContentView: UIView?

    func setupWrappedContentView(withContentViewClass contentViewClass: UIView.Type) {
        guard self.wrappedContentView == nil else {
            return
        }

        let wrappedContentView = contentViewClass.init()

        wrappedContentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wrappedContentView)
        let views = ["v": wrappedContentView]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v]-0-|", options: [], metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v]-0-|", options: [], metrics: nil, views: views))
        contentView.backgroundColor = UIColor.white

        self.wrappedContentView = wrappedContentView
    }

    func setData(_ data: FeedItemData) {
        guard let wrappedContentView = self.wrappedContentView else {
            return
        }

        DataBinderHelper.setData(data, forView: wrappedContentView)
    }
}
