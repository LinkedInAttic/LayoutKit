// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/// Runs benchmarks for different kinds of layouts.
class BenchmarkViewController: UITableViewController {

    private let reuseIdentifier = "cell"

    private let viewControllers: [ViewControllerData] = [
        ViewControllerData(title: "UICollectionView UIStack feed", factoryBlock: { viewCount in
            if #available(iOS 9.0, *) {
                let data = FeedItemData.generate(count: viewCount)
                return CollectionViewControllerFeedItemUIStackView(data: data)
            } else {
                NSLog("UIStackView only supported on iOS 9+")
                return nil
            }
        }),

        ViewControllerData(title: "UICollectionView Auto Layout feed", factoryBlock: { viewCount in
            let data = FeedItemData.generate(count: viewCount)
            return CollectionViewControllerFeedItemAutoLayoutView(data: data)
        }),

        ViewControllerData(title: "UICollectionView LayoutKit feed", factoryBlock: { viewCount in
            let data = FeedItemData.generate(count: viewCount)
            return CollectionViewControllerFeedItemLayoutKitView(data: data)
        }),

        ViewControllerData(title: "UICollectionView Manual Layout feed", factoryBlock: { viewCount in
            let data = FeedItemData.generate(count: viewCount)
            return CollectionViewControllerFeedItemManualView(data: data)
        }),

        ViewControllerData(title: "UITableView UIStack feed", factoryBlock: { viewCount in
            if #available(iOS 9.0, *) {
                let data = FeedItemData.generate(count: viewCount)
                return TableViewControllerFeedItemUIStackView(data: data)
            } else {
                NSLog("UIStackView only supported on iOS 9+")
                return nil
            }
        }),

        ViewControllerData(title: "UITableView Auto Layout feed", factoryBlock: { viewCount in
            let data = FeedItemData.generate(count: viewCount)
            return TableViewControllerFeedItemAutoLayoutView(data: data)
        }),

        ViewControllerData(title: "UITableView LayoutKit feed", factoryBlock: { viewCount in
            let data = FeedItemData.generate(count: viewCount)
            return TableViewControllerFeedItemLayoutKitView(data: data)
        }),

        ViewControllerData(title: "UITableView Manual Layout feed", factoryBlock: { viewCount in
            let data = FeedItemData.generate(count: viewCount)
            return TableViewControllerFeedItemManualView(data: data)
        })
    ]

    convenience init() {
        self.init(style: .grouped)
        title = "Benchmarks"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = viewControllers[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewControllerData = viewControllers[indexPath.row]
        guard let viewController = viewControllerData.factoryBlock(20) else {
            return
        }

        benchmark(viewControllerData)

        viewController.title = viewControllerData.title
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func benchmark(_ viewControllerData: ViewControllerData) {
        let iterations = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 40, 50, 100]
        for i in iterations {
            let description = "\(i)\tsubviews\t\(viewControllerData.title)"
            Stopwatch.benchmark(description, block: { (stopwatch: Stopwatch) -> Void in
                let vc = viewControllerData.factoryBlock(i)
                stopwatch.resume()
                vc?.view.layoutIfNeeded()
                stopwatch.pause()
            })
        }
    }
}

private struct ViewControllerData {
    let title: String
    let factoryBlock: (_ viewCount: Int) -> UIViewController?
}
