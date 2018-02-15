// Copyright 2017 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

/**
 A layout that overlays others. Allows adding other layouts behind or above a primary layout.
 The size of the primary, background, and overlay layouts will be determined based on the size
 computed from the primary layout.
 */
open class OverlayLayout<V: View>: BaseLayout<V> {

    /**
     The primary layout that the `OverlayLayout` will use for sizing and flexibility.
     */
    open let primary: Layout

    /**
     The layouts to put behind the primary layout. They will be at most as large as the primary
     layout.
     */
    open let background: [Layout]

    /**
     The layouts to put in front of the primary layout. They will be at most as large as the primary
     layout.
     */
    open let overlay: [Layout]

    /**
     Creates an `OverlayLayout` with the given primary, background, and overlay layouts. Alignment
     can be specified but defaults to `.fill`. Flexibility will always be the flexibility of the
     primary layout.
     */
    public init(primary: Layout,
                background: [Layout] = [],
                overlay: [Layout] = [],
                alignment: Alignment = .fill,
                viewReuseId: String? = nil,
                config: ((V) -> Void)? = nil) {
        self.primary = primary
        self.background = background
        self.overlay = overlay
        super.init(alignment: alignment, flexibility: primary.flexibility, viewReuseId: viewReuseId, config: config)
    }

    init(primary: Layout,
         background: [Layout] = [],
         overlay: [Layout] = [],
         alignment: Alignment = .fill,
         viewReuseId: String? = nil,
         viewClass: V.Type? = nil,
         config: ((V) -> Void)? = nil) {
        self.primary = primary
        self.background = background
        self.overlay = overlay
        super.init(alignment: alignment, flexibility: primary.flexibility, viewReuseId: viewReuseId, viewClass: viewClass ?? V.self, config: config)
    }
}

// MARK: - Layout interface

extension OverlayLayout: ConfigurableLayout {

    /**
     Measure all layouts and return the layout measurement with the size of the primary layout.
     */
    open func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        let measuredSublayout = primary.measurement(within: maxSize)

        // Measure the background and overlay layouts
        let measuredBackgroundLayouts = background.map { $0.measurement(within: measuredSublayout.maxSize) }
        let measuredOverlayLayouts = overlay.map { $0.measurement(within: measuredSublayout.maxSize) }
        let measuredSublayouts = Array([measuredBackgroundLayouts, [measuredSublayout], measuredOverlayLayouts].joined())
        return LayoutMeasurement(layout: self, size: measuredSublayout.size, maxSize: maxSize, sublayouts: measuredSublayouts)
    }

    /**
     Position the layout based on the alignment in the measurement's size. Arrange all layouts
     (primary, background and overlay) inside the rect created from the alignment's position in
     the measurement's size.
     */
    open func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        let frame = alignment.position(size: measurement.size, in: rect)

        // Get measurement sublayouts
        let measuredBackgroundLayouts = measurement.sublayouts.prefix(background.count)
        let measuredOverlayLayouts = measurement.sublayouts.suffix(overlay.count)

        // Make sure we have at least enough sublayouts to get the primary layout
        guard measurement.sublayouts.count >= background.count else {
            return LayoutArrangement(layout: self, frame: frame, sublayouts: [])
        }
        let primaryLayoutMeasurement = measurement.sublayouts[background.count]

        // We arrange the background and overlay layouts based on the rect of the sublayout
        let sublayoutRect = CGRect(origin: CGPoint.zero, size: frame.size)
        let primaryArrangement = primaryLayoutMeasurement.arrangement(within: sublayoutRect)
        let backgroundArrangements = measuredBackgroundLayouts.map { $0.arrangement(within: sublayoutRect) }
        let overlayArrangements = measuredOverlayLayouts.map { $0.arrangement(within: sublayoutRect) }
        let sublayoutArrangements = [backgroundArrangements, [primaryArrangement], overlayArrangements].joined()

        return LayoutArrangement(layout: self, frame: frame, sublayouts: Array(sublayoutArrangements))
    }

}
