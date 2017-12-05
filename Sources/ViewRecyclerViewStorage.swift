// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation

class ViewRecyclerViewStorage {

    private var views: [View] = []

    func add(view: View) {
        self.views.append(view)
    }

    func popView(withReuseId viewId: String) -> View? {
        let index = self.views.index { $0.viewReuseId == viewId }
        guard let viewIndex = index else { return nil }
        return self.views.remove(at: viewIndex)
    }

    func popView(withReuseGroup viewGroup: String) -> View? {
        let index = self.views.index { $0.viewReuseGroup == viewGroup }
        guard let viewIndex = index else { return nil }
        return self.views.remove(at: viewIndex)
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
