// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit

/**
 A layout that is similar to an item in the LinkedIn feed.
 */
public class FeedItemLayout: InsetLayout {

    public init(actionText: String,
                posterProfile: ProfileCardLayout,
                posterComment: String,
                contentLayout: ContentLayout,
                actorComment: String) {

        let contentFilteringOptions = LabelLayout(
            text: "...",
            numberOfLines: 1,
            alignment: .topTrailing,
            flexibility: .inflexible
        )

        let actionStack = StackLayout(axis: .horizontal, sublayouts: [
            LabelLayout(text: actionText),
            contentFilteringOptions
        ])

        let buttonConfig = { (label: UILabel) in
            label.backgroundColor = UIColor.greenColor()
        }
        let socialActions = StackLayout(axis: .horizontal, distribution: .fillEqualSize, sublayouts: [
            LabelLayout(text: "Like", alignment: .centerLeading, config: buttonConfig),
            LabelLayout(text: "Comment", alignment: .center, config: buttonConfig),
            LabelLayout(text: "Share", alignment: .centerTrailing, config: buttonConfig),
        ])

        let actorCommentLayout = StackLayout(axis: .horizontal, sublayouts: [
            SizeLayout<UIImageView>(width: 50, height: 50, config: { imageView in
                imageView.image = UIImage(named: "50x50.png")
            }),
            LabelLayout(text: actorComment, alignment: .centerLeading)
        ])

        let feedItem = StackLayout(
            axis: .vertical,
            spacing: 4,
            sublayouts: [
                actionStack,
                posterProfile,
                LabelLayout(text: posterComment, numberOfLines: 4),
                contentLayout,
                socialActions,
                actorCommentLayout
            ]
        )
        super.init(insets: EdgeInsets(top: 8, left: 8, bottom: 8, right: 8), sublayout: feedItem, config: { view in
            view.backgroundColor = UIColor.whiteColor()
        })
    }
}

public class ContentLayout: StackLayout {

    public init(title: String, domain: String) {
        super.init(axis: .vertical, sublayouts: [
            SizeLayout<UIImageView>(
                size: CGSize(width: 350, height: 200),
                alignment: Alignment(vertical: .top, horizontal: .fill),
                config: { imageView in
                    imageView.image = UIImage(named: "350x200.png")
                }
            ),
            LabelLayout(text: title),
            LabelLayout(text: domain)
        ])
    }
}