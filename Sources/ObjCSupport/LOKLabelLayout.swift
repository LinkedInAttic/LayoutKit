// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/**
 Layout for a `UILabel`.
 */
@objc open class LOKLabelLayout: LOKBaseLayout {

    /**
     Attributed string to display as the label.
     */
    @objc public let attributedString: NSAttributedString?

    /**
     String to display as the label.
     */
    @objc public let string: String?

    /**
     Line height for label.
     */
    @objc public let lineHeight: CGFloat

    /**
     Font for label.
     */
    @objc public let font: UIFont

    /**
     Line break mode for label.
     */
    @objc public let lineBreakMode: NSLineBreakMode

    /**
     Number of lines the label can have.
     */
    @objc public let numberOfLines: Int

    /**
     Specifies how this layout is positioned inside its parent layout
     */
    @objc public let alignment: LOKAlignment

    /**
     Class object for the created view. Should be a subclass of `UILabel`.
     */
    @objc public let viewClass: UILabel.Type

    /**
     Layoutkit configuration block called with created `UIButton`.
     */
    @objc public let configure: ((UILabel) -> Void)?

    @objc public init(attributedString: NSAttributedString,
                      font: UIFont?,
                      lineBreakMode: NSLineBreakMode,
                      lineHeight: CGFloat,
                      numberOfLines: Int,
                      alignment: LOKAlignment?,
                      flexibility: LOKFlexibility?,
                      viewReuseId: String?,
                      viewClass: UILabel.Type?,
                      configure: ((UILabel) -> Void)?) {
        self.attributedString = attributedString
        self.font = font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        self.lineBreakMode = lineBreakMode
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
            lineBreakMode: self.lineBreakMode,
            alignment: self.alignment.alignment,
            flexibility: flexibility?.flexibility ?? .flexible,
            viewReuseId: viewReuseId,
            viewClass: self.viewClass,
            config: self.configure)

        super.init(layout: layout)
    }

    @objc public init(string: String,
                      font: UIFont?,
                      lineBreakMode: NSLineBreakMode,
                      lineHeight: CGFloat,
                      numberOfLines: Int,
                      alignment: LOKAlignment?,
                      flexibility: LOKFlexibility?,
                      viewReuseId: String?,
                      viewClass: UILabel.Type?,
                      configure: ((UILabel) -> Void)?) {
        self.string = string
        self.font = font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        self.lineBreakMode = lineBreakMode
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
            lineBreakMode: self.lineBreakMode,
            alignment: self.alignment.alignment,
            flexibility: flexibility?.flexibility ?? .flexible,
            viewReuseId: viewReuseId,
            viewClass: self.viewClass,
            config: self.configure)
        super.init(layout: layout)
    }
}
