// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.


/// An animation for a layout.
public struct Animation {

    let arrangement: LayoutArrangement
    let rootView: View
    let direction: UserInterfaceLayoutDirection

    /// Apply the final state of the animation.
    /// Call this inside a UIKit animation block.
    public func apply() {
        arrangement.makeViews(in: rootView, direction: direction)
    }
}

