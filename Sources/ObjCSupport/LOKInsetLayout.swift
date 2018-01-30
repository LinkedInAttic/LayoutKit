// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

@objc public class LOKInsetLayout: LOKBaseLayout {
    @objc public required init(insets: EdgeInsets,
                               alignment: LOKAlignment? = nil,
                               viewReuseId: String? = nil,
                               viewClass: View.Type? = nil,
                               sublayout: LOKLayout,
                               configure: ((View) -> Void)? = nil) {
        let layout = InsetLayout(
            insets: insets,
            alignment: alignment?.alignment ?? .fill,
            viewReuseId: viewReuseId,
            sublayout: sublayout.unwrapped,
            viewClass: viewClass ?? View.self,
            config: configure)
        super.init(layout: layout)
    }

    @objc public class func inset(by insets: EdgeInsets, sublayout: LOKLayout) -> LOKInsetLayout {
        return LOKInsetLayout(insets: insets, sublayout: sublayout)
    }
}
