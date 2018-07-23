// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

@objc open class LOKSizeLayout: LOKBaseLayout {
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
        let layout = SizeLayout(
            minWidth: minWidth,
            maxWidth: maxWidth.isFinite ? maxWidth : nil,
            minHeight: minHeight,
            maxHeight: maxHeight.isFinite ? maxHeight : nil,
            alignment: alignment?.alignment,
            flexibility: flexibility?.flexibility,
            viewReuseId: viewReuseId,
            viewClass: viewClass,
            sublayout: sublayout?.unwrapped,
            config: configure)
        super.init(layout: layout)
    }
}
