// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

@objc public class LOKLabelLayout: LOKBaseLayout {
    @objc public init(attributedString: NSAttributedString,
                      font: UIFont?,
                      lineHeight: CGFloat,
                      numberOfLines: Int,
                      alignment: LOKAlignment?,
                      flexibility: LOKFlexibility?,
                      viewReuseId: String?,
                      viewClass: UILabel.Type?,
                      configure: ((UILabel) -> Void)?) {
        let layout = LabelLayout<UILabel>(
            attributedString: attributedString,
            font: font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize),
            lineHeight: lineHeight > 0 && lineHeight.isFinite ? lineHeight : Optional<CGFloat>.none,
            numberOfLines: numberOfLines,
            alignment: alignment?.alignment ?? .topLeading,
            flexibility: flexibility?.flexibility ?? .flexible,
            viewReuseId: viewReuseId,
            viewClass: viewClass ?? UILabel.self,
            config: configure)
        super.init(layout: layout)
    }

    @objc public init(string: String,
                      font: UIFont?,
                      lineHeight: CGFloat,
                      numberOfLines: Int,
                      alignment: LOKAlignment?,
                      flexibility: LOKFlexibility?,
                      viewReuseId: String?,
                      viewClass: UILabel.Type?,
                      configure: ((UILabel) -> Void)?) {
        let layout = LabelLayout<UILabel>(
            string: string,
            font: font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize),
            lineHeight: lineHeight > 0 && lineHeight.isFinite ? lineHeight : Optional<CGFloat>.none,
            numberOfLines: numberOfLines,
            alignment: alignment?.alignment ?? .topLeading,
            flexibility: flexibility?.flexibility ?? .flexible,
            viewReuseId: viewReuseId,
            viewClass: viewClass ?? UILabel.self,
            config: configure)
        super.init(layout: layout)
    }
}
