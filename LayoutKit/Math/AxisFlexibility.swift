// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.


/// A wrapper around Flexibility that makes it easy to do math relative to an axis.
public struct AxisFlexibility {
    public let axis: Axis
    public let flexibility: Flexibility

    public var axisFlex: Flexibility.Flex {
        get {
            switch axis {
            case .horizontal:
                return flexibility.horizontal
            case .vertical:
                return flexibility.vertical
            }
        }
    }

    public var crossFlex: Flexibility.Flex {
        get {
            switch axis {
            case .horizontal:
                return flexibility.vertical
            case .vertical:
                return flexibility.horizontal
            }
        }
    }

    public init(axis: Axis, flexibility: Flexibility) {
        self.axis = axis
        self.flexibility = flexibility
    }

    public init(axis: Axis, axisFlex: Flexibility.Flex, crossFlex: Flexibility.Flex) {
        self.axis = axis
        switch axis {
        case .horizontal:
            self.flexibility = Flexibility(horizontal: axisFlex, vertical: crossFlex)
        case .vertical:
            self.flexibility = Flexibility(horizontal: crossFlex, vertical: axisFlex)
        }
    }
}