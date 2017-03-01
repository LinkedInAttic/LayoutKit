// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

extension NSAttributedString {

    /// Returns a new NSAttributedString with a default font and the same attributes.
    func with(defaultFont: UIFont?) -> NSAttributedString {
        guard let font = defaultFont else {
            return self
        }

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
