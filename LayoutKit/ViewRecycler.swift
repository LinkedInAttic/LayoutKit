// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import ObjectiveC

/**
 Provides APIs to recycle views by id.
 
 Initialize ViewRecycler with a root view whose subviews are eligible for recycling.
 Call `makeView(layoutId:)` to recycle or create a view of the desired type and id.
 Call `purgeViews()` to remove all unrecycled views from the view hierarchy.
 */
open class ViewRecycler {

    private var viewsById = [String: View]()
    private var unidentifiedViews = Set<View>()

    /// Retains all subviews of rootView for recycling.
    public init(rootView: View?) {
        rootView?.walkSubviews { (view) in
            if let viewReuseId = view.viewReuseId {
                self.viewsById[viewReuseId] = view
            } else {
                self.unidentifiedViews.insert(view)
            }
        }
    }

    /// Marks a view as recycled so that `purgeViews()` doesn't remove it from the view hierarchy.
    /// It is only necessary to call this if a view is reused without calling `makeView(layoutId:)`.
    open func markViewAsRecycled(_ view: View) {
        if let viewReuseId = view.viewReuseId {
            viewsById[viewReuseId] = nil
        } else {
            unidentifiedViews.remove(view)
        }
    }

    /// Creates or recycles a view of the desired type and id.
    open func makeView<V: View>(viewReuseId: String?) -> V {
        // If we have a recyclable view that matches type and id, then reuse it.
        if let viewReuseId = viewReuseId, let view = viewsById[viewReuseId] as? V {
            viewsById[viewReuseId] = nil
            return view
        }

        let v = V()
        v.viewReuseId = viewReuseId
        return v
    }

    /// Removes all unrecycled views from the view hierarchy.
    open func purgeViews() {
        for view in viewsById.values {
            view.removeFromSuperview()
        }
        viewsById.removeAll()

        for view in unidentifiedViews {
            view.removeFromSuperview()
        }
        unidentifiedViews.removeAll()
    }
}

private var viewReuseIdKey: UInt8 = 0

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
}
