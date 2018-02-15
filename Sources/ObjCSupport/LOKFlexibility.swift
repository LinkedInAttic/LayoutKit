// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation

@objc public class LOKFlexibility: NSObject {
    let flexibility: Flexibility

    init(flexibility: Flexibility) {
        self.flexibility = flexibility
    }

    @objc static let flexible = LOKFlexibility(flexibility: .flexible)
    @objc static let inflexible = LOKFlexibility(flexibility: .inflexible)
    @objc static let min = LOKFlexibility(flexibility: .min)
    @objc static let max = LOKFlexibility(flexibility: .max)
    @objc static let high = LOKFlexibility(flexibility: .high)
    @objc static let low = LOKFlexibility(flexibility: .low)
}
