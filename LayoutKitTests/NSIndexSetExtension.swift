// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation

extension NSIndexSet {
    /// Returns the only index in the set.
    /// It returns nil if there is not exactly one index in the set.
    public var only: Int? {
        if count == 1 {
            return firstIndex
        }
        return nil
    }
}