// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit

/**
 An image stacked on top of a label.
 */
class LabeledImageLayout: StackLayout<UIView> {

    init(imageUrl: URL, imageSize: CGSize, labelText: String) {
        let image = UrlImageLayout(url: imageUrl, size: imageSize)
        let label = LabelLayout(text: labelText, alignment: Alignment(vertical: .top, horizontal: .center))
        super.init(
            axis: .vertical,
            spacing: 8,
            distribution: .leading,
            alignment: .fill,
            sublayouts: [image, label]
        )
    }
}
