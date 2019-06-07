// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

extension NSAttributedString {

    /// Returns a new NSAttributedString with a given font and the same attributes.
    func with(font: UIFont) -> NSAttributedString {
        return with(additionalAttributes: [NSAttributedString.Key.font: font])
    }

    /// Returns a new NSAttributedString with previous as well as additional attributes.
    func with(additionalAttributes: [NSAttributedString.Key : Any]?) -> NSAttributedString {
        let attributedTextWithAdditionalAttributes = NSMutableAttributedString(string: string, attributes: additionalAttributes)
        let fullRange = NSMakeRange(0, (string as NSString).length)
        attributedTextWithAdditionalAttributes.beginEditing()
        self.enumerateAttributes(in: fullRange, options: .longestEffectiveRangeNotRequired, using: { (attributes, range, _) in
            attributedTextWithAdditionalAttributes.addAttributes(attributes, range: range)
        })
        attributedTextWithAdditionalAttributes.endEditing()
        return attributedTextWithAdditionalAttributes
    }
}
