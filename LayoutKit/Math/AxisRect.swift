// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

/// A wrapper around CGRect that makes it easy to do math relative to an axis.
public struct AxisRect {
    public let axis: Axis
    public let origin: AxisPoint
    public let size: AxisSize

    public var axisMax: CGFloat {
        return origin.axisOffset + size.axisLength
    }

    public var crossMax: CGFloat {
        return origin.crossOffset + size.crossLength
    }

    public init(axis: Axis, rect: CGRect) {
        self.axis = axis
        self.origin = AxisPoint(axis: axis, point: rect.origin)
        self.size = AxisSize(axis: axis, size: rect.size)
    }
}