// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

class ReverseWrappedLayout: Layout {
    func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        let a = layout.arrangement(within: rect, measurement: LOKLayoutMeasurement(wrappedLayout: layout, layoutMeasurement: measurement))
        return a.layoutArrangement
    }

    func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        let m = layout.measurement(within: maxSize)
        return LayoutMeasurement(layout: self, size: m.size, maxSize: m.maxSize, sublayouts: m.sublayouts.map { $0.measurement })
    }

    var needsView: Bool {
        return layout.needsView
    }

    func makeView() -> View {
        return layout.makeView()
    }

    func configure(baseTypeView: View) {
        layout.configure(baseTypeView: baseTypeView)
    }

    var flexibility: Flexibility {
        return Flexibility.inflexible // TODO
    }

    var viewReuseId: String? {
        return layout.viewReuseId
    }

    private let layout: LOKLayout
    init(layout: LOKLayout) {
        self.layout = layout
    }
}
