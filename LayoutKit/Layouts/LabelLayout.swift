// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/**
 Layout for a UILabel.
 */
public class LabelLayout: Layout {

    /// The types of text that a UILabel can display.
    public enum TextType {
        case unattributed(String)
        case attributed(NSAttributedString)
    }

    public let textType: TextType
    public let numberOfLines: Int
    public let font: UIFont
    public let alignment: Alignment
    public let flexibility: Flexibility
    public let config: (UILabel -> Void)?

    private static let defaultNumberOfLines = 0
    private static let defaultFont = UIFont.systemFontOfSize(UIFont.labelFontSize())
    private static let defaultAlignment = Alignment.topLeading
    private static let defaultFlexibility = Flexibility.flexible

    public init(textType: TextType,
                numberOfLines: Int = defaultNumberOfLines,
                font: UIFont = defaultFont,
                alignment: Alignment = defaultAlignment,
                flexibility: Flexibility = defaultFlexibility,
                config: (UILabel -> Void)? = nil) {
        
        self.textType = textType
        self.numberOfLines = numberOfLines
        self.font = font
        self.alignment = alignment
        self.flexibility = flexibility
        self.config = config
    }

    // MARK: - Convenience initializers

    public convenience init(text: String,
                            numberOfLines: Int = defaultNumberOfLines,
                            font: UIFont = defaultFont,
                            alignment: Alignment = defaultAlignment,
                            flexibility: Flexibility = defaultFlexibility,
                            config: (UILabel -> Void)? = nil) {

        self.init(textType: .unattributed(text),
                  numberOfLines: numberOfLines,
                  font: font, alignment: alignment,
                  flexibility: flexibility,
                  config: config)
    }

    public convenience init(attributedText: NSAttributedString,
                            numberOfLines: Int = defaultNumberOfLines,
                            font: UIFont = defaultFont,
                            alignment: Alignment = defaultAlignment,
                            flexibility: Flexibility = defaultFlexibility,
                            config: (UILabel -> Void)? = nil) {

        self.init(textType: .attributed(attributedText),
                  numberOfLines: numberOfLines,
                  font: font, alignment: alignment,
                  flexibility: flexibility,
                  config: config)
    }

    // MARK: - Layout protocol

    public func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        let fittedSize = textSize(within: maxSize)
        return LayoutMeasurement(layout: self, size: fittedSize.sizeDecreasedToSize(maxSize), maxSize: maxSize, sublayouts: [])
    }

    private func textSize(within maxSize: CGSize) -> CGSize {
        let options: NSStringDrawingOptions = [
            .UsesLineFragmentOrigin,
            .UsesFontLeading
        ]

        var size: CGSize
        switch textType {
        case .attributed(let attributedText):
            if attributedText == "" {
                return CGSizeZero
            }

            // UILabel uses a default font if one is not specified in the attributed string.
            // boundingRectWithSize does not appear to have the same logic,
            // so we need to ensure that our attributed string has a default font.
            // We do this by creating a new attributed string with the default font and then
            // applying all of the attributes from the provided attributed string.
            let fontAttribute = [NSFontAttributeName: font]
            let attributedTextWithFont = NSMutableAttributedString(string: attributedText.string, attributes: fontAttribute)
            let fullRange = NSMakeRange(0, (attributedText.string as NSString).length)
            attributedTextWithFont.beginEditing()
            attributedText.enumerateAttributesInRange(fullRange, options: .LongestEffectiveRangeNotRequired, usingBlock: { (attributes, range, _) in
                attributedTextWithFont.addAttributes(attributes, range: range)
            })
            attributedTextWithFont.endEditing()

            size = attributedTextWithFont.boundingRectWithSize(maxSize, options: options, context: nil).size
        case .unattributed(let text):
            if text == "" {
                return CGSizeZero
            }
            size = text.boundingRectWithSize(maxSize, options: options, attributes: [NSFontAttributeName: font], context: nil).size
        }
        // boundingRectWithSize returns size to a precision of hundredths of a point,
        // but UILabel only returns sizes with a point precision of 1/screenDensity.
        size.height = roundUpToFractionalPoint(size.height)
        size.width = roundUpToFractionalPoint(size.width)
        if numberOfLines > 0 {
            let maxHeight = roundUpToFractionalPoint(CGFloat(numberOfLines) * font.lineHeight)
            if size.height > maxHeight {
                size = CGSize(width: maxSize.width, height: maxHeight)
            }
        }
        return size
    }

    private func roundUpToFractionalPoint(point: CGFloat) -> CGFloat {
        if point <= 0 {
            return 0
        }
        let scale: CGFloat = UIScreen.mainScreen().scale
        // The smallest precision in points (aka the number of points per hardware pixel).
        let pointPrecision = 1.0 / scale
        if point <= pointPrecision {
            return pointPrecision
        }
        return ceil(point * scale) / scale
    }

    public func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        let frame = alignment.position(size: measurement.size, inRect: rect)
        return LayoutArrangement(layout: self, frame: frame, sublayouts: [])
    }

    public func makeView() -> UIView? {
        let label = UILabel()
        config?(label)
        label.numberOfLines = numberOfLines
        label.font = font
        switch textType {
        case .unattributed(let text):
            label.text = text
        case .attributed(let attributedText):
            label.attributedText = attributedText
        }
        return label
    }
}