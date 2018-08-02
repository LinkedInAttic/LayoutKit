// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

class WrappedLayout: LOKLayout {
    func arrangement(within rect: CGRect, measurement: LOKLayoutMeasurement) -> LOKLayoutArrangement {
        let a = layout.arrangement(
            within: rect,
            measurement: measurement.measurement)
        return LOKLayoutArrangement(layoutArrangement: a)
    }

    func measurement(within maxSize: CGSize) -> LOKLayoutMeasurement {
        return LOKLayoutMeasurement(layoutMeasurement: layout.measurement(within: maxSize))
    }

    var needsView: Bool {
        return layout.needsView
    }

    func makeView() -> View {
        return layout.makeView()
    }

    func configureView(_ view: View) {
        layout.configure(baseTypeView: view)
    }

    var flexibility: LOKFlexibility {
        return LOKFlexibility(flexibility: layout.flexibility)
    }

    var viewReuseId: String? {
        return layout.viewReuseId
    }

    let layout: Layout
    private init(layout: Layout) {
        self.layout = layout
    }

    static func wrap(layout: Layout) -> LOKLayout {
        if let reverseWrappedLayout = layout as? ReverseWrappedLayout {
            return reverseWrappedLayout.layout
        } else {
            return WrappedLayout(layout: layout)
        }
    }
}
