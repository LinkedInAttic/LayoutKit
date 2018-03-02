// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

@objc public enum LOKAxis: Int {
    case vertical = 0
    case horizontal
    var axis: Axis {
        switch self {
        case .vertical:
            return .vertical
        case .horizontal:
            return .horizontal
        }
    }
}

@objc public enum LOKStackLayoutDistribution: Int {
    case `default`
    case leading
    case trailing
    case center
    case fillEqualSpacing
    case fillEqualSize
    case fillFlexing
    var distribution: StackLayoutDistribution? {
        switch self {
        case .`default`:
            return nil
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        case .center:
            return .center
        case .fillEqualSpacing:
            return .fillEqualSpacing
        case .fillEqualSize:
            return .fillEqualSize
        case .fillFlexing:
            return .fillFlexing
        }
    }
}

@objc open class LOKStackLayout: LOKBaseLayout {
    @objc public init(axis: LOKAxis = .vertical,
                      spacing: CGFloat = 0,
                      distribution: LOKStackLayoutDistribution = .`default`,
                      alignment: LOKAlignment? = nil,
                      flexibility: LOKFlexibility? = nil,
                      viewClass: View.Type? = nil,
                      viewReuseId: String? = nil,
                      sublayouts: [LOKLayout]?,
                      configure: ((View) -> Void)? = nil) {
        super.init(layout: StackLayout(
            axis: axis.axis,
            spacing: spacing,
            distribution: distribution.distribution ?? .fillFlexing,
            alignment: alignment?.alignment ?? .topFill,
            flexibility: flexibility?.flexibility,
            viewReuseId: viewReuseId,
            viewClass: viewClass,
            sublayouts: sublayouts?.map { $0.unwrapped } ?? [],
            config: configure))
    }
}
