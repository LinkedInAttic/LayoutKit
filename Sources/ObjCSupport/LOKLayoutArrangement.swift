// Copyright 2018 LinkedIn Corp.
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
@objc open class LOKLayoutArrangement: NSObject {
    let layoutArrangement: LayoutArrangement
    @objc public let layout: LOKLayout
    @objc public let sublayouts: [LOKLayoutArrangement]

    init(layoutArrangement: LayoutArrangement) {
        self.layoutArrangement = layoutArrangement
        self.layout = WrappedLayout.wrap(layout: layoutArrangement.layout)
        self.sublayouts = layoutArrangement.sublayouts.map { LOKLayoutArrangement(layoutArrangement: $0) }
    }

    @objc public init(layout: LOKLayout, frame: CGRect, sublayouts: [LOKLayoutArrangement]) {
        self.layoutArrangement = LayoutArrangement(layout: layout.unwrapped, frame: frame, sublayouts: sublayouts.map { $0.layoutArrangement })
        self.layout = layout
        self.sublayouts = sublayouts
    }

    @objc public class func arrangeLayout(_ layout: LOKLayout, width: CGFloat, height: CGFloat) -> LOKLayoutArrangement {
        return LOKLayoutArrangement(layoutArrangement: layout.unwrapped.arrangement(
            width: width.isFinite ? width : nil,
            height: height.isFinite ? height : nil))
    }

    @objc public class func arrangeLayout(_ layout: LOKLayout, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> LOKLayoutArrangement {
        return LOKLayoutArrangement(layoutArrangement: layout.unwrapped.arrangement(
            origin: CGPoint(x: x, y: y),
            width: width.isFinite ? width : nil,
            height: height.isFinite ? height : nil))
    }

    /**
     Creates the views for the layout and adds them as subviews to the provided view.
     Existing subviews of the provided view will be removed.
     If no view is provided, then a new one is created and returned.

     MUST be run on the main thread.

     - parameter view: The layout's views will be added as subviews to this view, if provided.

     - returns: The root view. If a view was provided, then the same view will be returned, otherwise, a new one will be created.
     */
    @discardableResult
    @objc public func makeViews(in view: View?) -> View {
        return layoutArrangement.makeViews(in: view)
    }

    /**
     Creates the views for the layout and adds them as subviews to the provided view.
     Existing subviews of the provided view will be removed.
     If no view is provided, then a new one is created and returned.

     MUST be run on the main thread.

     - parameter view: The layout's views will be added as subviews to this view, if provided.
     - parameter direction: The natural direction of the layout (default: `.LeftToRight`).
     If it does not match the user's language direction, then the layout's views will be flipped horizontally.
     Only provide this parameter if you want to test the flipped version of your layout,
     or if your layouts are declared for right-to-left languages and you want them to get flipped for left-to-right languages.

     - returns: The root view. If a view was provided, then the same view will be returned, otherwise, a new one will be created.
     */
    @discardableResult
    @objc public func makeViews(in view: View?, direction: UserInterfaceLayoutDirection) -> View {
        return layoutArrangement.makeViews(in: view, direction: direction)
    }

    /**
     Helper function for `makeViews(in:direction:)` and `prepareAnimation(for:direction:)`.
     See the documentation for those two functions.
     */
    @objc public func makeViews() -> View {
        return layoutArrangement.makeViews()
    }

    /**
     Prepares the view to be animated to this arrangement.

     Call `prepareAnimation(for:direction)` before the animation block.
     Call the returned animation's `apply()` method inside the animation block.

     ```
     let animation = nextLayout.arrangement().prepareAnimation(for: rootView, direction: .RightToLeft)
     View.animateWithDuration(5.0, animations: {
     animation.apply()
     })
     ```

     Subviews are reparented for the new arrangement, if necessary, but frames are adjusted so locations don't change.
     No frames or configurations of the new arrangement are applied until `apply()` is called on the returned animation object.

     MUST be run on the main thread.
     */
    @objc(prepareAnimationForView:direction:)
    public func prepareAnimation(for view: View, direction: UserInterfaceLayoutDirection) -> LOKAnimation {
        return LOKAnimation(animation: layoutArrangement.prepareAnimation(for: view, direction: direction))
    }

    /**
     Prepares the view to be animated to this arrangement.

     Call `prepareAnimation(for:)` before the animation block.
     Call the returned animation's `apply()` method inside the animation block.

     ```
     let animation = nextLayout.arrangement().prepareAnimation(for: rootView, direction: .RightToLeft)
     View.animateWithDuration(5.0, animations: {
     animation.apply()
     })
     ```

     Subviews are reparented for the new arrangement, if necessary, but frames are adjusted so locations don't change.
     No frames or configurations of the new arrangement are applied until `apply()` is called on the returned animation object.

     MUST be run on the main thread.
     */
    @objc(prepareAnimationForView:)
    public func prepareAnimation(for view: View) -> LOKAnimation {
        return prepareAnimation(for: view, direction: .leftToRight)
    }

    @objc public var frame: CGRect {
        return layoutArrangement.frame
    }
}

