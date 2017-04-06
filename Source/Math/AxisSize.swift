// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

/// A wrapper around CGSize that makes it easy to do math relative to an axis.
public struct AxisSize {
    public let axis: Axis
    public var size: CGSize

    public var axisLength: CGFloat {
        set {
            switch axis {
            case .horizontal:
                size.width = newValue
            case .vertical:
                size.height = newValue
            }
        }
        get {
            switch axis {
            case .horizontal:
                return size.width
            case .vertical:
                return size.height
            }
        }
    }

    public var crossLength: CGFloat {
        set {
            switch axis {
            case .horizontal:
                size.height = newValue
            case .vertical:
                size.width = newValue
            }
        }
        get {
            switch axis {
            case .horizontal:
                return size.height
            case .vertical:
                return size.width
            }
        }
    }

    public init(axis: Axis, size: CGSize) {
        self.axis = axis
        self.size = size
    }

    public init(axis: Axis, axisLength: CGFloat, crossLength: CGFloat) {
        self.axis = axis
        switch axis {
        case .horizontal:
            self.size = CGSize(width: axisLength, height: crossLength)
        case .vertical:
            self.size = CGSize(width: crossLength, height: axisLength)
        }
    }
}