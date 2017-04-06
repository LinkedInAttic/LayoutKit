// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

/**
 The size of a layout and the sizes of its sublayouts.
 */
public struct LayoutMeasurement {

    /// The layout that was measured.
    public let layout: Layout

    /// The minimum size of the layout given the maximum size constraint.
    public let size: CGSize

    /// The maximum size constraint used during measurement.
    public let maxSize: CGSize

    /// The measurements of the layout's sublayouts.
    public let sublayouts: [LayoutMeasurement]

    public init(layout: Layout, size: CGSize, maxSize: CGSize, sublayouts: [LayoutMeasurement]) {
        self.layout = layout
        self.size = size
        self.maxSize = maxSize
        self.sublayouts = sublayouts
    }

    /// Convenience method to position this measured layout.
    public func arrangement(within rect: CGRect) -> LayoutArrangement {
        return layout.arrangement(within: rect, measurement: self)
    }
}