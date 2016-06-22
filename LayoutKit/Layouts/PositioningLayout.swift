// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/**
 A base class for layouts that merely position other layouts.
 This layout does not require a UIView at runtime unless a configuration block has been provided.

 The class is public so that makeView() can conform to the public Layout protocol.
 */
public class PositioningLayout<View: UIView> {
    public let config: (View -> Void)?

    public init(config: (View -> Void)?) {
        self.config = config
    }

    public func makeView() -> UIView? {
        guard let config = config else {
            // Nothing needs to be configured, so this layout doesn't require a UIView.
            return nil
        }
        let view = View()
        config(view)
        return view
    }
}