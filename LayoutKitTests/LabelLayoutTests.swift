// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
import LayoutKit

class LabelLayoutTests: XCTestCase {

    // For the defined `sampleText` and `labelLayoutMaxWidth` combination, `LabelLayout` requires 2 line of
    // text for char-wrapping and 3 lines for word-wrapping/truncating-tail.
    // So don't change this combination as the following tests are based on these values:
    // - testSizeCalculationWithDifferentLineBreakMode
    // - testAttributedTextSizeCalculationWithDifferentLineBreakMode
    private static let sampleText = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean comm"
    private static let labelLayoutMaxWidth = 305

    func testNeedsView() {
        let l = LabelLayout(text: "hi").arrangement().makeViews()
        XCTAssertNotNil(l as? UILabel)
    }

    func testLabelLayout() {
        for textTestCase in Text.testCases {
            let label = UILabel()
            if let font = textTestCase.font {
                label.font = font
            }

            switch textTestCase.text {
            case .unattributed(let text):
                label.text = text
            case .attributed(let text):
                label.attributedText = text
            }

            let layout = textTestCase.font.map({ (font: UIFont) -> Layout in
                return LabelLayout(text: textTestCase.text, font: font)
            }) ?? LabelLayout(text: textTestCase.text)

            XCTAssertEqual(
                layout.arrangement().frame.size,
                label.intrinsicContentSize,
                "fontName:\(String(describing: textTestCase.font?.fontName)) text:\(textTestCase.text) fontSize:\(String(describing: textTestCase.font?.pointSize))")
        }
    }

    func testHiLabel() {
        let text = "Hi"
        let font = UIFont.helvetica()

        let arrangement = LabelLayout(text: text, font: font).arrangement()
        let label = UILabel(text: text, font: font)

        XCTAssertEqual(arrangement.makeViews().frame.size, label.intrinsicContentSize)
    }

    func testAttributedLabel() {
        let attributedText = NSAttributedString(string: "Hi", attributes: [NSAttributedString.Key.font: UIFont.helvetica(size: 42)])
        let font = UIFont.helvetica(size: 99)

        let arrangement = LabelLayout(attributedText: attributedText, font: font).arrangement()
        let label = UILabel(attributedText: attributedText, font: font)

        XCTAssertEqual(arrangement.makeViews().frame.size, label.intrinsicContentSize)
    }

    func testTwoLineLabel() {
        let text = "Nick Snyder"
        let numberOfLines = 2
        let font = UIFont.helvetica()
        let width: CGFloat = 90

        let arrangement = LabelLayout(text: text, font: font, numberOfLines: numberOfLines).arrangement(width: width)
        let label = UILabel(text: text, font: font, numberOfLines: numberOfLines)

        let labelSize = label.sizeThatFits(CGSize(width: 90, height: .max))
        XCTAssertEqual(arrangement.frame.size, labelSize)
    }

    func testMaxNumberOfLinesTruncation() {
        let text = "Nick Snyder"
        let numberOfLines = 1
        let font = UIFont.helvetica()
        let width: CGFloat = 90

        let arrangement = LabelLayout(text: text, font: font, numberOfLines: numberOfLines).arrangement(width: width)
        let label = UILabel(text: text, font: font, numberOfLines: numberOfLines)

        let height = label.sizeThatFits(CGSize(width: 90, height: .max)).height
        XCTAssertEqual(arrangement.frame.size, CGSize(width: width, height: height))
    }

    func testEmptyLabel() {
        let labelLayout = LabelLayout(text: "")
        let label = UILabel()
        label.text = ""
        XCTAssertEqual(labelLayout.arrangement().frame.size, label.intrinsicContentSize)
    }

