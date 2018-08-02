// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

open class LOKBaseLayout: NSObject, LOKLayout {
    let layout: Layout

    init(layout: Layout) {
        self.layout = layout
    }

    public func measurement(within maxSize: CGSize) -> LOKLayoutMeasurement {
        return LOKLayoutMeasurement(wrappedLayout: self, layoutMeasurement: layout.measurement(within: maxSize))
    }

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

    open var needsView: Bool {
        return layout.needsView
    }

    public func makeView() -> View {
        return layout.makeView()
    }

    open func configureView(_ view: View) {
        layout.configure(baseTypeView: view)
    }

    public var flexibility: LOKFlexibility {
        return LOKFlexibility(flexibility: layout.flexibility)
    }

    public var viewReuseId: String? {
        return layout.viewReuseId
    }
}
