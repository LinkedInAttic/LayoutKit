// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/// A LinkedIn feed item that is implemented with UIStackView.
@available(iOS 9.0, *)
class FeedItemUIStackView: DebugStackView, DataBinder {

    let actionLabel: UILabel = UILabel()

    let optionsLabel: UILabel = {
        let l = UILabel()
        l.text = "..."
        l.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        l.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        return l
    }()

    lazy var topBar: UIStackView = {
        let v = DebugStackView(arrangedSubviews: [self.actionLabel, self.optionsLabel])
        v.axis = .Horizontal
        v.distribution = .Fill
        v.alignment = .Leading
        v.viewId = "topBar"
        v.backgroundColor = UIColor.blueColor()
        return v
    }()

    let posterImageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "50x50.png")
        i.backgroundColor = UIColor.orangeColor()
        i.contentMode = .Center
        i.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        i.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        return i
    }()

    let posterNameLabel: UILabel = UILabel()

    let posterHeadlineLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 3
        return l
    }()

    let posterTimeLabel: UILabel = UILabel()

    lazy var posterLabels: DebugStackView = {
        let v = DebugStackView(arrangedSubviews: [self.posterNameLabel, self.posterHeadlineLabel, self.posterTimeLabel])
        v.axis = .Vertical
        v.spacing = 1
        v.layoutMargins = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        v.layoutMarginsRelativeArrangement = true
        v.viewId = "posterLabels"
        return v
    }()

    lazy var posterCard: DebugStackView = {
        let v = DebugStackView(arrangedSubviews: [self.posterImageView, self.posterLabels])
        v.axis = .Horizontal
        v.alignment = .Center
        v.viewId = "posterCard"
        return v
    }()

    let posterCommentLabel: UILabel = UILabel()

    let contentImageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "350x200.png")
        i.contentMode = .ScaleAspectFit
        i.backgroundColor = UIColor.orangeColor()
        return i
    }()

    let contentTitleLabel: UILabel = UILabel()
    let contentDomainLabel: UILabel = UILabel()

    let likeLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = UIColor(red: 0, green: 0.9, blue: 0, alpha: 1)
        l.text = "Like"
        return l
    }()

    let commentLabel: UILabel = {
        let l = UILabel()
        l.text = "Comment"
        l.backgroundColor = UIColor(red: 0, green: 1.0, blue: 0, alpha: 1)
        l.textAlignment = .Center
        return l
    }()

    let shareLabel: UILabel = {
        let l = UILabel()
        l.text = "Share"
        l.backgroundColor = UIColor(red: 0, green: 0.8, blue: 0, alpha: 1)
        l.textAlignment = .Right
        return l
    }()

    lazy var actions: DebugStackView = {
        let v = DebugStackView(arrangedSubviews: [self.likeLabel, self.commentLabel, self.shareLabel])
        v.axis = .Horizontal
        v.distribution = .EqualSpacing
        v.viewId = "actions"
        return v
    }()

    let actorImageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "50x50.png")
        i.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        i.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        return i
    }()

    let actorCommentLabel: UILabel = UILabel()

    lazy var comment: DebugStackView = {
        let v = DebugStackView(arrangedSubviews: [self.actorImageView, self.actorCommentLabel])
        v.axis = .Horizontal
        v.viewId = "comment"
        return v
    }()

    convenience init() {
        self.init(arrangedSubviews: [])
        axis = .Vertical
        viewId = "ComplexStackView"
        let subviews = [
            topBar,
            posterCard,
            posterCommentLabel,
            contentImageView,
            contentTitleLabel,
            contentDomainLabel,
            actions,
            comment
        ]
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(view)
        }
    }

    func setData(data: FeedItemData) {
        actionLabel.text = data.actionText
        posterNameLabel.text = data.posterName
        posterHeadlineLabel.text = data.posterHeadline
        posterTimeLabel.text = data.posterTimestamp
        posterCommentLabel.text = data.posterComment
        contentTitleLabel.text = data.contentTitle
        contentDomainLabel.text = data.contentDomain
        actorCommentLabel.text = data.actorComment
    }

    override func sizeThatFits(size: CGSize) -> CGSize {
        return systemLayoutSizeFittingSize(CGSize(width: size.width, height: 0))
    }
}

@available(iOS 9.0, *)
class DebugStackView: UIStackView {
    var viewId: String = ""
}
