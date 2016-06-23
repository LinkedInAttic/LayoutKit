// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit

/// Displays a feed using a UIScrollView
class FeedScrollViewController: FeedBaseViewController {
    private var scrollView: UIScrollView!
    private var cachedFeedLayout: Layout?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.purpleColor()

        scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.addSubview(scrollView)

        self.layoutFeed(width: self.view.bounds.width)
    }

    private func layoutFeed(width width: CGFloat) {
        let _ = CFAbsoluteTimeGetCurrent()
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            let arrangement = self.getFeedLayout().arrangement(width: width)
            dispatch_async(dispatch_get_main_queue(), {
                self.scrollView.contentSize = arrangement.frame.size
                arrangement.makeViews(inView: self.scrollView)
                let _ = CFAbsoluteTimeGetCurrent()
//                NSLog("user: \((end-start).ms)")
            })
        }
    }

    func getFeedLayout() -> Layout {
        if let cachedFeedLayout = cachedFeedLayout {
            return cachedFeedLayout
        }

        let feedItems = getFeedItems()
        let feedLayout = StackLayout(
            axis: .vertical,
            distribution: .leading,
            sublayouts: feedItems
        )
        cachedFeedLayout = feedLayout
        return feedLayout
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        layoutFeed(width: size.width)
    }
}

