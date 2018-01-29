// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

@objc public class LOKLabelLayout: LOKBaseLayout {
    @objc public init(attributedText: NSAttributedString,
                      font: UIFont,
                      numberOfLines: Int,
                      alignment: LOKAlignment,
                      flexibility: LOKFlexibility,
                      viewReuseId: String?,
                      viewClass: UILabel.Type?,
                      configure: ((UILabel) -> Void)?) {
        let layout = LabelLayout<UILabel>(
            attributedText: attributedText,
            font: font,
            numberOfLines: numberOfLines,
            alignment: alignment.alignment,
            flexibility: flexibility.flexibility,
            viewReuseId: viewReuseId,
            viewClass: viewClass ?? UILabel.self,
            config: configure)
        super.init(layout: layout)
    }
}
