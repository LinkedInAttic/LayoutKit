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

    /// - Warning: Subclasses that override this method must call super
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return currentArrangement[indexPath.section].items[indexPath.item].frame.height
    }

    /// - Warning: Subclasses that override this method must call super
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return currentArrangement[section].header?.frame.height ?? 0
    }

    /// - Warning: Subclasses that override this method must call super
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return currentArrangement[section].footer?.frame.height ?? 0
    }

    /// - Warning: Subclasses that override this method must call super
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return renderLayout(currentArrangement[section].header, tableView: tableView)
    }

    /// - Warning: Subclasses that override this method must call super
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return renderLayout(currentArrangement[section].footer, tableView: tableView)
    }

    private func renderLayout(_ layout: LayoutArrangement?, tableView: UITableView) -> UIView? {
        guard let layout = layout else {
            return nil
        }
        let view = dequeueHeaderFooterView(tableView: tableView)
        layout.makeViews(in: view.contentView)
        return view
    }

    private func dequeueHeaderFooterView(tableView: UITableView) -> UITableViewHeaderFooterView {
        if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) {
            return view
        } else {
            return UITableViewHeaderFooterView(reuseIdentifier: reuseIdentifier)
        }
    }
}

// MARK: - UITableViewDataSource

extension ReloadableViewLayoutAdapter: UITableViewDataSource {

    /// - Warning: Subclasses that override this method must call super
    open func numberOfSections(in tableView: UITableView) -> Int {
        return currentArrangement.count
    }

    /// - Warning: Subclasses that override this method must call super
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentArrangement[section].items.count
    }

    /// - Warning: Subclasses that override this method must call super
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = currentArrangement[indexPath.section].items[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        item.makeViews(in: cell.contentView)
        return cell
    }
}
