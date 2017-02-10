// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/// DO NOT move this file to `Text.swift`
/// because this extension is using `UIKit` and serves for
/// `LabelLayout` and `TextLayout`
extension Text {

    /// Calculate the text size within `maxSize` by given `UIFont`
    func textSize(within maxSize: CGSize,
                  font: UIFont,
                  isHeightMeasuredForEmptyText: Bool = false) -> CGSize {
        let options: NSStringDrawingOptions = [
            .usesLineFragmentOrigin
        ]

        let size: CGSize
        switch self {
        case .attributed(let attributedText):
            if attributedText.length == 0 {
                return isHeightMeasuredForEmptyText
                    ? textSizeWithEmptyText(within: maxSize, font: font)
                    : .zero
            }

            // UILabel/UITextView uses a default font if one is not specified in the attributed string.
            // boundingRectWithSize does not appear to have the same logic,
            // so we need to ensure that our attributed string has a default font.
            // We do this by creating a new attributed string with the default font and then
            // applying all of the attributes from the provided attributed string.
            let fontAppliedAttributeString = attributedText.with(
                defaultFont: font)

            size = fontAppliedAttributeString.boundingRect(with: maxSize, options: options, context: nil).size
        case .unattributed(let text):
            if text.isEmpty {
                return isHeightMeasuredForEmptyText
                    ? textSizeWithEmptyText(within: maxSize, font: font, isAttributedText: true)
                    : .zero
            }
            size = text.boundingRect(with: maxSize, options: options, attributes: [NSFontAttributeName: font], context: nil).size
        }
        // boundingRectWithSize returns size to a precision of hundredths of a point,
        // but UILabel only returns sizes with a point precision of 1/screenDensity.
        return CGSize(width: size.width.roundedUpToFractionalPoint, height: size.height.roundedUpToFractionalPoint)
    }

    /// By the default behavior of `UITextView`, it will give a height for a empty text
    /// For the measurement, we can measure a space string to match the default behavior
    private func textSizeWithEmptyText(within maxSize: CGSize,
                                       font: UIFont,
                                       isAttributedText: Bool = false) -> CGSize {
        let emptyString = " "
        let attributedFont = TextViewDefaultFontMeasurement.sharedInstance.attributedTextFontWithEmptyString

        let size: CGSize
        switch self {
        // For the attrbuted string, it used the `UITextView` default font
        case .attributed(_):
            let text = Text.attributed(NSAttributedString(
                string: emptyString,
                attributes: [NSFontAttributeName: attributedFont]))
            size = text.textSize(within: maxSize, font: attributedFont)

        // For the unattributed string, it used the custom font
        case .unattributed(_):
            let text = Text.unattributed(emptyString)
            size = text.textSize(within: maxSize, font: font)
        }

        return CGSize(width: 0, height: size.height)
    }

}
