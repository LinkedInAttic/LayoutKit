// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation

final class ViewRecyclerViewStorage {

    private var views: [View] = []

    func add(view: View) {
        self.views.insert(view, at: 0)
    }

    func popView(withReuseId viewId: String) -> View? {
        guard let index = self.views.index(where: { $0.viewReuseId == viewId }) else {
            return nil
        }
        return self.views.remove(at: index)
    }

    func popView(withReuseGroup viewGroup: String) -> View? {

        guard let index = self.views.index(where: { $0.viewReuseGroup == viewGroup }) else {
            return nil
        }
        return self.views.remove(at: index)
    }

    func foreach(_ closure: (View) -> Void) {
        self.views.forEach(closure)
    }

    func remove(view: View) {
        if let index = self.views.index(where: { $0 == view }) {
            self.views.remove(at: index)
        }
    }

    func removeAll() {
        self.views.removeAll()
    }
}

extension ViewRecyclerViewStorage : CustomDebugStringConvertible {

    var debugDescription: String {
        return "\(type(of: self)) - \(self.views)"
    }
}
