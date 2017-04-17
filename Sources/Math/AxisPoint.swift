// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

/// A wrapper around CGPoint that makes it easy to do math relative to an axis.
public struct AxisPoint {
    public let axis: Axis
    public var point: CGPoint

    public var axisOffset: CGFloat {
        set {
            switch axis {
            case .horizontal:
                point.x = newValue
            case .vertical:
                point.y = newValue
            }
        }
        get {
            switch axis {
            case .horizontal:
                return point.x
            case .vertical:
                return point.y
            }
        }
    }

    public var crossOffset: CGFloat {
        set {
            switch axis {
            case .horizontal:
                point.y = newValue
            case .vertical:
                point.x = newValue
            }
        }
        get {
            switch axis {
            case .horizontal:
                return point.y
            case .vertical:
                return point.x
            }
        }
    }

    public init(axis: Axis, point: CGPoint) {
        self.axis = axis
        self.point = point
    }

    public init(axis: Axis, axisOffset: CGFloat, crossOffset: CGFloat) {
        self.axis = axis
        switch axis {
        case .horizontal:
            self.point = CGPoint(x: axisOffset, y: crossOffset)
        case .vertical:
            self.point = CGPoint(x: crossOffset, y: axisOffset)
        }
    }
}