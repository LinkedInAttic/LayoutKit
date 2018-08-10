// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

/**
 An animation for a layout.
 */
@objc open class LOKAnimation: NSObject {
    private let animation: Animation

    init(animation: Animation) {
        self.animation = animation
    }

    /**
     Apply the final state of the animation.
     Call this inside a UIKit animation block.
     */
    @objc public func apply() {
        animation.apply()
    }
}
