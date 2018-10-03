// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit

/// Displays a pile of overlapping circular images.
open class CircleImagePileLayout: StackLayout<CircleImagePileView> {

    public enum Mode {
        case leadingOnTop, trailingOnTop
    }

    public let mode: Mode

    public init(imageNames: [String], mode: Mode = .trailingOnTop, alignment: Alignment = .topLeading, viewReuseId: String? = nil) {
        self.mode = mode
        let sublayouts: [Layout] = imageNames.map { imageName in
            return SizeLayout<UIImageView>(width: 50, height: 50, config: { imageView in
                imageView.image = UIImage(named: imageName)
                imageView.layer.cornerRadius = 25
                imageView.layer.masksToBounds = true
                imageView.layer.borderColor = UIColor.white.cgColor
                imageView.layer.borderWidth = 2
            })
        }
        super.init(
            axis: .horizontal,
            spacing: -25,
            distribution: .leading,
            alignment: alignment,
            flexibility: .inflexible,
            viewReuseId: viewReuseId,
            sublayouts: sublayouts)
    }

    open override var needsView: Bool {
        return super.needsView || mode == .leadingOnTop
    }
}

open class CircleImagePileView: UIView {

    open override func addSubview(_ view: UIView) {
        // Make sure views are inserted below existing views so that the first image in the face pile is on top.
        if let lastSubview = subviews.last {
            insertSubview(view, belowSubview: lastSubview)
        } else {
            super.addSubview(view)
        }
    }
}