    func testSingleLineHeight() {
        let text = "hello world"

        func testFont(_ font: UIFont) {
            let label = UILabel(text: text, font: font)
            let layoutSize = LabelLayout(text: text, font: font).arrangement().frame.size
            XCTAssertEqual(label.intrinsicContentSize, layoutSize)
            XCTAssertEqual(label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)), layoutSize)
        }

        for fontSize in 1...50 {
            testFont(UIFont(name: "Helvetica", size: CGFloat(fontSize))!)
            testFont(UIFont.systemFont(ofSize: CGFloat(fontSize)))
        }
    }

    func testAttributedTextDefaultFont() {
        let text = NSAttributedString(string: "Hello! 😄😄😄")

        let arrangement = LabelLayout(attributedText: text).arrangement()
        let label = UILabel(attributedText: text)

        XCTAssertEqual(arrangement.frame.size, label.intrinsicContentSize)
    }

    func testAttributedTextCustomFont() {
        #if !os(tvOS) // tvOS doesn't currently support custom fonts
        let font = UIFont(name: "Papyrus", size: 20)!
        let attributes = [NSAttributedString.Key.font: font]
        let text = NSAttributedString(string: "Hello! 😄😄😄", attributes: attributes)

        let arrangement = LabelLayout(attributedText: text).arrangement()
        let label = UILabel(attributedText: text)

        XCTAssertEqual(arrangement.frame.size, label.intrinsicContentSize)
        #endif
    }

    func testAttributedStringCustomFontPartialRange() {
        #if !os(tvOS) // tvOS doesn't currently support custom fonts
        let font = UIFont(name: "Papyrus", size: 20)!
        let text = NSMutableAttributedString(string: "Hello world! 😄😄😄")
        text.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(6, 6))

        let arrangement = LabelLayout(attributedText: text).arrangement()
        let label = UILabel(attributedText: text)

        XCTAssertEqual(arrangement.frame.size, label.intrinsicContentSize)
        #endif
    }

    func testConfig() {
        var configCount = 0
        let labelLayout = LabelLayout(text: "Hi", config: { view in
            configCount += 1
        })
        let label = labelLayout.arrangement().makeViews()
        XCTAssertNotNil(label)
        XCTAssertEqual(configCount, 1)
    }

    func testHelveticaNeueOneLineText() {
        let text = "7 d"
        let font = UIFont.helveticaNeue(size: 12)
        let numberOfLines = 1

        let label = UILabel(text: text, font: font, numberOfLines: numberOfLines)
        let arrangement = LabelLayout(text: text, font: font, numberOfLines: numberOfLines).arrangement()

        XCTAssertEqual(arrangement.makeViews().frame.size, label.intrinsicContentSize)
    }

    func testHelveticaNeueOneLineAttributedText() {
        let text = NSAttributedString(string: "7 d")
        let font = UIFont.helveticaNeue(size: 12)
        let numberOfLines = 1

        let label = UILabel(attributedText: text, font: font, numberOfLines: numberOfLines)
        let arrangement = LabelLayout(attributedText: text, font: font, numberOfLines: numberOfLines).arrangement()

        XCTAssertEqual(arrangement.makeViews().frame.size, label.intrinsicContentSize)
    }

    func testHelveticaNeueTwoLineText() {
        let text = "7 d"
        let font = UIFont.helveticaNeue(size: 12)
        let numberOfLines = 2

        let label = UILabel(text: text, font: font, numberOfLines: numberOfLines)
        let layout = LabelLayout(text: text, font: font, numberOfLines: numberOfLines)

        let maxSize = CGSize(width: 17, height: .max)
        XCTAssertEqual(layout.measurement(within: maxSize).size, label.sizeThatFits(maxSize))
    }

    func testHelveticaNeueTwoLineAttributedText() {
        let text = NSAttributedString(string: "7 d")
        let font = UIFont.helveticaNeue(size: 12)
        let numberOfLines = 2

        let label = UILabel(attributedText: text, font: font, numberOfLines: numberOfLines)
        let layout = LabelLayout(attributedText: text, font: font, numberOfLines: numberOfLines)

        let maxSize = CGSize(width: 17, height: .max)
        XCTAssertEqual(layout.measurement(within: maxSize).size, label.sizeThatFits(maxSize))
    }

    func testSizeCalculationWithDifferentLineBreakMode() {
        // Use different line break mode for `LabelLayout` and dummy label.
        // So in this case, size calculation should not match with dummy label's size calculation.
        let label = UILabel(text: LabelLayoutTests.sampleText, numberOfLines: 0, lineBreakMode: .byCharWrapping)
        let layout = LabelLayout(text: LabelLayoutTests.sampleText)
        let maxSize = CGSize(width: LabelLayoutTests.labelLayoutMaxWidth, height: .max)
        XCTAssertNotEqual(layout.measurement(within: maxSize).size, label.sizeThatFits(maxSize))
    }

    func testAttributedTextSizeCalculationWithDifferentLineBreakMode() {
        // Use different line break mode for `LabelLayout` and dummy label.
        // So in this case, size calculation should not match with dummy label's size calculation.
        let attributedText = NSAttributedString(string: LabelLayoutTests.sampleText)
        let label = UILabel(attributedText: attributedText, numberOfLines: 0, lineBreakMode: .byCharWrapping)
        let layout = LabelLayout(attributedText: attributedText)
        let maxSize = CGSize(width: LabelLayoutTests.labelLayoutMaxWidth, height: .max)
        XCTAssertNotEqual(layout.measurement(within: maxSize).size, label.sizeThatFits(maxSize))
    }

    func testTextSizeCalculationWithSameLineBreakMode() {
        // Use same line break mode for `LabelLayout` and dummy label and then match LabelLayout's size with dummy label's size calculation.
        let lineBreakingModes: [NSLineBreakMode] = [
            .byWordWrapping,
            .byCharWrapping,
            .byClipping,
            .byTruncatingHead,
            .byTruncatingTail,
            .byTruncatingMiddle
        ]

        lineBreakingModes.forEach { (lineBreakMode) in
            verifyTextSizeCalculation(with: LabelLayoutTests.sampleText, lineBreakMode: lineBreakMode)
        }
    }

    func testAttributedTextSizeCalculationWithSameLineBreakMode() {
        // Use same line break mode for `LabelLayout` and dummy label and then match LabelLayout's size with dummy label's size calculation.
        let lineBreakingModes: [NSLineBreakMode] = [
            .byWordWrapping,
            .byCharWrapping,
            .byClipping,
            .byTruncatingHead,
            .byTruncatingTail,
            .byTruncatingMiddle
        ]

        let attributedText = NSAttributedString(string: LabelLayoutTests.sampleText)
        lineBreakingModes.forEach { (lineBreakMode) in
            verifyAttributedTextSizeCalculation(with: attributedText, lineBreakMode: lineBreakMode)
        }
    }

    // MARK: Private Helpers

    private func verifyTextSizeCalculation(with text: String, lineBreakMode: NSLineBreakMode) {
        let label = UILabel(text: text, numberOfLines: 0, lineBreakMode: lineBreakMode)
        let layout = LabelLayout(text: text, lineBreakMode: lineBreakMode)
        let maxSize = CGSize(width: LabelLayoutTests.labelLayoutMaxWidth, height: .max)
        XCTAssertEqual(layout.measurement(within: maxSize).size, label.sizeThatFits(maxSize))
    }

    private func verifyAttributedTextSizeCalculation(with attributedText: NSAttributedString, lineBreakMode: NSLineBreakMode) {
        let label = UILabel(attributedText: attributedText, numberOfLines: 0, lineBreakMode: lineBreakMode)
        let layout = LabelLayout(attributedText: attributedText, lineBreakMode: lineBreakMode)
        let maxSize = CGSize(width: LabelLayoutTests.labelLayoutMaxWidth, height: .max)
        XCTAssertEqual(layout.measurement(within: maxSize).size, label.sizeThatFits(maxSize))
    }
}

extension UILabel {
    convenience init(text: String, font: UIFont? = nil, numberOfLines: Int? = nil, lineBreakMode: NSLineBreakMode? = nil) {
        self.init()
        self.text = text
        if let font = font {
            self.font = font
        }
        if let numberOfLines = numberOfLines {
            self.numberOfLines = numberOfLines
        }
        if let lineBreakMode = lineBreakMode {
            self.lineBreakMode = lineBreakMode
        }
    }

    convenience init(attributedText: NSAttributedString, font: UIFont? = nil, numberOfLines: Int? = nil, lineBreakMode: NSLineBreakMode? = nil) {
        self.init()
        if let font = font {
            self.font = font
        }
        if let numberOfLines = numberOfLines {
            self.numberOfLines = numberOfLines
        }
        if let lineBreakMode = lineBreakMode {
            self.lineBreakMode = lineBreakMode
        }

        // Want to set attributed text AFTER font it set, otherwise the font seems to take precedence.
        self.attributedText = attributedText
    }
}
