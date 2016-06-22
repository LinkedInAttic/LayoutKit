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

    func testHiLabel() {
        let lableLayout = LabelLayout(text: "Hi", font: UIFont.helvetica())
        let label = lableLayout.arrangement().makeViews()
        AssertEqualDensity(label.frame, [
            2.0: CGRect(x: 0, y: 0, width: 16.5, height: 20),
            3.0: CGRect(x: 0, y: 0, width: 16 + oneThird, height: 19 + twoThirds),
            ])
    }

    func testAttributedLabel() {
        let attributedText = NSAttributedString(string: "Hi", attributes: [NSFontAttributeName: UIFont.helvetica(size: 42)])
        let lableLayout = LabelLayout(attributedText: attributedText, font: UIFont.helvetica(size: 99))
        let label = lableLayout.arrangement().makeViews()
        XCTAssertEqual((label as? UILabel)?.font.pointSize, 42)
        AssertEqualDensity(label.frame, [
            2.0: CGRect(x: 0, y: 0, width: 40, height: 48.5),
            3.0: CGRect(x: 0, y: 0, width: 39 + twoThirds, height: 48 + oneThird),
            ])
    }

    func testTwoLineLabel() {
        let labelLayout = LabelLayout(text: "Nick Snyder", numberOfLines: 2, font: UIFont.helvetica())
        let arrangement = labelLayout.arrangement(width: 90)
        AssertEqualDensity(arrangement.frame, [
            2.0: CGRect(x: 0, y: 0, width: 54, height: 39.5),
            3.0: CGRect(x: 0, y: 0, width: 54, height: 39 + oneThird)
            ])
    }

    func testMaxNumberOfLinesTruncation() {
        let labelLayout = LabelLayout(text: "Nick Snyder", numberOfLines: 1, font: UIFont.helvetica())
        let label = labelLayout.arrangement(width: 90)
        AssertEqualDensity(label.frame, [
            2.0: CGRect(x: 0, y: 0, width: 90, height: 20),
            3.0: CGRect(x: 0, y: 0, width: 90, height: 19 + twoThirds)
            ])
    }

    func testEmptyLabel() {
        let labelLayout = LabelLayout(text: "", font: UIFont.helvetica())
        let arrangement = labelLayout.arrangement()
        XCTAssertEqual(arrangement.frame, CGRectZero)
    }

    func testSingleLineHeight() {
        let text = "hello world"

        func testFont(font: UIFont) {
            let label = UILabel(text: text, font: font)
            let layoutSize = LabelLayout(text: text, font: font).arrangement().frame.size
            XCTAssertEqual(label.intrinsicContentSize(), layoutSize)
            XCTAssertEqual(label.sizeThatFits(CGSize(width: CGFloat.max, height: CGFloat.max)), layoutSize)
        }

        for fontSize in 1...50 {
            testFont(UIFont(name: "Helvetica", size: CGFloat(fontSize))!)
            testFont(UIFont.systemFontOfSize(CGFloat(fontSize)))
        }
    }

    func testAttributedTextDefaultFont() {
        let text = NSAttributedString(string: "Hello! 😄😄😄")

        let frame = LabelLayout(attributedText: text).arrangement().frame
        AssertEqualDensity(frame, [
            2.0: CGRect(x: 0, y: 0, width: 114.5, height: 20.5),
            3.0: CGRect(x: 0, y: 0, width: 114 + oneThird, height: 20 + oneThird)
            ])
    }

    func testAttributedTextCustomFont() {
        let font = UIFont(name: "Papyrus", size: 20)!
        let attributes = [NSFontAttributeName: font]
        let text = NSAttributedString(string: "Hello! 😄😄😄", attributes: attributes)

        let frame = LabelLayout(attributedText: text).arrangement().frame
        AssertEqualDensity(frame, [
            2.0: CGRect(x: 0, y: 0, width: 125.5, height: 31),
            3.0: CGRect(x: 0, y: 0, width: 125 + twoThirds, height: 31)
            ])
    }

    func testAttributedStringCustomFontPartialRange() {
        let font = UIFont(name: "Papyrus", size: 20)!
        let text = NSMutableAttributedString(string: "Hello world! 😄😄😄")
        text.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(6, 6))

        let frame = LabelLayout(attributedText: text).arrangement().frame
        AssertEqualDensity(frame, [
            2.0: CGRect(x: 0, y: 0, width: 168, height: 31),
            3.0: CGRect(x: 0, y: 0, width: 168, height: 31)
            ])
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
}

extension UILabel {
    convenience init(text: String, font: UIFont) {
        self.init()
        self.text = text
        self.font = font
    }
}
