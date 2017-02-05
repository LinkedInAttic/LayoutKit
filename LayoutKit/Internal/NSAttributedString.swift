// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

extension NSAttributedString {

    /// Create an `NSAttributedString` and add specified font to it
    func createAttrbutedString(with font: UIFont) -> NSAttributedString {
        if length == 0 {
            return self
        }

        // UILabel/UITextView uses a default font if one is not specified in the attributed string.
        // boundingRectWithSize does not appear to have the same logic,
        // so we need to ensure that our attributed string has a default font.
        // We do this by creating a new attributed string with the default font and then
        // applying all of the attributes from the provided attributed string.
        let fontAttribute = [NSFontAttributeName: font]
        let attributedTextWithFont = NSMutableAttributedString(string: string, attributes: fontAttribute)
        let fullRange = NSMakeRange(0, (string as NSString).length)
        attributedTextWithFont.beginEditing()
        self.enumerateAttributes(in: fullRange, options: .longestEffectiveRangeNotRequired, using: { (attributes, range, _) in
            attributedTextWithFont.addAttributes(attributes, range: range)
        })
        attributedTextWithFont.endEditing()

        return attributedTextWithFont
    }

}
