// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

@objc public class LOKLayoutArrangement: NSObject {
    let layoutArrangement: LayoutArrangement
    @objc public let layout: LOKLayout
    @objc public let sublayouts: [LOKLayoutArrangement]

    init(layoutArrangement: LayoutArrangement) {
        self.layoutArrangement = layoutArrangement
        self.layout = WrappedLayout(layout: layoutArrangement.layout)
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

    @objc public func makeViews(in view: View?) {
        layoutArrangement.makeViews(in: view)
    }

    @objc public func makeViews() -> View {
        return layoutArrangement.makeViews()
    }

    @objc public var frame: CGRect {
        return layoutArrangement.frame
    }
}

