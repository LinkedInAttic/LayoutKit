// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation

@objc open class LOKOverlayLayout: LOKBaseLayout {
    @objc public let primaryLayouts: [LOKLayout]
    @objc public let backgroundLayouts: [LOKLayout]
    @objc public let overlayLayouts: [LOKLayout]
    @objc public let alignment: LOKAlignment
    @objc public let viewClass: View.Type
    @objc public let configure: ((View) -> Void)?

    @objc public init(primaryLayouts: [LOKLayout],
                      backgroundLayouts: [LOKLayout]? = nil,
                      overlayLayouts: [LOKLayout]? = nil,
                      alignment: LOKAlignment? = nil,
                      flexibility: LOKFlexibility? = nil,
                      viewReuseId: String? = nil,
                      viewClass: View.Type? = nil,
                      configure: ((View) -> Void)? = nil) {
        self.primaryLayouts = primaryLayouts
        self.backgroundLayouts = backgroundLayouts ?? []
        self.overlayLayouts = overlayLayouts ?? []
        self.alignment = alignment ?? .fill
        self.viewClass = viewClass ?? View.self
        self.configure = configure
        super.init(layout: OverlayLayout(
            primaryLayouts: primaryLayouts.map { $0.unwrapped },
            backgroundLayouts: backgroundLayouts?.map { $0.unwrapped } ?? [],
            overlayLayouts: overlayLayouts?.map { $0.unwrapped } ?? [],
            alignment: self.alignment.alignment,
            flexibility: flexibility?.flexibility ?? primaryLayouts.first?.flexibility.flexibility ?? .flexible,
            viewReuseId: viewReuseId,
            viewClass: self.viewClass,
            config: self.configure))
    }
}
