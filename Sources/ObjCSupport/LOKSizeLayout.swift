// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

@objc open class LOKSizeLayout: LOKBaseLayout {
    @objc public let minWidth: CGFloat
    @objc public let maxWidth: CGFloat
    @objc public let minHeight: CGFloat
    @objc public let maxHeight: CGFloat
    @objc public let alignment: LOKAlignment
    @objc public let viewClass: View.Type
    @objc public let sublayout: LOKLayout?
    @objc public let configure: ((View) -> Void)?

    @objc public init(minWidth: CGFloat,
                      maxWidth: CGFloat,
                      minHeight: CGFloat,
                      maxHeight: CGFloat,
                      alignment: LOKAlignment?,
                      flexibility: LOKFlexibility?,
                      viewReuseId: String?,
                      viewClass: View.Type?,
                      sublayout: LOKLayout?,
                      configure: ((View) -> Void)? = nil) {
        self.minWidth = minWidth
        self.minHeight = minHeight
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.alignment = alignment ?? LOKAlignment(alignment: SizeLayout.defaultAlignment(maxWidth: maxWidth.isFinite ? maxWidth : nil,
                                                                                          maxHeight: maxHeight.isFinite ? maxHeight : nil))
        self.viewClass = viewClass ?? View.self
        self.sublayout = sublayout
        self.configure = configure
        let layout = SizeLayout(
            minWidth: self.minWidth,
            maxWidth: self.maxWidth.isFinite ? self.maxWidth : nil,
            minHeight: self.minHeight,
            maxHeight: self.maxHeight.isFinite ? self.maxHeight : nil,
            alignment: self.alignment.alignment,
            flexibility: flexibility?.flexibility,
            viewReuseId: viewReuseId,
            viewClass: self.viewClass,
            sublayout: self.sublayout?.unwrapped,
            config: self.configure)
        super.init(layout: layout)
    }
}
