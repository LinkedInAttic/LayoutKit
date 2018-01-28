// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

@objc public protocol LOKLayout {
    @objc func measurement(within maxSize: CGSize) -> LOKLayoutMeasurement
    @objc func arrangement(within rect: CGRect, measurement: LOKLayoutMeasurement) -> LOKLayoutArrangement
    @objc var needsView: Bool { get }
    @objc func makeView() -> View
    @objc func configure(baseTypeView: View)
    @objc var flexibility: LOKFlexibility { get }
    @objc var viewReuseId: String? { get }
}

extension LOKLayout {
    var unwrapped: Layout {
        return (self as? WrappedLayout)?.layout ?? ReverseWrappedLayout(layout: self)
    }
}
