// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
@testable import LayoutKit

class TextViewLayoutTests: XCTestCase {

    func testNeedsView() {
        let layout = TextViewLayout(text: "hi").arrangement().makeViews()
        XCTAssertNotNil(layout as? UITextView)
    }

    func testTextViewLayout() {
        for textTestCase in Text.testCases {
            let textView = UITextView(text: textTestCase.text,
                                      font: textTestCase.font)

            let layout = textTestCase.font.map({ (font: UIFont) -> Layout in
                return TextViewLayout(text: textTestCase.text, font: font)
            }) ?? TextViewLayout(text: textTestCase.text)

            let layoutView = layout.arrangement()

            // Skip if the both widths equal to 0, no need to check height
            // `intrinsicContentSize` of `UITextView` still has non-zero height even the text is empty
            if layout.arrangement().frame.size.width == 0 && textView.intrinsicContentSize.width == 0 {
                continue
            }

            XCTAssertEqual(layoutView.frame.size, textView.intrinsicContentSize, "fontName:\(textTestCase.font?.fontName) text:\(textTestCase.text) fontSize:\(textTestCase.font?.pointSize)")
        }
    }

    func testMutipleLinesWithUnattributedString() {
        let textString = "Hello World\nHello World\nHello World\nHello World\nHello World"
        let text = Text.unattributed(textString)

        let textView = UITextView(text: text)

        let layout = TextViewLayout(text: text)
        let layoutView = layout.arrangement()

        XCTAssertEqual(layoutView.frame.size, textView.intrinsicContentSize)
    }

    func testMutipleLinesWithAttributedString() {
        let textString = "Hello World\nHello World\nHello World\nHello World\nHello World"
        let attributedString = NSAttributedString(
            string: textString,
            attributes: [NSFontAttributeName: UIFont.helvetica(size: 15)])
        let attributedText = Text.attributed(attributedString)

        let textView = UITextView(text: attributedText)

        let layout = TextViewLayout(text: attributedText)
        let layoutView = layout.arrangement()

        XCTAssertEqual(layoutView.frame.size, textView.intrinsicContentSize)
    }

    func testMutipleLinesWithMutipleAttributedStrings() {
        let textString = "Hello World\nHello World\nHello World\nHello World\nHello World"
        let attributedString1 = NSMutableAttributedString(
            string: textString,
            attributes: [NSFontAttributeName: UIFont.helvetica(size: 15)])
        let attributedString2 = NSMutableAttributedString(
            string: textString,
            attributes: [NSFontAttributeName: UIFont.helvetica(size: 12)])
        attributedString1.append(attributedString2)
        let attributedText = Text.attributed(attributedString1)

        let textView = UITextView(text: attributedText)

        let layout = TextViewLayout(text: attributedText)
        let layoutView = layout.arrangement()

        XCTAssertEqual(layoutView.frame.size, textView.intrinsicContentSize)
    }

    func testLineFragmentPadding() {
        let textString = "Hello World\nHello World\nHello World\nHello World\nHello World"
        let text = Text.unattributed(textString)
        let lineFragmentPadding: CGFloat = 30.0

        let textView = UITextView(text: text,
                                  lineFragmentPadding: lineFragmentPadding)

        let layout = TextViewLayout(text: text, lineFragmentPadding: lineFragmentPadding)
        let layoutView = layout.arrangement()

        XCTAssertEqual(layoutView.frame.size, textView.intrinsicContentSize)
    }

    func testTextContainerInset() {
        let textString = "Hello World\nHello World\nHello World\nHello World\nHello World"
        let text = Text.unattributed(textString)
        let textContainerInset = UIEdgeInsets(top: 2, left: 3, bottom: 4, right: 5)

        let textView = UITextView(text: text,
                                  textContainerInset: textContainerInset)

        let layout = TextViewLayout(text: text, textContainerInset: textContainerInset)
        let layoutView = layout.arrangement()

        XCTAssertEqual(layoutView.frame.size, textView.intrinsicContentSize)
    }

}

// MARK: - private helper extension

private extension UITextView {

    static let defaultFont = UIFont.systemFont(ofSize: 12)

    convenience init(text: Text,
                     font: UIFont? = nil,
                     lineFragmentPadding: CGFloat = 0,
                     textContainerInset: UIEdgeInsets = UIEdgeInsets.zero,
                     contentInset: UIEdgeInsets = UIEdgeInsets.zero,
                     layoutMargins: UIEdgeInsets = UIEdgeInsets.zero) {
        self.init()

        switch text {
        case .unattributed(let unattributedText):
            self.text = unattributedText
            self.font = font ?? UITextView.defaultFont
        case .attributed(let attributedText):
            // If font is using default, applied default font to attributedString
            self.attributedText = attributedText.with(defaultFont: font ?? UITextView.defaultFont)
        }

        self.textContainer.lineFragmentPadding = lineFragmentPadding
        self.textContainerInset = textContainerInset
        self.contentInset = contentInset
        self.layoutMargins = layoutMargins

        // Not supporting `usesFontLeading`
        self.layoutManager.usesFontLeading = false

        // `isScrollEnabled` set to false to enable `intrinsicContentSize`
        // http://stackoverflow.com/questions/16868117/uitextview-that-expands-to-text-using-auto-layout/21287306#21287306
        self.isScrollEnabled = false
    }

}
