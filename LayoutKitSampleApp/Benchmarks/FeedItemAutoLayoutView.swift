// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/// A LinkedIn feed item that is implemented with Auto Layout.
class FeedItemAutoLayoutView: UIView, DataBinder {

    let topBarView = TopBarView()
    let miniProfileView = MiniProfileView()
    let miniContentView = MiniContentView()
    let socialActionsView = SocialActionsView()
    let commentView = CommentView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        let views: [String: UIView] = [
            "topBarView": topBarView,
            "miniProfileView": miniProfileView,
            "miniContentView": miniContentView,
            "socialActionsView": socialActionsView,
            "commentView": commentView
        ]

        addAutoLayoutSubviews(views)
        addConstraints(withVisualFormat: "V:|-0-[topBarView]-0-[miniProfileView]-0-[miniContentView]-0-[socialActionsView]-0-[commentView]-0-|", views: views)
        addConstraints(withVisualFormat: "H:|-0-[topBarView]-0-|", views: views)
        addConstraints(withVisualFormat: "H:|-0-[miniProfileView]-0-|", views: views)
        addConstraints(withVisualFormat: "H:|-0-[miniContentView]-0-|", views: views)
        addConstraints(withVisualFormat: "H:|-0-[socialActionsView]-0-|", views: views)
        addConstraints(withVisualFormat: "H:|-0-[commentView]-0-|", views: views)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(_ data: FeedItemData) {
        topBarView.actionLabel.text = data.actionText
        miniProfileView.posterNameLabel.text = data.posterName
        miniProfileView.posterHeadlineLabel.text = data.posterHeadline
        miniProfileView.posterTimeLabel.text = data.posterTimestamp
        miniProfileView.posterCommentLabel.text = data.posterComment
        miniContentView.contentTitleLabel.text = data.contentTitle
        miniContentView.contentDomainLabel.text = data.contentDomain
        commentView.actorCommentLabel.text = data.actorComment
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return systemLayoutSizeFitting(CGSize(width: size.width, height: 0))
    }
}

