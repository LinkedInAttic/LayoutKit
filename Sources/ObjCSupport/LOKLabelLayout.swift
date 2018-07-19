// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

@objc open class LOKLabelLayout: LOKBaseLayout {
    @objc public let attributedString: NSAttributedString?
    @objc public let string: String?
    @objc public let lineHeight: CGFloat
    @objc public let font: UIFont
    @objc public let numberOfLines: Int
    @objc public let alignment: LOKAlignment
    @objc public let viewClass: UILabel.Type
    @objc public let configure: ((UILabel) -> Void)?

    @objc public init(attributedString: NSAttributedString,
                      font: UIFont?,
                      lineHeight: CGFloat,
                      numberOfLines: Int,
                      alignment: LOKAlignment?,
                      flexibility: LOKFlexibility?,
                      viewReuseId: String?,
                      viewClass: UILabel.Type?,
                      configure: ((UILabel) -> Void)?) {
        self.attributedString = attributedString
        self.font = font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        self.lineHeight = lineHeight
        self.numberOfLines = numberOfLines
        self.alignment = alignment ?? .topLeading
        self.viewClass = viewClass ?? UILabel.self
        self.configure = configure
        string = nil
        let layout = LabelLayout<UILabel>(
            attributedString: attributedString,
            font: self.font,
            lineHeight: lineHeight > 0 && lineHeight.isFinite ? lineHeight : Optional<CGFloat>.none,
            numberOfLines: self.numberOfLines,
            alignment: self.alignment.alignment,
            flexibility: flexibility?.flexibility ?? .flexible,
            viewReuseId: viewReuseId,
            viewClass: self.viewClass,
            config: self.configure)

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
        self.string = string
        self.font = font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        self.lineHeight = lineHeight
        self.numberOfLines = numberOfLines
        self.alignment = alignment ?? .topLeading
        self.viewClass = viewClass ?? UILabel.self
        self.configure = configure
        attributedString = nil
        let layout = LabelLayout<UILabel>(
            string: string,
            font: self.font,
            lineHeight: lineHeight > 0 && lineHeight.isFinite ? lineHeight : Optional<CGFloat>.none,
            numberOfLines: self.numberOfLines,
            alignment: self.alignment.alignment,
            flexibility: flexibility?.flexibility ?? .flexible,
            viewReuseId: viewReuseId,
            viewClass: self.viewClass,
            config: self.configure)
        super.init(layout: layout)
    }
}
