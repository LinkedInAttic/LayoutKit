// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

protocol DataBinder {
    func setData(_ data: FeedItemData)
}

enum DataBinderHelper {
    static func setData(_ data: FeedItemData, forView view: UIView) {

        if let feedItemAutoLayoutView = view as? FeedItemAutoLayoutView {
            feedItemAutoLayoutView.setData(data)
            return
        }

        if let feedItemManualView = view as? FeedItemManualView {
            feedItemManualView.setData(data)
            return
        }

        if let feedItemLayoutKitView = view as? FeedItemLayoutKitView {
            feedItemLayoutKitView.setData(data)
            return
        }

        if #available(iOS 9.0, *) {
            if let feedItemUIStackView = view as? FeedItemUIStackView {
                feedItemUIStackView.setData(data)
                return
            }
        }

        assertionFailure("Unknown type of the view")
    }
}
