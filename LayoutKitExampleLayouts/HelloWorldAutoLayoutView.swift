// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/**
 A simple hello world layout that uses Auto Layout.
 Compare to HelloWorldLayout.swift
 */
public class HelloWorldAutoLayoutView: UIView {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
        imageView.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        imageView.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Vertical)
        imageView.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        imageView.image = UIImage(named: "earth.png")
        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello World!"
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(label)

        let views = ["imageView": imageView, "label": label]
        var constraints = [NSLayoutConstraint]()
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:|-4-[imageView(==50)]-4-|", options: [], metrics: nil, views: views))
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:|-4-[imageView(==50)]-4-[label]-8-|", options: [], metrics: nil, views: views))
        constraints.append(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
