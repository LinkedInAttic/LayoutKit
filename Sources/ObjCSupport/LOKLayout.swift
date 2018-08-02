// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

@objc public protocol LOKLayout {
    @objc func measurement(within maxSize: CGSize) -> LOKLayoutMeasurement
    @objc func arrangement(within rect: CGRect, measurement: LOKLayoutMeasurement) -> LOKLayoutArrangement
    @objc var needsView: Bool { get }
    @objc func makeView() -> View
    @objc func configureView(_ view: View)
    @objc var flexibility: LOKFlexibility { get }
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
