// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

open class LOKBaseLayout: NSObject, LOKLayout {
    let layout: Layout

    init(layout: Layout) {
        self.layout = layout
    }

    public func measurement(within maxSize: CGSize) -> LOKLayoutMeasurement {
        return LOKLayoutMeasurement(wrappedLayout: self, layoutMeasurement: layout.measurement(within: maxSize))
    }

    public func arrangement(within rect: CGRect, measurement: LOKLayoutMeasurement) -> LOKLayoutArrangement {
        return LOKLayoutArrangement(layoutArrangement: layout.arrangement(within: rect, measurement: measurement.measurement))
    }

    public var needsView: Bool {
        return layout.needsView
    }

    public func makeView() -> View {
        return layout.makeView()
    }

    public func configure(baseTypeView: View) {
        layout.configure(baseTypeView: baseTypeView)
    }

    public var flexibility: LOKFlexibility {
        return LOKFlexibility(flexibility: layout.flexibility)
    }

    public var viewReuseId: String? {
        return layout.viewReuseId
    }
}
