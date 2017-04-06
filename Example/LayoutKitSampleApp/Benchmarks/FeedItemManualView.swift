// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/// A LinkedIn feed item that is implemented with manual layout code.
class FeedItemManualView: UIView, DataBinder {

    let actionLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = UIColor.blue
        return l
    }()

    let optionsLabel: UILabel = {
        let l = UILabel()
        l.text = "..."
        l.sizeToFit()
        return l
    }()

    let posterImageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "50x50.png")
        i.backgroundColor = UIColor.orange
        i.contentMode = .center
        i.sizeToFit()
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

    let contentImageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "350x200.png")
        i.contentMode = .scaleAspectFit
        i.backgroundColor = UIColor.orange
        i.sizeToFit()
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
        l.textAlignment = .center
        return l
    }()

    let shareLabel: UILabel = {
        let l = UILabel()
        l.text = "Share"
        l.backgroundColor = UIColor(red: 0, green: 0.8, blue: 0, alpha: 1)
        l.textAlignment = .right
        return l
    }()

    let actorImageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "50x50.png")
        return i
    }()

    let actorCommentLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(actionLabel)
        addSubview(optionsLabel)
        addSubview(posterImageView)
        addSubview(posterNameLabel)
        addSubview(posterHeadlineLabel)
        addSubview(posterTimeLabel)
        addSubview(posterCommentLabel)
        addSubview(contentImageView)
        addSubview(contentTitleLabel)
        addSubview(contentDomainLabel)
        addSubview(likeLabel)
        addSubview(commentLabel)
        addSubview(shareLabel)
        addSubview(actorImageView)
        addSubview(actorCommentLabel)
        backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(_ data: FeedItemData) {
        actionLabel.text = data.actionText
        posterNameLabel.text = data.posterName
        posterHeadlineLabel.text = data.posterHeadline
        posterTimeLabel.text = data.posterTimestamp
        posterCommentLabel.text = data.posterComment
        contentTitleLabel.text = data.contentTitle
        contentDomainLabel.text = data.contentDomain
        actorCommentLabel.text = data.actorComment
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        optionsLabel.frame = CGRect(x: bounds.width-optionsLabel.frame.width, y: 0, width: optionsLabel.frame.width, height: optionsLabel.frame.height)
        actionLabel.frame = CGRect(x: 0, y: 0, width: bounds.width-optionsLabel.frame.width, height: 0)
        actionLabel.sizeToFit()

        posterImageView.frame = CGRect(x: 0, y: actionLabel.frame.bottom, width: posterImageView.frame.width, height: 0)
        posterImageView.sizeToFit()

        let contentInsets = UIEdgeInsets(top: 0, left: 1, bottom: 2, right: 3)
        let posterLabelWidth = bounds.width-posterImageView.frame.width - contentInsets.left - contentInsets.right
        posterNameLabel.frame = CGRect(x: posterImageView.frame.right + contentInsets.left, y: posterImageView.frame.origin.y + contentInsets.top, width: posterLabelWidth, height: 0)
        posterNameLabel.sizeToFit()

        let spacing: CGFloat = 1
        posterHeadlineLabel.frame = CGRect(x: posterImageView.frame.right + contentInsets.left, y: posterNameLabel.frame.bottom + spacing, width: posterLabelWidth, height: 0)
        posterHeadlineLabel.sizeToFit()

        posterTimeLabel.frame = CGRect(x: posterImageView.frame.right + contentInsets.left, y: posterHeadlineLabel.frame.bottom + spacing, width: posterLabelWidth, height: 0)
        posterTimeLabel.sizeToFit()

        posterCommentLabel.frame = CGRect(x: 0, y: max(posterImageView.frame.bottom, posterTimeLabel.frame.bottom + contentInsets.bottom), width: frame.width, height: 0)
        posterCommentLabel.sizeToFit()

        contentImageView.frame = CGRect(x: frame.width/2 - contentImageView.frame.width/2, y: posterCommentLabel.frame.bottom, width: frame.width, height: 0)
        contentImageView.sizeToFit()

        contentTitleLabel.frame = CGRect(x: 0, y: contentImageView.frame.bottom, width: frame.width, height: 0)
        contentTitleLabel.sizeToFit()

        contentDomainLabel.frame = CGRect(x: 0, y: contentTitleLabel.frame.bottom, width: frame.width, height: 0)
        contentDomainLabel.sizeToFit()

        likeLabel.frame = CGRect(x: 0, y: contentDomainLabel.frame.bottom, width: 0, height: 0)
        likeLabel.sizeToFit()

        commentLabel.sizeToFit()
        commentLabel.frame = CGRect(x: frame.width/2-commentLabel.frame.width/2, y: contentDomainLabel.frame.bottom, width: commentLabel.frame.width, height: commentLabel.frame.height)

        shareLabel.sizeToFit()
        shareLabel.frame = CGRect(x: frame.width-shareLabel.frame.width, y: contentDomainLabel.frame.bottom, width: shareLabel.frame.width, height: shareLabel.frame.height)

        actorImageView.frame = CGRect(x: 0, y: likeLabel.frame.bottom, width: 0, height: 0)
        actorImageView.sizeToFit()

        actorCommentLabel.frame = CGRect(x: actorImageView.frame.right, y: likeLabel.frame.bottom, width: frame.width-actorImageView.frame.width, height: 0)
        actorCommentLabel.sizeToFit()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        layoutSubviews()
        return CGSize(width: size.width, height: max(actorImageView.frame.bottom, actorCommentLabel.frame.bottom))
    }

    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude))
    }
}

extension CGRect {
    var bottom: CGFloat {
        return origin.y + size.height
    }
    
    var right: CGFloat {
        return origin.x + size.width
    }
}
