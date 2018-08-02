// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

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

    @discardableResult
    @objc public func makeViews(in view: View?) -> View {
        return layoutArrangement.makeViews(in: view)
    }

    @discardableResult
    @objc public func makeViews(in view: View?, direction: UserInterfaceLayoutDirection) -> View {
        return layoutArrangement.makeViews(in: view, direction: direction)
    }

    @objc public func makeViews() -> View {
        return layoutArrangement.makeViews()
    }

    @objc(prepareAnimationForView:direction:)
    public func prepareAnimation(for view: View, direction: UserInterfaceLayoutDirection) -> LOKAnimation {
        return LOKAnimation(animation: layoutArrangement.prepareAnimation(for: view, direction: direction))
    }

    @objc(prepareAnimationForView:)
    public func prepareAnimation(for view: View) -> LOKAnimation {
        return prepareAnimation(for: view, direction: .leftToRight)
    }

    @objc public var frame: CGRect {
        return layoutArrangement.frame
    }
}

