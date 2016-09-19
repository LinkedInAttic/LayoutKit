// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit

/**
 A layout that places a divider view in the spacing between the stack's sublayouts.
 */
open class DividerStackLayout<DividerView: View, V: View>: StackLayout<V> {

    public init(stack: StackLayout<V>, dividerConfig: ((DividerView) -> Void)?) {
        let sublayouts: [Layout]
        if stack.spacing > 0 {
            var dividedSublayouts = [Layout]()
            let size = AxisSize(axis: stack.axis, axisLength: stack.spacing, crossLength: 0).size
            let divider = SizeLayout<DividerView>(size: size, alignment: .fill, flexibility: .flexible, config: dividerConfig)
            for (index, sublayout) in stack.sublayouts.enumerated() {
                dividedSublayouts.append(sublayout)
                if index != stack.sublayouts.count - 1 {
                    dividedSublayouts.append(divider)
                }
            }
            sublayouts = dividedSublayouts
        } else {
            sublayouts = stack.sublayouts
        }

        super.init(axis: stack.axis,
            spacing: 0,
            distribution: stack.distribution,
            alignment: stack.alignment,
            flexibility: stack.flexibility,
            sublayouts: sublayouts,
            config: stack.config)
    }
}
