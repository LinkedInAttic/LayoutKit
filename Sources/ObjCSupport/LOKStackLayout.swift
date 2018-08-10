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


/**
 Specifies how excess space along the axis is allocated.
 */
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

/**
 A layout that stacks sublayouts along an axis.

 Axis space is allocated to sublayouts according to the distribution policy.

 If this not enough space along the axis for all sublayouts then layouts with the highest flexibility are removed
 until there is enough space to posistion the remaining layouts.
 */
@objc open class LOKStackLayout: LOKBaseLayout {

    /**
     Axis along which sublayouts are stacked.
     */
    @objc public let axis: LOKAxis

    /**
     The distance in points between adjacent edges of sublayouts along the axis.
     For `Distribution.EqualSpacing`, this is a minimum spacing. For all other distributions it is an exact spacing.
     */
    @objc public let spacing: CGFloat

    /**
     Distribution of space along the stack's axis.
     */
    @objc public let distribution: LOKStackLayoutDistribution

    /**
     Specifies how this layout is positioned inside its parent layout.
     */
    @objc public let alignment: LOKAlignment

    /**
     Class object for the view class to be created.
     */
    @objc public let viewClass: View.Type

    /**
     The stacked layouts.
     */
    @objc public let sublayouts: [LOKLayout]

    /**
     Layoutkit configuration block called with created view.
     */
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
