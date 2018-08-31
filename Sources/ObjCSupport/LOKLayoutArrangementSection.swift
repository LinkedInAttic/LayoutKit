// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation

@objc open class LOKLayoutArrangementSection: NSObject {
    let unwrapped: Section<[LayoutArrangement]>
    @objc public let header: LOKLayoutArrangement?
    @objc public let items: [LOKLayoutArrangement]
    @objc public let footer: LOKLayoutArrangement?
    @objc public init(header: LOKLayoutArrangement?, items: [LOKLayoutArrangement], footer: LOKLayoutArrangement?) {
        self.header = header
        self.items = items
        self.footer = footer
        unwrapped = Section(header: header?.layoutArrangement, items: items.map { $0.layoutArrangement }, footer: footer?.layoutArrangement)
    }
}
