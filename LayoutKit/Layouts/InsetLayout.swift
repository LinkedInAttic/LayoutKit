// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

/**
 A layout that insets another layout.
 */
public class InsetLayout<V: View>: BaseLayout<V>, ConfigurableLayout {
    
    public let insets: EdgeInsets
    public let sublayout: Layout

    public init(insets: EdgeInsets,
                alignment: Alignment = Alignment.fill,
                viewReuseId: String? = nil,
                sublayout: Layout,
                config: (View -> Void)? = nil) {
        self.insets = insets
        self.sublayout = sublayout
        super.init(alignment: alignment, flexibility: sublayout.flexibility, viewReuseId: viewReuseId, config: config)
    }

    public convenience init(inset: CGFloat,
                            alignment: Alignment = Alignment.fill,
                            viewReuseId: String? = nil,
                            sublayout: Layout,
                            config: (View -> Void)? = nil) {
        let insets = EdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        self.init(insets: insets, alignment: alignment, viewReuseId: viewReuseId, sublayout: sublayout, config: config)
    }

    public func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        let insetMaxSize = maxSize.sizeDecreasedByInsets(insets)
        let sublayoutMeasurement = sublayout.measurement(within: insetMaxSize)
        let size = sublayoutMeasurement.size.sizeIncreasedByInsets(insets)
        return LayoutMeasurement(layout: self, size: size, maxSize: maxSize, sublayouts: [sublayoutMeasurement])
    }

    public func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        let frame = alignment.position(size: measurement.size, in: rect)
        let insetOrigin = CGPoint(x: insets.left, y: insets.top)
        let insetSize = frame.size.sizeDecreasedByInsets(insets)
        let sublayoutRect = CGRect(origin: insetOrigin, size: insetSize)
        let sublayouts = measurement.sublayouts.map { (measurement: LayoutMeasurement) -> LayoutArrangement in
            return measurement.arrangement(within: sublayoutRect)
        }
        return LayoutArrangement(layout: self, frame: frame, sublayouts: sublayouts)
    }
}
