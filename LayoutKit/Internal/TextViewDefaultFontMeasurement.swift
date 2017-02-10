// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/// This measurement is used to measure the default font of `UITextView`
class TextViewDefaultFontMeasurement {

    // Make it singleton that it won't calculate mutiple times
    static let sharedInstance = TextViewDefaultFontMeasurement()
    private let spaceString = " "
    private let emptyString = ""

    // Default unattributed font
    let unattributedTextFont: UIFont

    // Default attributed font
    let attributedTextFont: UIFont

    // Default attributed font with empty string
    let attributedTextFontWithEmptyString: UIFont

    init() {
        let unattributedTextView = UITextView()
        // a space string must be given, otherwise font will be unavailable
        unattributedTextView.text = spaceString
        self.unattributedTextFont = unattributedTextView.font
            ?? TextViewDefaultFontMeasurement.defaultUnattributedTextFont

        let attributedTextView = UITextView()
        // a string must be given, otherwise font will be unavailable
        attributedTextView.attributedText = NSAttributedString(string: spaceString)
        self.attributedTextFont = attributedTextView.font
            ?? TextViewDefaultFontMeasurement.defaultAttributedTextFont

        let attributedTextViewWithEmptyString = UITextView()
        // an empty string must be given, otherwise font will be unavailable
        attributedTextViewWithEmptyString.attributedText = NSAttributedString(string: emptyString)
        self.attributedTextFontWithEmptyString = attributedTextViewWithEmptyString.font
            ?? TextViewDefaultFontMeasurement.defaultAttributedTextFont
    }

    // If font is still unavailable, we have a backup solution from iOS/tvOS
    private static var defaultUnattributedTextFont: UIFont {
        #if os(tvOS)
            return helveticaFont(ofSize: 38)
        #else
            return helveticaFont(ofSize: 12)
        #endif
    }

    private static var defaultAttributedTextFont: UIFont {
        #if os(tvOS)
            return helveticaFont(ofSize: 12)
        #else
            return helveticaFont(ofSize: 12)
        #endif
    }

    private static func helveticaFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica", size: size) ?? UIFont.systemFont(ofSize: size)
    }

}
