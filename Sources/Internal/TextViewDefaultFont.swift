// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/// This class provides default UITextView font
enum TextViewDefaultFont {

    // The font used by UITextView for unattributed strings
    static let unattributedTextFont: UIFont = {
        #if os(tvOS)
            return UIFont.systemFont(ofSize: 38, weight: UIFont.Weight.medium)
        #else
            return helveticaFont(ofSize: 12)
        #endif
    }()

    // The font used by UITextView for attributed strings
    static let attributedTextFont = helveticaFont(ofSize: 12)

    // The font used by UITextView for empty attributed strings
    static let attributedTextFontWithEmptyString: UIFont = {
        #if os(tvOS)
            return UIFont.systemFont(ofSize: 38, weight: UIFont.Weight.medium)
        #else
            return helveticaFont(ofSize: 12)
        #endif
    }()

    private static func helveticaFont(ofSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Helvetica", size: size) else {
            assertionFailure("`Helvetica` font couldn't be found")
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }

}
