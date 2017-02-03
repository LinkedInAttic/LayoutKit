// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

enum TextCalculatorHelper {

    /// Calculate the text size within `maxSize` by given `Text`, `UIFont`, and `numberOfLines`.
    /// `numberOfLines` is an optional or make it 0 if dynamic number of lines is requied
    static func textSize(_ maxSize: CGSize,
                         _ text: Text,
                         _ font: UIFont) -> CGSize {
        let options: NSStringDrawingOptions = [
            .usesLineFragmentOrigin
        ]

        var size: CGSize
        switch text {
        case .attributed(let attributedText):
            if attributedText.length == 0 {
                return .zero
            }

            // UILabel/UITextView uses a default font if one is not specified in the attributed string.
            // boundingRectWithSize does not appear to have the same logic,
            // so we need to ensure that our attributed string has a default font.
            // We do this by creating a new attributed string with the default font and then
            // applying all of the attributes from the provided attributed string.
            let fontAttribute = [NSFontAttributeName: font]
            let attributedTextWithFont = NSMutableAttributedString(string: attributedText.string, attributes: fontAttribute)
            let fullRange = NSMakeRange(0, (attributedText.string as NSString).length)
            attributedTextWithFont.beginEditing()
            attributedText.enumerateAttributes(in: fullRange, options: .longestEffectiveRangeNotRequired, using: { (attributes, range, _) in
                attributedTextWithFont.addAttributes(attributes, range: range)
            })
            attributedTextWithFont.endEditing()

            size = attributedTextWithFont.boundingRect(with: maxSize, options: options, context: nil).size
        case .unattributed(let text):
            if text.isEmpty {
                return .zero
            }
            size = text.boundingRect(with: maxSize, options: options, attributes: [NSFontAttributeName: font], context: nil).size
        }
        // boundingRectWithSize returns size to a precision of hundredths of a point,
        // but UILabel only returns sizes with a point precision of 1/screenDensity.
        size.height = size.height.roundedUpToFractionalPoint
        size.width = size.width.roundedUpToFractionalPoint
        
        return size
    }
}
