// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation

@objc open class LOKOverlayLayout: LOKBaseLayout {
    @objc public let primary: LOKLayout
    @objc public let background: [LOKLayout]
    @objc public let overlay: [LOKLayout]
    @objc public let alignment: LOKAlignment
    @objc public let viewClass: View.Type
    @objc public let configure: ((View) -> Void)?

    @objc public init(primary: LOKLayout,
                      background: [LOKLayout]? = nil,
                      overlay: [LOKLayout]? = nil,
                      alignment: LOKAlignment? = nil,
                      viewReuseId: String? = nil,
                      viewClass: View.Type? = nil,
                      configure: ((View) -> Void)? = nil) {
        self.primary = primary
        self.background = background ?? []
        self.overlay = overlay ?? []
        self.alignment = alignment ?? .fill
        self.viewClass = viewClass ?? View.self
        self.configure = configure
        super.init(layout: OverlayLayout(
            primary: self.primary.unwrapped,
            background: self.background.map { $0.unwrapped },
            overlay: self.overlay.map { $0.unwrapped },
            alignment: self.alignment.alignment,
            viewReuseId: viewReuseId,
            viewClass: self.viewClass,
            config: self.configure))
    }
}
