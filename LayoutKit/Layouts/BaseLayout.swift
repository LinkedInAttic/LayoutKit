// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.


/**
 A base class for layouts.
 This layout does not require a view at runtime unless a configuration block has been provided.

 The class is public so that makeView() can conform to the public Layout protocol.
 */
public class BaseLayout<V: View> {

    /// The layout's alignment inside of the rect that it is assigned during arrangement.
    public let alignment: Alignment

    /// The flexibility of the layout along both dimensions.
    public let flexibility: Flexibility

    /// An identifier for the layout.
    /// It is used to identify which views should be reused when animating from one layout to another.
    public let viewReuseId: String?

    /// A configuration block that is run on the main thread after the view is created.
    public let config: (V -> Void)?

    public var needsView: Bool {
        return viewReuseId != nil || config != nil
    }

    public init(alignment: Alignment, flexibility: Flexibility, viewReuseId: String? = nil, config: (V -> Void)?) {
        self.alignment = alignment
        self.flexibility = flexibility
        self.viewReuseId = viewReuseId
        self.config = config
    }

    public func configure(view view: V) {
        config?(view)
    }
}
