// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

/**
 A layout that has size constraints.

 ## Default behavior

 Alignment along a dimension defaults to `.fill` if there is no maximum constraint along that dimension and `.center` otherwise.

 ## Constraint precedence

 Constraints are enforced with the following precedence:
 1. The `maxSize` paremeter of measurement.
 2. The SizeLayout's `maxSize`
 3. The SizeLayout's `minSize`

 In other words, if it is impossible to satisfy all constraints simultaneously then
 constraints are broken starting with minSize.

 ## Use cases

 Some common use cases:

 ```
 // A label with maximum width.
 LOKSizeLayout<UIView>(maxWidth: 100, sublayout: LOKLabelLayout(text: "Spills onto two lines"))

 // A label with minimum width.
 LOKSizeLayout<UIView>(minWidth: 100, sublayout: LOKLabelLayout(text: "Hello", alignment: .fill))
 ```
 */
@objc open class LOKSizeLayout: LOKBaseLayout {

    /**
     Minimum width for size layout.
     */
    @objc public let minWidth: CGFloat

    /**
     Maximum width for size layout.
     */
    @objc public let maxWidth: CGFloat

    /**
     Minimum height for size layout.
     */
    @objc public let minHeight: CGFloat

    /**
     Maximum height for size layout.
     */
    @objc public let maxHeight: CGFloat

    /**
     Alignment height for size layout.
     */
    @objc public let alignment: LOKAlignment

    /**
     Class object for the view class to be created.
     */
    @objc public let viewClass: View.Type

    /**
     Sublayout for which size layout is being created.
     */
    @objc public let sublayout: LOKLayout?

    /**
     Layoutkit configuration block called with created `LOKView`.
     */
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