class CommentView: UIView {
    let actorImageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "50x50.png")
        i.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        i.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        return i
    }()

    let actorCommentLabel: UILabel = UILabel()

    init() {
        super.init(frame: .zero)

        let views: [String: UIView] = [
            "actorImageView": actorImageView,
            "actorCommentLabel": actorCommentLabel
        ]
        addAutoLayoutSubviews(views)

        addConstraints(withVisualFormat: "H:|-0-[actorImageView]-0-[actorCommentLabel]-0-|", views: views)
        addConstraints(withVisualFormat: "V:|-0-[actorImageView]-(>=0)-|", views: views)
        addConstraints(withVisualFormat: "V:|-0-[actorCommentLabel]-(>=0)-|", views: views)
        addConstraints(withVisualFormat: "V:[actorImageView]-(0@749)-|", views: views)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MiniContentView: UIView {
    let contentImageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "350x200.png")
        i.contentMode = .scaleAspectFit
        i.backgroundColor = UIColor.orange
        return i
    }()

    let contentTitleLabel: UILabel = UILabel()
    let contentDomainLabel: UILabel = UILabel()

    init() {
        super.init(frame: .zero)

        let views: [String: UIView] = [
            "contentImageView": contentImageView,
            "contentTitleLabel": contentTitleLabel,
            "contentDomainLabel": contentDomainLabel
        ]

        addAutoLayoutSubviews(views)

        addConstraints(withVisualFormat: "V:|-0-[contentImageView]-0-[contentTitleLabel]-0-[contentDomainLabel]-0-|", views: views)

        addConstraints(withVisualFormat: "H:|-0-[contentImageView]-0-|", views: views)
        addConstraints(withVisualFormat: "H:|-0-[contentTitleLabel]-0-|", views: views)
        addConstraints(withVisualFormat: "H:|-0-[contentDomainLabel]-0-|", views: views)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MiniProfileView: UIView {

    let posterImageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "50x50.png")
        i.backgroundColor = UIColor.orange
        i.contentMode = .center
        i.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        i.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        return i
    }()

    let posterNameLabel: UILabel = UILabel()

    let posterHeadlineLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 3
        return l
    }()

    let posterTimeLabel: UILabel = UILabel()
    let posterCommentLabel: UILabel = UILabel()

    init() {
        super.init(frame: .zero)

        let views: [String: UIView] = [
            "posterImageView": posterImageView,
            "posterNameLabel": posterNameLabel,
            "posterHeadlineLabel": posterHeadlineLabel,
            "posterTimeLabel": posterTimeLabel,
            "posterCommentLabel": posterCommentLabel
        ]
        addAutoLayoutSubviews(views)
        addConstraints(withVisualFormat: "V:|-0-[posterImageView]-(>=0)-[posterCommentLabel]-0-|", views: views)
        addConstraints(withVisualFormat: "V:|-1-[posterNameLabel]-1-[posterHeadlineLabel]-1-[posterTimeLabel]-(>=3)-[posterCommentLabel]", views: views)
        addConstraints(withVisualFormat: "V:[posterImageView]-(0@749)-[posterCommentLabel]", views: views)

        addConstraints(withVisualFormat: "H:|-0-[posterImageView]-2-[posterNameLabel]-4-|", views: views)
        addConstraints(withVisualFormat: "H:[posterImageView]-2-[posterHeadlineLabel]-4-|", views: views)
        addConstraints(withVisualFormat: "H:[posterImageView]-2-[posterTimeLabel]-4-|", views: views)
        addConstraints(withVisualFormat: "H:|-0-[posterCommentLabel]-0-|", views: views)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SocialActionsView: UIView {
    let likeLabel: UILabel = {
        let l = UILabel()
        l.text = "Like"
        l.backgroundColor = UIColor(red: 0, green: 0.9, blue: 0, alpha: 1)
        return l
    }()

    let commentLabel: UILabel = {
        let l = UILabel()
        l.text = "Comment"
        l.backgroundColor = UIColor(red: 0, green: 1.0, blue: 0, alpha: 1)
        l.textAlignment = .center
        return l
    }()

    let shareLabel: UILabel = {
        let l = UILabel()
        l.text = "Share"
        l.textAlignment = .right
        l.backgroundColor = UIColor(red: 0, green: 0.8, blue: 0, alpha: 1)
        return l
    }()

    init() {
        super.init(frame: .zero)

        let views: [String: UIView] = [
            "likeLabel": likeLabel,
            "commentLabel": commentLabel,
            "shareLabel": shareLabel
        ]
        addAutoLayoutSubviews(views)

        addConstraints(withVisualFormat: "V:|-0-[likeLabel]-0-|", views: views)
        addConstraints(withVisualFormat: "V:|-0-[commentLabel]-0-|", views: views)
        addConstraints(withVisualFormat: "V:|-0-[shareLabel]-0-|", views: views)

        addConstraints([
            NSLayoutConstraint(item: likeLabel, attribute: .leadingMargin, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: commentLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: shareLabel, attribute: .trailingMargin, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: 0)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TopBarView: UIView {
    let actionLabel: UILabel = UILabel()

    let optionsLabel: UILabel = {
        let l = UILabel()
        l.text = "..."
        l.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        l.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        return l
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.blue
        let views: [String: UIView] = ["actionLabel": actionLabel, "optionsLabel": optionsLabel]
        addAutoLayoutSubviews(views)
        addConstraints(withVisualFormat: "H:|-0-[actionLabel]-0-[optionsLabel]-0-|", views: views)
        addConstraints(withVisualFormat: "V:|-0-[actionLabel]-(>=0)-|", views: views)
        addConstraints(withVisualFormat: "V:|-0-[optionsLabel]-(>=0)-|", views: views)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UIView {

    func addAutoLayoutSubviews(_ subviews: [String: UIView]) {
        for (_, view) in subviews {
            addAutoLayoutSubview(view)
        }
    }

    func addAutoLayoutSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }

    func addConstraints(withVisualFormat visualFormat: String, views: [String: UIView]) {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: [], metrics: nil, views: views))
    }
}
