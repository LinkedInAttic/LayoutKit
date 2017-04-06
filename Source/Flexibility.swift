// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.


/**
 The flexibility of a layout along both dimensions.
 
 Flexibility is a hint to a layout's parent about how the parent should prioritize space allocation among its children
 when there is either insufficient or too much space.
 
 A layout MAY use the flexibility of its sublayouts to determine how to allocate its available space between those sublayouts.
 A layout SHOULD NOT ever need to inspect its own flexiblity.

 A parent layout MAY compress ANY sublayout (even sublayouts that are configured as inflexible) if there is insufficient space.
 A parent layout MAY expand any flexible sublayout if there is excess space and if the parent layout wants to fill that space.
 A parent layout SHOULD favor expanding/compressing more flexible sublayouts over less flexible sublayouts.
 A parent layout SHOULD NOT expand inflexible sublayouts.
 */
public struct Flexibility {
    /**
     A measure of flexibility. Larger is more flexible.
     
     nil means inflexible.
     
     Flex is an Int32 so that its range doesn't depend on the architecture.
     */
    public typealias Flex = Int32?

    /**
     The inflexible flex value.
     */
    public static let inflexibleFlex: Flex = nil

    /**
     The default flex value.
     */
    public static let defaultFlex: Flex = 0

    /**
     The maximum flex value.
     */
    public static let maxFlex: Flex = Int32.max

    /**
     The minimum flex value that is still flexible.
     */
    public static let minFlex: Flex = Int32.min

    /**
     A flex value that is higer than the default.
     It is the midpoint between the default flex value and the maximum flex value.
     */
    public static let highFlex: Flex = Int32.max / 2

    /**
     A flex value that is lower than the default.
     It is the midpoint between the default flex value and the minimum flex value.
     */
    public static let lowFlex: Flex = Int32.min / 2

    /**
     Not flexible, even if there is excess space.
     Even inflexible layouts MAY be compressed when there is insufficient space.
     */
    public static let inflexible = Flexibility(horizontal: inflexibleFlex, vertical: inflexibleFlex)

    /**
     The default flexibility.
     */
    public static let flexible = Flexibility(horizontal: defaultFlex, vertical: defaultFlex)

    /**
     More flexible than the default flexibility.
     */
    public static let high = Flexibility(horizontal: highFlex, vertical: highFlex)

    /**
     Less flexible than the default flexibility.
     */
    public static let low = Flexibility(horizontal: lowFlex, vertical: lowFlex)

    /**
     The minimum flexibility that is still flexible.
     */
    public static let min = Flexibility(horizontal: minFlex, vertical: minFlex)

    /**
     The maximum flexibility.
     */
    public static let max = Flexibility(horizontal: maxFlex, vertical: maxFlex)

    public let vertical: Flex
    public let horizontal: Flex

    public init(horizontal: Flex, vertical: Flex) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    /**
     Returns the flex along an axis.
     */
    public func flex(_ axis: Axis) -> Flex {
        switch axis {
        case .vertical:
            return vertical
        case .horizontal:
            return horizontal
        }
    }

    public static func max(_ left: Flex, _ right: Flex) -> Flex {
        guard let left = left else {
            return right
        }
        guard let right = right else {
            return left
        }
        return Swift.max(left, right)
    }

    public static func min(_ left: Flex, _ right: Flex) -> Flex {
        guard let left = left, let right = right else {
            // One of them is inflexible so return nil flex (inflexible)
            return nil
        }
        return Swift.min(left, right)
    }
}
