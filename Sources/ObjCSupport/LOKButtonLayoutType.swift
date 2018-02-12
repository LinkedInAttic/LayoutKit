// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation

@objc public enum LOKButtonLayoutType: Int {
    case custom
    case system
    case detailDisclosure
    case infoLight
    case infoDark
    case contactAdd

    var unwrapped: ButtonLayoutType {
        switch self {
        case .custom:
            return .custom
        case .system:
            return .system
        case .detailDisclosure:
            return .detailDisclosure
        case .infoLight:
            return .infoLight
        case .infoDark:
            return .infoDark
        case .contactAdd:
            return .contactAdd
        }
    }
}
