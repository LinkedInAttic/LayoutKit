// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation

public protocol ConfigurableLayout: Layout {
    associatedtype ConfigurableView: View
    func configure(view: ConfigurableView)
}

public extension ConfigurableLayout {
    public func genericConfigure(view: View) {
        guard let view = view as? ConfigurableView else {
            return
        }
        configure(view)
    }

    public func makeConfigurableView(from recycler: ViewRecycler) -> View? {
        if needsView {
            let newOrRecycledView: ConfigurableView = recycler.makeView(viewReuseId: viewReuseId)
            return newOrRecycledView
        } else {
            return nil
        }
    }
}
