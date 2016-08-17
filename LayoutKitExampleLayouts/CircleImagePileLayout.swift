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
public class CircleImagePileLayout: BaseLayout<CircleImagePileView>, ConfigurableLayout {

    public enum Mode {
        case leadingOnTop, trailingOnTop
    }

    public let mode: Mode

    // Note: we use composition here and not inheritance.
    // Part of the reason is that inheritance doesn't mesh super well with the ConfigurableLayout helper protocol.
    // If we made CircleImagePileLayout derive from StackLayout, then StackLayout would cause
    // ConfigurableLayout.ConfigurableView to be bound to View because StackLayout derives from BaseLayout<View>.
    // That would result in a view of type View to be created for this CircleImagePileLayout. But we actually
    // need the view to derive from CircleImagePileView, so it's more convenient to derive from
    // BaseLayout<CircleImagePileView> and use composition with the StackLayout.
    public let stack: StackLayout

    public init(imageNames: [String], mode: Mode = .trailingOnTop, alignment: Alignment = .topLeading, viewReuseId: String? = nil) {
        self.mode = mode
        let sublayouts: [Layout] = imageNames.map { imageName in
            return SizeLayout<UIImageView>(width: 50, height: 50, config: { imageView in
                imageView.image = UIImage(named: imageName)
                imageView.layer.cornerRadius = 25
                imageView.layer.masksToBounds = true
                imageView.layer.borderColor = UIColor.whiteColor().CGColor
                imageView.layer.borderWidth = 2
            })
        }
        stack = StackLayout(
            axis: .horizontal,
            spacing: -25,
            distribution: .leading,
            alignment: alignment,
            flexibility: .inflexible,
            viewReuseId: viewReuseId,
            sublayouts: sublayouts)
        super.init(alignment: alignment, flexibility: .inflexible, config: nil)
    }

    public func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        let stackMeasurement = stack.measurement(within: maxSize)
        return LayoutMeasurement(layout: self, size: stackMeasurement.size, maxSize: maxSize, sublayouts: [stackMeasurement])
    }

    public func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        let frame = alignment.position(size: measurement.size, in: rect)
        let sublayouts = [stack.arrangement(width: frame.size.width, height: frame.size.height)]
        return LayoutArrangement(layout: self, frame: frame, sublayouts: sublayouts)
    }

    override public var needsView: Bool {
        return super.needsView || mode == .leadingOnTop
    }
}

public class CircleImagePileView: UIView {

    public override func addSubview(view: UIView) {
        // Make sure views are inserted below existing views so that the first image in the face pile is on top.
        if let lastSubview = subviews.last {
            insertSubview(view, belowSubview: lastSubview)
        } else {
            super.addSubview(view)
        }
    }
}
