// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

/**
 The frame of a layout and the frames of its sublayouts.
 */
public struct LayoutArrangement {
    public let layout: Layout
    public let frame: CGRect
    public let sublayouts: [LayoutArrangement]

    public init(layout: Layout, frame: CGRect, sublayouts: [LayoutArrangement]) {
        self.layout = layout
        self.frame = frame
        self.sublayouts = sublayouts
    }

    /**
     Creates the views for the layout and adds them as subviews to the provided view.
     Existing subviews of the provided view will be removed.
     If no view is provided, then a new one is created and returned.

     - parameter view: The layout's views will be added as subviews to this view, if provided.
     - parameter direction: The natural direction of the layout (default: .LeftToRight).
     If it does not match the user's language direction, then the layout's views will be flipped horizontally.
     Only provide this parameter if you want to test the flipped version of your layout, or if your layouts are declared for
     the right-to-left languages and you want them to get flipped for left-to-right languages.

     - returns: The root view. If a view was provided, the same view will be returned, otherwise, a new one will be created.
     */
    public func makeViews(inView view: View? = nil, direction: UserInterfaceLayoutDirection = .LeftToRight) -> View {
        let views = makeSubviews()
        let rootView: View

        if let view = view {
            // We have a parent view so replace all of its subviews.
            // TODO: could be smarter and reuse views.
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            for subview in views {
                view.addSubview(subview)
            }
            rootView = view
        } else if let view = views.first where views.count == 1 {
            // We have a single view so it is our root view.
            rootView = view
        } else {
            // We have multiple views so create a root view.
            rootView = View(frame: frame)
            for subview in views {
                // Unapply the offset that was applied in makeSubviews()
                subview.frame.offsetInPlace(dx: -frame.origin.x, dy: -frame.origin.y)
                rootView.addSubview(subview)
            }
        }

        handleLayoutDirection(rootView, direction: direction)
        return rootView
    }

    /// Horizontally flips the view frames if direction does not match the user's language direction.
    private func handleLayoutDirection(view: View, direction: UserInterfaceLayoutDirection) {
        if Application.sharedApplication().userInterfaceLayoutDirection != direction {
            flipSubviewsHorizontally(view)
        }
    }

    /// Flips the right and left edges of the view's subviews.
    private func flipSubviewsHorizontally(view: View) {
        for subview in view.subviews {
            subview.frame.origin.x = view.frame.width - subview.frame.maxX
            flipSubviewsHorizontally(subview)
        }
    }

    /// Returns the views for the layout and all of its sublayouts.
    private func makeSubviews() -> [View] {
        let subviews = sublayouts.flatMap({ (sublayout: LayoutArrangement) -> [View] in
            return sublayout.makeSubviews()
        })
        if let view = layout.makeView() {
            view.frame = frame
            for subview in subviews {
                view.addSubview(subview)
            }
            return [view]
        } else {
            for subview in subviews {
                subview.frame.offsetInPlace(dx: frame.origin.x, dy: frame.origin.y)
            }
            return subviews
        }
    }
}