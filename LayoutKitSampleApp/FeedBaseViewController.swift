// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit
import ExampleLayouts

/// A base class for various view controllers that display a fake feed.
class FeedBaseViewController: UIViewController {

    private var cachedFeedItems: [Layout]?

    func getFeedItems() -> [Layout] {
        if let cachedFeedItems = cachedFeedItems {
            return cachedFeedItems
        }

        let profileCard = ProfileCardLayout(
            name: "Nick Snyder",
            connectionDegree: "1st",
            headline: "Software Engineer at LinkedIn",
            timestamp: "5 minutes ago",
            profileImageName: "50x50"
        )

        let content = ContentLayout(title: "Chuck Norris", domain: "chucknorris.com")

        let feedItem = FeedItemLayout(
            actionText: "Sergei Tauger commented on this",
            posterProfile: profileCard,
            posterComment: "Check it out",
            contentLayout: content,
            actorComment: "Awesome!"
        )

        let feedItems = [Layout](repeating: feedItem, count: 1000)
        cachedFeedItems = feedItems
        return feedItems
    }
}
