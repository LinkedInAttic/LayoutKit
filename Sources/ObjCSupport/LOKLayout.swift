// Copyright 2018 LinkedIn Corp.
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

 - `LOKLabelLayout`
 - `LOKInsetLayout`
 - `LOKSizeLayout`
 - `LOKStackLayout`

 If your UI can not be expressed by composing these basic layouts,
 then you can create a custom layout. Custom layouts are recommended but not required to conform
 to the `ConfigurableLayout` protocol due to the type safety and default implementation that it adds.

 ### Layout algorithm

 Layout is performed in two steps:

 1. `measurement(within:)`
 2. `arrangement(within:measurement:)`.

 ### Threading

 Layouts MUST be thread-safe.
 */
@objc public protocol LOKLayout {

    /**
     Measures the minimum size of the layout and its sublayouts.

     It MAY be run on a background thread.

     - parameter maxSize: The maximum size available to the layout.
     - returns: The minimum size required by the layout and its sublayouts given a maximum size.
     The size of the layout MUST NOT exceed `maxSize`.
     */
    @objc func measurement(within maxSize: CGSize) -> LOKLayoutMeasurement

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
    @objc func arrangement(within rect: CGRect, measurement: LOKLayoutMeasurement) -> LOKLayoutArrangement

    /**
     Indicates whether a View object needs to be created for this layout.
     Layouts that just position their sublayouts can return `false` here.
     */
    @objc var needsView: Bool { get }

    /**
     Returns a new `UIView` for the layout.
     It is not called on a layout if the layout is using a recycled view.

     MUST be run on the main thread.
     */
    @objc func makeView() -> View

    /**
     Configures the given view.

     MUST be run on the main thread.
     */
    @objc func configureView(_ view: View)

    /**
     The flexibility of the layout.

     If a layout has a single sublayout, it SHOULD inherit the flexiblity of its sublayout.
     If a layout has no sublayouts (e.g. `LOKLabelLayout`), it SHOULD allow its flexibility to be configured.
     All layouts SHOULD provide a default flexiblity.

     TODO: figure out how to assert if inflexible layouts are compressed.
     */
    @objc var flexibility: LOKFlexibility { get }

    /**
     An identifier for the view that is produced by this layout.

     If this layout is applied to an existing view hierarchy, and if there is a view with an identical viewReuseId,
     then that view will be reused for the new layout. If there is more than one view with the same viewReuseId, then an arbitrary one will be reused.
     */
    @objc var viewReuseId: String? { get }
}

extension LOKLayout {
    var unwrapped: Layout {
        /*
         Need to check to see if `self` is one of the LayoutKit provided layouts.
         If so, we want to cast it as `LOKBaseLayout` and return the wrapped layout
         object directly.

         If `self` is not one of the LayoutKit provided layouts, we want to wrap it
         so that the methods of the class are called. We do this to make sure that if
         someone were to subclass one of the LayoutKit provided layouts, we would want
         to call their overriden methods instead of just the underlying layout object directly.

         Certain platforms don't have certain layouts, so we make a different array for each platform
         with only the layouts that it supports.
         */
        let allLayoutClasses: [AnyClass]
        #if os(OSX)
            allLayoutClasses = [
                LOKInsetLayout.self,
                LOKOverlayLayout.self,
                LOKSizeLayout.self,
                LOKStackLayout.self
            ]
        #elseif os(tvOS)
            allLayoutClasses = [
                LOKInsetLayout.self,
                LOKOverlayLayout.self,
                LOKTextViewLayout.self,
                LOKButtonLayout.self,
                LOKSizeLayout.self,
                LOKStackLayout.self
            ]
        #else
            allLayoutClasses = [
                LOKInsetLayout.self,
                LOKOverlayLayout.self,
                LOKTextViewLayout.self,
                LOKButtonLayout.self,
                LOKLabelLayout.self,
                LOKSizeLayout.self,
                LOKStackLayout.self
            ]
        #endif
        if let object = self as? NSObject {
            if allLayoutClasses.contains(where: { object.isMember(of: $0) }) {
                // Executes if `self` is one of the LayoutKit provided classes; not if it's a subclass
                guard let layout = (self as? LOKBaseLayout)?.layout else {
                    assertionFailure("LayoutKit provided layout does not inherit from LOKBaseLayout")
                    return ReverseWrappedLayout(layout: self)
                }
                return layout
            }
        }
        return (self as? WrappedLayout)?.layout ?? ReverseWrappedLayout(layout: self)
    }
}
