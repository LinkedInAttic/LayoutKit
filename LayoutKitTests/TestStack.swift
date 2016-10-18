// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics
import LayoutKit

class TestStack {

    let intrinsicSize: CGSize

    var stackLayout: StackLayout! = nil
    var stackView: View! = nil
    var oneView: View! = nil
    var twoView: View! = nil
    var threeView: View! = nil

    init(axis: Axis, distribution: StackLayoutDistribution, spacing: CGFloat = 0, alignment: Alignment = .fill) {

        switch axis {
        case .vertical:
            self.intrinsicSize = CGSize(width: 33.5, height: CGFloat(2*spacing + 14 + 18.5 + 23))
        case .horizontal:
            self.intrinsicSize = CGSize(width: CGFloat(2*spacing + 7 + 18 + 33.5), height: 23)
        }
        
        stackLayout = StackLayout(
            axis: axis,
            spacing: spacing,
            distribution: distribution,
            alignment: alignment,
            sublayouts: [
                SizeLayout<View>(width: 7, height: 14, alignment: .fill, flexibility: .flexible, config: { view in
                    self.oneView = view
                }),
                SizeLayout<View>(width: 18, height: 18.5, alignment: .fill, flexibility: .flexible, config: { view in
                    self.twoView = view
                }),
                SizeLayout<View>(width: 33.5, height: 23, alignment: .fill, flexibility: .flexible, config: { view in
                    self.threeView = view
                }),
            ],
            config: { view in
                self.stackView = view
            }
        )
    }

    func arrangement(excessWidth: CGFloat? = nil, excessHeight: CGFloat? = nil) -> TestStack {
        // width/height default to nil to match what real callers would do.
        // defaulting to 0 would be less code but real callers are unlikely to explicitly provide both width and height.
        var width: CGFloat? = nil
        if let excessWidth = excessWidth {
            width = intrinsicSize.width + excessWidth
        }
        var height: CGFloat? = nil
        if let excessHeight = excessHeight {
            height = intrinsicSize.height + excessHeight
        }
        stackLayout.arrangement(width: width, height: height).makeViews()
        return self
    }
}
