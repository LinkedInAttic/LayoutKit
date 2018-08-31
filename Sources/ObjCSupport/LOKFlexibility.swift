// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation

@objc open class LOKFlexibility: NSObject {
    let flexibility: Flexibility

    init(flexibility: Flexibility) {
        self.flexibility = flexibility
    }

    @objc public static let flexible = LOKFlexibility(flexibility: .flexible)
    @objc public static let inflexible = LOKFlexibility(flexibility: .inflexible)
    @objc public static let min = LOKFlexibility(flexibility: .min)
    @objc public static let max = LOKFlexibility(flexibility: .max)
    @objc public static let high = LOKFlexibility(flexibility: .high)
    @objc public static let low = LOKFlexibility(flexibility: .low)

    @objc public static let horizontallyHighlyFlexible = LOKFlexibility(flexibility: Flexibility(horizontal: Flexibility.highFlex, vertical: Flexibility.inflexibleFlex))
    @objc public static let horizontallyFlexible = LOKFlexibility(flexibility: Flexibility(horizontal: Flexibility.defaultFlex, vertical: Flexibility.inflexibleFlex))
    @objc public static let verticallyFlexible = LOKFlexibility(flexibility: Flexibility(horizontal: Flexibility.inflexibleFlex, vertical: Flexibility.defaultFlex))
}
