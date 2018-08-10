// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation

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
@objc open class LOKFlexibility: NSObject {
    let flexibility: Flexibility

    init(flexibility: Flexibility) {
        self.flexibility = flexibility
    }

    /**
     The flexible flex value.
     */
    @objc public static let flexible = LOKFlexibility(flexibility: .flexible)

    /**
     The inflexible flex value.
     */
    @objc public static let inflexible = LOKFlexibility(flexibility: .inflexible)

    /**
     The minimum flex value that is still flexible.
     */
    @objc public static let min = LOKFlexibility(flexibility: .min)

    /**
     The maximum flex value.
     */
    @objc public static let max = LOKFlexibility(flexibility: .max)

    /**
     More flexible than the default flexibility.
     */
    @objc public static let high = LOKFlexibility(flexibility: .high)

    /**
     Less flexible than the default flexibility.
     */
    @objc public static let low = LOKFlexibility(flexibility: .low)

    @objc public static let horizontallyHighlyFlexible = LOKFlexibility(flexibility: Flexibility(horizontal: Flexibility.highFlex, vertical: Flexibility.inflexibleFlex))
    @objc public static let horizontallyFlexible = LOKFlexibility(flexibility: Flexibility(horizontal: Flexibility.defaultFlex, vertical: Flexibility.inflexibleFlex))
    @objc public static let verticallyFlexible = LOKFlexibility(flexibility: Flexibility(horizontal: Flexibility.inflexibleFlex, vertical: Flexibility.defaultFlex))
}
