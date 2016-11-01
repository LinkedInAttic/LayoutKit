// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit

/**
 A layout for a collection view that has fixed width cells.
 The height of the collection view is the height of the tallest cell.
 */
open class FixedWidthCellCollectionViewLayout<V: LayoutAdapterCollectionView, C: Collection>: BaseLayout<V>, ConfigurableLayout where C.Iterator.Element == Layout {

    private let cellWidth: CGFloat
    private let sectionLayouts: [Section<C>]
    public init(cellWidth: CGFloat, sectionLayouts: [Section<C>], alignment: Alignment = .topFill, viewReuseId: String? = nil, config: ((V) -> Void)? = nil) {
        self.cellWidth = cellWidth
        self.sectionLayouts = sectionLayouts
        super.init(alignment: alignment, flexibility: Flexibility(horizontal: Flexibility.defaultFlex, vertical: nil), viewReuseId: viewReuseId, config: config)
    }

    // Measure the sections/items with the fixed width and unlimited height.
    private lazy var sectionMeasurements: [Section<[LayoutMeasurement]>] = {
        return self.sectionLayouts.map { sectionLayout in
            return sectionLayout.map({ (layout: Layout) -> LayoutMeasurement in
                return layout.measurement(within: CGSize(width: self.cellWidth, height: CGFloat.greatestFiniteMagnitude))
            })
        }
    }()

    open func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        // Compute the max height of all sections/items so that we know the height of the collection view.
        let maxHeight = sectionMeasurements.reduce(0) { (maxHeight, measuredSection) -> CGFloat in
            let headerHeight = measuredSection.header?.size.height ?? 0
            let footerHeight = measuredSection.footer?.size.height ?? 0
            let maxItemHeight = measuredSection.items.map({ $0.size.height }).reduce(0, max)
            return max(maxHeight, headerHeight, maxItemHeight, footerHeight)
        }

        // No intrinsic width, but want to be tall enough for our tallest cell.
        let size = CGSize(width: 0, height: min(maxHeight, maxSize.height))
        return LayoutMeasurement(layout: self, size: size, maxSize: maxSize, sublayouts: [])
    }

    private var sectionArrangements: [Section<[LayoutArrangement]>]? = nil

    open func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        sectionArrangements = sectionMeasurements.map({ sectionMeasurement in
            return sectionMeasurement.map({ (measurement: LayoutMeasurement) -> LayoutArrangement in
                let rect = CGRect(x: 0, y: 0, width: self.cellWidth, height: rect.height)
                return measurement.arrangement(within: rect)
            })
        })

        let frame = Alignment.fill.position(size: measurement.size, in: rect)
        return LayoutArrangement(layout: self, frame: frame, sublayouts: [])
    }

    open override func configure(view: V) {
        super.configure(view: view)
        if let sectionArrangements = sectionArrangements {
            view.layoutAdapter.reload(arrangement: sectionArrangements)
        }
    }

    open override var needsView: Bool {
        return super.needsView || sectionArrangements != nil
    }
}
