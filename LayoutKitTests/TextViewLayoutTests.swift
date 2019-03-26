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

    private let epsilon: CGFloat = 0.0000001

    func testNeedsView() {
        let layout = TextViewLayout(text: "hi").arrangement().makeViews()
        XCTAssertNotNil(layout as? UITextView)
    }

    func testTextViewLayout() {
        for textTestCase in Text.testCases {
            let textView = UITextView(
                text: textTestCase.text,
                font: textTestCase.font)

            let layout = textTestCase.font.map({ (font: UIFont) -> Layout in
                return TextViewLayout(text: textTestCase.text, font: font)
            }) ?? TextViewLayout(text: textTestCase.text)

            let layoutArrangement = layout.arrangement()

            XCTAssertEqual(
                layoutArrangement.frame.size,
                textView.intrinsicContentSize,
                "fontName:\(String(describing: textTestCase.font?.fontName)) text:\(textTestCase.text) fontSize:\(String(describing: textTestCase.font?.pointSize))")
        }
    }

    func testMutipleLinesWithUnattributedString() {
        let textString = "Hello World\nHello World\nHello World\nHello World\nHello World"
        let text = Text.unattributed(textString)

        let textView = UITextView(text: text, font: UIFont.systemFont(ofSize: 12))

        let layout = TextViewLayout(text: text, font: UIFont.systemFont(ofSize: 12))
        let layoutArrangement = layout.arrangement()

        XCTAssertEqual(layoutArrangement.frame.size, textView.intrinsicContentSize)
    }

    func testMutipleLinesWithAttributedString() {
        let textString = "Hello World\nHello World\nHello World\nHello World\nHello World"
        let attributedString = NSAttributedString(
            string: textString)
        let attributedText = Text.attributed(attributedString)

        let textView = UITextView(text: attributedText)

        let layout = TextViewLayout(text: attributedText)
        let layoutArrangement = layout.arrangement()

        XCTAssertEqual(layoutArrangement.frame.size, textView.intrinsicContentSize)
    }

    func testMutipleLinesWithMutipleAttributedStrings() {
        let textString = "Hello World\nHello World\nHello World\nHello World\nHello World"
        let attributedString1 = NSMutableAttributedString(
            string: textString,
            attributes: [NSAttributedString.Key.font: UIFont.helvetica(size: 15)])
        let attributedString2 = NSMutableAttributedString(
            string: textString,
            attributes: [NSAttributedString.Key.font: UIFont.helvetica(size: 12)])
        attributedString1.append(attributedString2)
        let attributedText = Text.attributed(attributedString1)

        let textView = UITextView(text: attributedText)

        let layout = TextViewLayout(text: attributedText)
        let layoutArrangement = layout.arrangement()

        XCTAssertEqual(layoutArrangement.frame.size, textView.intrinsicContentSize)
    }

    func testLineFragmentPadding() {
        let textString = "Hello World\nHello World\nHello World\nHello World\nHello World"
        let text = Text.unattributed(textString)
        let lineFragmentPadding: CGFloat = 30.0

        let textView = UITextView(
            text: text,
            font: UIFont.systemFont(ofSize: 12),
            lineFragmentPadding: lineFragmentPadding)

        let layout = TextViewLayout(
            text: text,
            font: UIFont.systemFont(ofSize: 12),
            lineFragmentPadding: lineFragmentPadding)
        let layoutArrangement = layout.arrangement()

        XCTAssertEqual(layoutArrangement.frame.size, textView.intrinsicContentSize)
    }

    func testTextContainerInset() {
        let textString = "Hello World\nHello World\nHello World\nHello World\nHello World"
        let text = Text.unattributed(textString)
        let textContainerInset = UIEdgeInsets(top: 2, left: 3, bottom: 4, right: 5)

        let textView = UITextView(
            text: text,
            font: UIFont.systemFont(ofSize: 12),
            textContainerInset: textContainerInset)

        let layout = TextViewLayout(
            text: text,
            font: UIFont.systemFont(ofSize: 12),
            textContainerInset: textContainerInset)
        let layoutArrangement = layout.arrangement()

        XCTAssertEqual(layoutArrangement.frame.size, textView.intrinsicContentSize)
    }

    func testTextContainerInsetWithWordWrap() {
        let textString = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        let text = Text.unattributed(textString)
        let textContainerInset = UIEdgeInsets(top: 2, left: 3, bottom: 4, right: 5)

        let textView = UITextView(
            text: text,
            font: UIFont.systemFont(ofSize: 12),
            textContainerInset: textContainerInset)

        let layout = TextViewLayout(
            text: text,
            font: UIFont.systemFont(ofSize: 12),
            textContainerInset: textContainerInset)
        let layoutArrangement = layout.arrangement()

        XCTAssertTrue(abs(layoutArrangement.frame.size.width - textView.intrinsicContentSize.width) < epsilon)
        XCTAssertTrue(abs(layoutArrangement.frame.size.height - textView.intrinsicContentSize.height) < epsilon)
    }

    func testInSpecificViewSize() {
        let textString = "Hello World\nHello World\nHello World\nHello World\nHello World"
        let text = Text.unattributed(textString)

        let layout = TextViewLayout(text: text)
        let layoutArrangement = layout.arrangement(origin: CGPoint.zero, width: 20, height: 20)

        XCTAssertTrue(layoutArrangement.frame.size.width <= 20, "Width should be less than the max width")
        XCTAssertTrue(layoutArrangement.frame.size.height <= 20, "Width should be less than the max height")
    }

}

// MARK: - private helper extension

private extension UITextView {

    convenience init(text: Text,
                     font: UIFont? = nil,
                     lineFragmentPadding: CGFloat = 0,
                     textContainerInset: UIEdgeInsets = UIEdgeInsets.zero) {
        self.init()

        switch text {
        case .unattributed(let unattributedText):
            if font != nil {
                self.font = font
            }
            self.text = unattributedText
        case .attributed(let attributedText):
            if let font = font {
                self.font = font
                self.attributedText = attributedText.with(font: font)
            } else {
                self.attributedText = attributedText
            }
        }

        self.textContainer.lineFragmentPadding = lineFragmentPadding
        self.textContainerInset = textContainerInset

        // Not supporting `usesFontLeading`
        self.layoutManager.usesFontLeading = false

        // `isScrollEnabled` set to false to enable `intrinsicContentSize`
        // http://stackoverflow.com/questions/16868117/uitextview-that-expands-to-text-using-auto-layout/21287306#21287306
        self.isScrollEnabled = false
    }

}
