// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

// MARK: - UITableViewDelegate

extension ReloadableViewLayoutAdapter: UITableViewDelegate {

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return currentArrangement[indexPath.section].items[indexPath.item].frame.height
    }

    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return currentArrangement[section].header?.frame.height ?? 0
    }

    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return currentArrangement[section].footer?.frame.height ?? 0
    }

    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return renderLayout(currentArrangement[section].header, tableView: tableView)
    }

    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return renderLayout(currentArrangement[section].footer, tableView: tableView)
    }

    private func renderLayout(layout: LayoutArrangement?, tableView: UITableView) -> UIView? {
        guard let layout = layout else {
            return nil
        }
        let view = dequeueHeaderFooterView(tableView: tableView)
        layout.makeViews(inView: view)
        return view
    }

    private func dequeueHeaderFooterView(tableView tableView: UITableView) -> UITableViewHeaderFooterView {
        if let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier(reuseIdentifier) {
            return view
        } else {
            return UITableViewHeaderFooterView(reuseIdentifier: reuseIdentifier)
        }
    }
}

// MARK: - UITableViewDataSource

extension ReloadableViewLayoutAdapter: UITableViewDataSource {

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return currentArrangement.count
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentArrangement[section].items.count
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = currentArrangement[indexPath.section].items[indexPath.item]
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        item.makeViews(inView: cell.contentView)
        return cell
    }
}