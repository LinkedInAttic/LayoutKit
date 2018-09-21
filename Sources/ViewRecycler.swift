// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import ObjectiveC
import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#endif

/**
 Provides APIs to recycle views by id.
 
 Initialize ViewRecycler with a root view whose subviews are eligible for recycling.
 Call `makeView(layoutId:)` to recycle or create a view of the desired type and id.
 Call `purgeViews()` to remove all unrecycled views from the view hierarchy.
 */
class ViewRecycler {

    private var viewsById = [String: View]()
    private var unidentifiedViews = Set<View>()
    #if os(iOS) || os(tvOS)
    private let defaultLayerAnchorPoint = CGPoint(x: 0.5, y: 0.5)
    private let defaultTransform = CGAffineTransform.identity
    #endif

    /// Retains all subviews of rootView for recycling.
    init(rootView: View?) {
        rootView?.walkSubviews { (view) in
            if let viewReuseId = view.viewReuseId {
                self.viewsById[viewReuseId] = view
            } else {
                self.unidentifiedViews.insert(view)
            }
        }
    }

    /**
     Returns a view for the layout.
     It may recycle an existing view or create a new view.
     */
    func makeOrRecycleView(havingViewReuseId viewReuseId: String?, viewProvider: () -> View) -> View? {
        // If we have a recyclable view that matches type and id, then reuse it.
        if let viewReuseId = viewReuseId, let view = viewsById[viewReuseId] {
            viewsById[viewReuseId] = nil

            #if os(iOS) || os(tvOS)
            // Reset affine transformation and layer anchor point to their default values.
            // Without this there will be an issue when their current value is not the default.
            // Take affine transformation for example, the issue goes like this.
            // 1. View has a non-identity transform.
            // 2. View gets retrieved from the viewsById map.
            // 3. View's frame gets set under the assumption that its transform is identity.
            // 4. View's transform gets set to a value.
            // 5. View's frame gets changed automatically when its transform gets set. As a result, view's frame will not match its transform.
            // Example:
            // 1. View has a scale transform of (0.001, 0.001).
            // 2. View gets reused so its transform is still (0.001, 0.001).
            // 3. View's frame gets set to (0, 0, 100, 100) which is its original size.
            // 4. View's transform gets set to identity in a config block.
            // 5. One would expect view's frame to be (0, 0, 100, 100) since its transform is now identity. But actually its frame will be
            //    (-49950, -49950, 100000, 100000) because its scale has just gone up 1000-fold, i.e. from 0.001 to 1.
            if view.layer.anchorPoint != defaultLayerAnchorPoint {
                view.layer.anchorPoint = defaultLayerAnchorPoint
            }

            if view.transform != defaultTransform {
                view.transform = defaultTransform
            }
            #endif

            return view
        }

        let providedView = viewProvider()
        providedView.isLayoutKitView = true

        // Remove the provided view from the list of cached views.
        if let viewReuseId = providedView.viewReuseId, let oldView = viewsById[viewReuseId], oldView == providedView {
            viewsById[viewReuseId] = nil
        } else {
            unidentifiedViews.remove(providedView)
        }
        providedView.viewReuseId = viewReuseId
        return providedView
    }

    /// Removes all unrecycled views from the view hierarchy.
    func purgeViews() {
        for view in viewsById.values {
            view.removeFromSuperview()
        }
        viewsById.removeAll()

        for view in unidentifiedViews where view.isLayoutKitView {
            view.removeFromSuperview()
        }
        unidentifiedViews.removeAll()
    }
}

private var viewReuseIdKey: UInt8 = 0
private var isLayoutKitViewKey: UInt8 = 0

extension View {

    /// Calls visitor for each transitive subview.
    func walkSubviews(visitor: (View) -> Void) {
        for subview in subviews {
            visitor(subview)
            subview.walkSubviews(visitor: visitor)
        }
    }

    /// Identifies the layout that was used to create this view.
    public internal(set) var viewReuseId: String? {
        get {
            return objc_getAssociatedObject(self, &viewReuseIdKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &viewReuseIdKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    /// Indicates the view is managed by LayoutKit that can be safely removed.
    var isLayoutKitView: Bool {
        get {
            return (objc_getAssociatedObject(self, &isLayoutKitViewKey) as? NSNumber)?.boolValue ?? false
        }
        set {
            objc_setAssociatedObject(self, &isLayoutKitViewKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
