// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics
/**
 A base class for layouts.
 This layout does not require a view at runtime unless a configuration block has been provided.
 */
open class LOKBaseLayout: NSObject, LOKLayout {
    let layout: Layout

    init(layout: Layout) {
        self.layout = layout
    }

    /**
     Measures the minimum size of the layout and its sublayouts.

     It MAY be run on a background thread.

     - parameter maxSize: The maximum size available to the layout.
     - returns: The minimum size required by the layout and its sublayouts given a maximum size.
     The size of the layout MUST NOT exceed `maxSize`.
     */
    public func measurement(within maxSize: CGSize) -> LOKLayoutMeasurement {
        return LOKLayoutMeasurement(wrappedLayout: self, layoutMeasurement: layout.measurement(within: maxSize))
    }

    /**
     Returns the arrangement of frames for the layout inside a given rect.
     The frames SHOULD NOT overflow rect, otherwise they may overlap with adjacent layouts.

     The layout MAY choose to not use the entire rect (and instead align itself in some way inside of the rect),
     but the caller SHOULD NOT reallocate unused space to other layouts because this could break the layout's desired alignment and padding.
     Space allocation SHOULD happen during the measure pass.

     MAY be run on a background thread.

     - parameter rect: The rectangle that the layout must position itself in.
     - parameter measurement: A measurement which has size less than or equal to `rect.size` and greater than or equal to `measurement.maxSize`.
     - returns: A complete set of frames for the layout.
     */
    public func arrangement(within rect: CGRect, measurement: LOKLayoutMeasurement) -> LOKLayoutArrangement {
        let arrangement = layout.arrangement(within: rect, measurement: measurement.measurement)

        // The arrangement produced above has its layout property referencing a Swift layout object, such as SizeLayout, StackLayout, etc.
        // The current self object is wrapping that Swift layout object. This is fine in the common case where this object is just a LOKSizeLayout
        // or LOKStackLayout or similar which are just thin wrappers around the Swift object. It's possible thought that this current object is a class
        // that's derived from LOKSizeLayout/LOKStackLayout/etc with additional behavior, so we can't just assume that the Swift object is equivalent,
        // and should use the LOKLayout.unwrapped helper property to produce a Swift-friendly `Layout` version of this object, which works correctly
        // in both the common and derived classes.
        let arrangementWithUpdatedLayout = LayoutArrangement(layout: unwrapped, frame: arrangement.frame, sublayouts: arrangement.sublayouts)

        return LOKLayoutArrangement(layoutArrangement: arrangementWithUpdatedLayout)
    }

    /**
     Indicates whether a `View` object needs to be created for this layout.
     Layouts that just position their sublayouts can return `false` here.
     */
    open var needsView: Bool {
        return layout.needsView
    }

    /**
     Returns a new `UIView` for the layout.
     It is not called on a layout if the layout is using a recycled view.

     MUST be run on the main thread.
     */
    public func makeView() -> View {
        return layout.makeView()
    }

    /**
     A configuration block that is run on the main thread after the view is created.
     */
    open func configureView(_ view: View) {
        layout.configure(baseTypeView: view)
    }

    /**
     The flexibility of the layout.
     */
    public var flexibility: LOKFlexibility {
        return LOKFlexibility(flexibility: layout.flexibility)
    }

    /**
     An identifier for the view that is produced by this layout.
     */
    public var viewReuseId: String? {
        return layout.viewReuseId
    }
}
