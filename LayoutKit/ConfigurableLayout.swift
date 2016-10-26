// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation

/**
 Convenient optional protocol for layout implementations to use instead of `Layout`.

 It requires a more typesafe `configure(view:)` method that is used to implement
 `configure(baseViewType:)` in the Layout protocol.
 */
public protocol ConfigurableLayout: Layout {

    /**
     The class of view that should be created for this layout, if it needs a view.
     This is specified by the conforming class via its implementation of `configure(view:)`.
     */
    associatedtype ConfigurableView: View

    /**
     Configures the given view.

     When implementing this method, use the specific concrete type for ConfigurableView.

     Example:

         class LabelLayout {
             func configure(view label: UILabel) {
                 label.text = "example"
             }
         }

     MUST be run on the main thread.
     */
    func configure(view: ConfigurableView)
}

// Implement `configure(baseViewType:)` from `Layout`.
public extension ConfigurableLayout {
    public func configure(baseTypeView: View) {
        guard let view = baseTypeView as? ConfigurableView else {
            assertionFailure("Expected baseTypeView \(baseTypeView) to be of type \(ConfigurableView.self) but it was of type \(type(of: baseTypeView))")
            return
        }
        configure(view: view)
    }
}
