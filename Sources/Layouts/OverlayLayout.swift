// Copyright 2017 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

/**
 A layout that overlays others. Allows adding other layouts behind or above one or more primary layouts.
 The size of the primary, background, and overlay layouts will be determined based on the size
 computed from the primary layouts.
 */
open class OverlayLayout<V: View>: BaseLayout<V> {

    /**
     The primary layouts that the `OverlayLayout` will use for sizing and flexibility.
     */
    open let primary: [Layout]

    /**
     The layouts to put behind the primary layouts. They will be at most as large as the primary
     layouts.
     */
    open let background: [Layout]

    /**
     The layouts to put in front of the primary layouts. They will be at most as large as the primary
     layouts.
     */
    open let overlay: [Layout]

    /**
     Creates an `OverlayLayout` with the given primary, background, and overlay layouts. Alignment
     can be specified but defaults to `.fill`. Flexibility will always be the flexibility of the
     first primary layout.
     */
    public init(primaries: [Layout],
                background: [Layout] = [],
                overlay: [Layout] = [],
                alignment: Alignment = .fill,
                viewReuseId: String? = nil,
                config: ((V) -> Void)? = nil) {
        self.primary = primaries
        self.background = background
        self.overlay = overlay
        super.init(alignment: alignment, flexibility: primaries.first?.flexibility ?? .flexible, viewReuseId: viewReuseId, config: config)
    }

    /**
     Creates an `OverlayLayout` with the given primary, background, and overlay layouts. Alignment
     can be specified but defaults to `.fill`. Flexibility will always be the flexibility of the
     primary layout.
     */
    convenience public init(primary: Layout,
                            background: [Layout] = [],
                            overlay: [Layout] = [],
                            alignment: Alignment = .fill,
                            viewReuseId: String? = nil,
                            config: ((V) -> Void)? = nil) {
        self.init(primaries: [primary], background: background, overlay: overlay, alignment: alignment, viewReuseId: viewReuseId, config: config)
    }

    init(primaries: [Layout],
         background: [Layout] = [],
         overlay: [Layout] = [],
         alignment: Alignment = .fill,
         viewReuseId: String? = nil,
         viewClass: V.Type? = nil,
         config: ((V) -> Void)? = nil) {
        self.primary = primaries
        self.background = background
        self.overlay = overlay
        super.init(alignment: alignment,
                   flexibility: primaries.first?.flexibility ?? .flexible,
                   viewReuseId: viewReuseId,
                   viewClass: viewClass ?? V.self,
                   config: config)
    }

    convenience init(primary: Layout,
                     background: [Layout] = [],
                     overlay: [Layout] = [],
                     alignment: Alignment = .fill,
                     viewReuseId: String? = nil,
                     viewClass: V.Type? = nil,
                     config: ((V) -> Void)? = nil) {
        self.init(primaries: [primary],
                  background: background,
                  overlay: overlay,
                  alignment: alignment,
                  viewReuseId: viewReuseId,
                  viewClass: viewClass,
                  config: config)
    }
}

// MARK: - Layout interface

extension OverlayLayout: ConfigurableLayout {

    /**
     Measure all layouts and return the layout measurement with the size of the primary layout.
     */
    open func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        let measuredPrimaryLayouts = primary.map { $0.measurement(within: maxSize)}
        let maxWidth = measuredPrimaryLayouts.map { $0.size.width }.max() ?? 0
        let maxHeight = measuredPrimaryLayouts.map { $0.size.height }.max() ?? 0
        let maxPrimarySize = CGSize(width: maxWidth, height: maxHeight)

        // Measure the background and overlay layouts
        let measuredBackgroundLayouts = background.map { $0.measurement(within: maxSize) }
        let measuredOverlayLayouts = overlay.map { $0.measurement(within: maxSize) }
        let measuredSublayouts = Array([measuredBackgroundLayouts, measuredPrimaryLayouts, measuredOverlayLayouts].joined())
        return LayoutMeasurement(layout: self, size: maxPrimarySize, maxSize: maxSize, sublayouts: measuredSublayouts)
    }

    /**
     Position the layout based on the alignment in the measurement's size. Arrange all layouts
     (primary, background and overlay) inside the rect created from the alignment's position in
     the measurement's size.
     */
    open func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        // We arrange the background and overlay layouts based on the rect of the sublayout
        let frame = alignment.position(size: measurement.size, in: rect)
        let sublayoutRect = CGRect(origin: CGPoint.zero, size: frame.size)
        let sublayoutArrangements = measurement.sublayouts.map { $0.arrangement(within: sublayoutRect) }

        return LayoutArrangement(layout: self, frame: frame, sublayouts: Array(sublayoutArrangements))
    }

}
