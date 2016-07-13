// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

/**
 A protocol for types that layout view frames.
 
 ### Basic layouts

 Many UIs can be expressed by composing the basic layouts that LayoutKit provides:

 - `LabelLayout`
 - `InsetLayout`
 - `SizeLayout`
 - `StackLayout`
 
 If your UI can not be expressed by composing these basic layouts,
 then you can create a custom layout that implements the `Layout` protocol.

 ### Layout algorithm

 Layout is performed in two steps:

   1. `measurement(within:)`
   2. `arrangement(within:measurement:)`.

 `arrangement(origin:width:height:)` is a convenience method for doing both passes in one function call.

 ### Threading

 Layouts MUST be thread-safe.
*/
public protocol Layout {

    /**
     Measures the minimum size of the layout and its sublayouts.

     It MAY be run on a background thread.
     
     - parameter maxSize: The maximum size available to the layout.
     - returns: The minimum size required by the layout and its sublayouts given a maximum size.
     The size of the layout MUST NOT exceed `maxSize`.
     */
    func measurement(within maxSize: CGSize) -> LayoutMeasurement

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
    func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement

    /**
     Returns a UIView for the layout or nil if the layout does not require a view (i.e. it merely positions sublayouts).

     MUST be run on the main thread.
     */
    func makeView() -> View?

    /**
     The flexibility of the layout.

     If a layout has a single sublayout, it SHOULD inherit the flexiblity of its sublayout.
     If a layout has no sublayouts (e.g. LabelLayout), it SHOULD allow its flexibility to be configured.
     All layouts SHOULD provide a default flexiblity.

     TODO: figure out how to assert if inflexible layouts are compressed.
     */
    var flexibility: Flexibility { get }
}

public extension Layout {

    /**
     Convenience function that measures and positions the layout given exact width and/or height constraints.

     - parameter origin: The returned layout will be positioned at origin. Defaults to CGPointZero.
     - parameter width: The exact width that the layout should consume.
         If nil, the layout is given exactly the size that it requested during the measure pass.
     - parameter height: The exact height that the layout should consume.
         If nil, the layout is given exactly the size that it requested during the measure pass.
     */
    final func arrangement(origin origin: CGPoint = CGPointZero, width: CGFloat? = nil, height: CGFloat? = nil) -> LayoutArrangement {
//        let start = CFAbsoluteTimeGetCurrent()
        let maxSize = CGSize(width: width ?? CGFloat.max, height: height ?? CGFloat.max)
        let measurement = self.measurement(within: maxSize)
//        let measureEnd = CFAbsoluteTimeGetCurrent()
        var rect = CGRect(origin: origin, size: measurement.size)
        rect.size.width = width ?? rect.size.width
        rect.size.height = height ?? rect.size.height
        let arrangement = self.arrangement(within: rect, measurement: measurement)
//        let layoutEnd = CFAbsoluteTimeGetCurrent()
//        NSLog("layout: \((layoutEnd-start).ms) (measure: \((measureEnd-start).ms) + layout: \((layoutEnd-measureEnd).ms))")
        return arrangement
    }
}
