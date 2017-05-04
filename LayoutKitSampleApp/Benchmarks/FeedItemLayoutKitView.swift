// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import ExampleLayouts

/// A LinkedIn feed item that is implemented with LayoutKit.
class FeedItemLayoutKitView: UIView, DataBinder {

    private var layout: FeedItemLayout? = nil
    
    private lazy var heightConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(
            item: self, attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: self.bounds.height)
        constraint.isActive = true
        return constraint
    }()
    
    func setData(_ data: FeedItemData) {
        let posterProfile = ProfileCardLayout(
            name: data.posterName,
            connectionDegree: "2nd",
            headline: data.posterHeadline,
            timestamp: data.posterTimestamp,
            profileImageName: "50x50.png")

        let content = ContentLayout(title: data.contentTitle, domain: data.contentDomain)
        layout = FeedItemLayout(
            actionText: data.actionText,
            posterProfile: posterProfile,
            posterComment: data.posterComment,
            contentLayout: content,
            actorComment: data.actorComment)
        
        // Assure that `layoutSubviews` is called
        setNeedsLayout()
        
        // Only calculate height for valid width
        if bounds.width > 0 {
            heightConstraint.constant = sizeThatFits(CGSize(width: bounds.width, height: .greatestFiniteMagnitude)).height
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return layout?.measurement(within: size).size ?? .zero
    }

    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    override func layoutSubviews() {
        layout?.measurement(within: bounds.size).arrangement(within: bounds).makeViews(in: self)
    }
}
