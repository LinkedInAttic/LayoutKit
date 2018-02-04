// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

@objc public class LOKAxis: NSObject {
    let axis: Axis
    init(_ axis: Axis) {
        self.axis = axis
    }
    @objc public static let Horizonal = LOKAxis(.horizontal)
    @objc public static let Vertical = LOKAxis(.vertical)
}

@objc public class LOKStackLayoutDistribution: NSObject {
    let distribution: StackLayoutDistribution
    init(_ distribution: StackLayoutDistribution) {
        self.distribution = distribution
    }
    @objc public static let Leading = LOKStackLayoutDistribution(.leading)
    @objc public static let Trailing = LOKStackLayoutDistribution(.trailing)
    @objc public static let Center = LOKStackLayoutDistribution(.center)
    @objc public static let FillEqualSpacing = LOKStackLayoutDistribution(.fillEqualSpacing)
    @objc public static let FillEqualSize = LOKStackLayoutDistribution(.fillEqualSize)
    @objc public static let FillFlexing = LOKStackLayoutDistribution(.fillFlexing)
}

@objc public class LOKStackLayout: LOKBaseLayout {
    @objc public init(axis: LOKAxis?,
                      spacing: CGFloat = 0,
                      distribution: LOKStackLayoutDistribution? = nil,
                      alignment: LOKAlignment? = nil,
                      flexibility: LOKFlexibility? = nil,
                      viewClass: View.Type? = nil,
                      viewReuseId: String? = nil,
                      sublayouts: [LOKLayout],
                      configure: ((View) -> Void)? = nil) {
        super.init(layout: StackLayout(
            axis: axis?.axis ?? .vertical,
            spacing: spacing,
            distribution: distribution?.distribution ?? .fillFlexing,
            alignment: alignment?.alignment ?? .topFill,
            flexibility: flexibility?.flexibility,
            viewReuseId: viewReuseId,
            viewClass: viewClass,
            sublayouts: sublayouts.map { $0.unwrapped },
            config: configure))
    }
}
