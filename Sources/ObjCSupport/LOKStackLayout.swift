// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

@objc public class LOKLayoutParameters: NSObject {
    @objc public init(alignment: LOKAlignment) {

    }
}

@objc public class LOKStackLayout: LOKBaseLayout {
    @objc public init(axis: Axis, spacing: CGFloat, parameters: LOKLayoutParameters, sublayouts: [LOKLayout], config: ((View) -> Void)? = nil) {
        super.init(layout: StackLayout(axis: axis, sublayouts: sublayouts.map { $0.unwrapped }))
    }
}
