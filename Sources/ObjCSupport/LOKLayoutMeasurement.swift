// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

@objc open class LOKLayoutMeasurement: NSObject {
    let measurement: LayoutMeasurement
    private let wrappedLayout: LOKLayout

    /// The layout that was measured.
    @objc public var layout: LOKLayout {
        return wrappedLayout
    }

    /// The minimum size of the layout given the maximum size constraint.
    @objc public var size: CGSize {
        return measurement.size
    }

    /// The maximum size constraint used during measurement.
    @objc public var maxSize: CGSize {
        return measurement.maxSize
    }

    /// The measurements of the layout's sublayouts.
    @objc public var sublayouts: [LOKLayoutMeasurement] {
        return measurement.sublayouts.map { LOKLayoutMeasurement(layoutMeasurement: $0) }
    }

    @objc public init(layout: LOKLayout, size: CGSize, maxSize: CGSize, sublayouts: [LOKLayoutMeasurement]) {
        wrappedLayout = layout
        measurement = LayoutMeasurement(layout: layout.unwrapped, size: size, maxSize: maxSize, sublayouts: sublayouts.map { $0.measurement })
    }

    init(layoutMeasurement: LayoutMeasurement) {
        wrappedLayout = WrappedLayout.wrap(layout: layoutMeasurement.layout)
        measurement = layoutMeasurement
    }

    init(wrappedLayout: LOKLayout, layoutMeasurement: LayoutMeasurement) {
        self.wrappedLayout = wrappedLayout
        measurement = layoutMeasurement
    }

    /// Convenience method to position this measured layout.
    @objc public func arrangement(within rect: CGRect) -> LOKLayoutArrangement {
        return LOKLayoutArrangement(layoutArrangement: measurement.arrangement(within: rect))
    }

}
