// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import ObjectiveC
import Foundation

/**
 Provides APIs to recycle views by id.
 
 Initialize ViewRecycler with a root view whose subviews are eligible for recycling.
 Call `makeView(layoutId:)` to recycle or create a view of the desired type and id.
 Call `purgeViews()` to remove all unrecycled views from the view hierarchy.
 */
class ViewRecycler {

    private var viewsById = [String: View]()
    private var unidentifiedViews = Set<View>()

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
