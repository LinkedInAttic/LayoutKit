// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

extension LOKAxis {
    var axis: Axis {
        switch self {
        case .vertical:
            return .vertical
        case .horizontal:
            return .horizontal
        }
    }
}

extension LOKStackLayoutDistribution {
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
    @objc public let axis: LOKAxis
    @objc public let spacing: CGFloat
    @objc public let distribution: LOKStackLayoutDistribution
    @objc public let alignment: LOKAlignment
    @objc public let viewClass: View.Type
    @objc public let sublayouts: [LOKLayout]
    @objc public let configure: ((View) -> Void)?

    @objc public init(axis: LOKAxis = .vertical,
                      spacing: CGFloat = 0,
                      distribution: LOKStackLayoutDistribution = .`default`,
                      alignment: LOKAlignment? = nil,
                      flexibility: LOKFlexibility? = nil,
                      viewClass: View.Type? = nil,
                      viewReuseId: String? = nil,
                      sublayouts: [LOKLayout]?,
                      configure: ((View) -> Void)? = nil) {
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution.distribution != nil ? distribution : .fillFlexing
        self.sublayouts = sublayouts ?? []
        self.alignment = alignment ?? .fill
        self.viewClass = viewClass ?? View.self
        self.configure = configure
        super.init(layout: StackLayout(
            axis: self.axis.axis,
            spacing: self.spacing,
            distribution: self.distribution.distribution ?? .fillFlexing,
            alignment: self.alignment.alignment,
            flexibility: flexibility?.flexibility,
            viewReuseId: viewReuseId,
            viewClass: self.viewClass,
            sublayouts: self.sublayouts.map { $0.unwrapped },
            config: self.configure))
    }
}
