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
open class LabelLayout<Label: UILabel>: BaseLayout<Label>, ConfigurableLayout {

    open let text: Text
    open let font: UIFont
    open let numberOfLines: Int
    open let lineHeight: CGFloat

    public init(text: Text,
                font: UIFont = LabelLayoutDefaults.defaultFont,
                lineHeight: CGFloat? = nil,
                numberOfLines: Int = LabelLayoutDefaults.defaultNumberOfLines,
                alignment: Alignment = LabelLayoutDefaults.defaultAlignment,
                flexibility: Flexibility = LabelLayoutDefaults.defaultFlexibility,
                viewReuseId: String? = nil,
                config: ((Label) -> Void)? = nil) {
        
        self.text = text
        self.numberOfLines = numberOfLines
        self.font = font
        self.lineHeight = lineHeight ?? font.lineHeight
        super.init(alignment: alignment, flexibility: flexibility, viewReuseId: viewReuseId, config: config)
    }

    init(attributedString: NSAttributedString,
         font: UIFont = LabelLayoutDefaults.defaultFont,
         lineHeight: CGFloat? = nil,
         numberOfLines: Int = LabelLayoutDefaults.defaultNumberOfLines,
         alignment: Alignment = LabelLayoutDefaults.defaultAlignment,
         flexibility: Flexibility = LabelLayoutDefaults.defaultFlexibility,
         viewReuseId: String? = nil,
         viewClass: Label.Type? = nil,
         config: ((Label) -> Void)? = nil) {

        self.text = .attributed(attributedString)
        self.numberOfLines = numberOfLines
        self.font = font
        self.lineHeight = lineHeight ?? font.lineHeight
        super.init(alignment: alignment, flexibility: flexibility, viewReuseId: viewReuseId, viewClass: viewClass ?? Label.self, config: config)
    }

    init(string: String,
         font: UIFont = LabelLayoutDefaults.defaultFont,
         lineHeight: CGFloat? = nil,
         numberOfLines: Int = LabelLayoutDefaults.defaultNumberOfLines,
         alignment: Alignment = LabelLayoutDefaults.defaultAlignment,
         flexibility: Flexibility = LabelLayoutDefaults.defaultFlexibility,
         viewReuseId: String? = nil,
         viewClass: Label.Type? = nil,
         config: ((Label) -> Void)? = nil) {

        self.text = .unattributed(string)
        self.numberOfLines = numberOfLines
        self.font = font
        self.lineHeight = lineHeight ?? font.lineHeight
        super.init(alignment: alignment, flexibility: flexibility, viewReuseId: viewReuseId, viewClass: viewClass ?? Label.self, config: config)
    }

    // MARK: - Convenience initializers

    public convenience init(text: String,
                            font: UIFont = LabelLayoutDefaults.defaultFont,
                            lineHeight: CGFloat? = nil,
                            numberOfLines: Int = LabelLayoutDefaults.defaultNumberOfLines,
                            alignment: Alignment = LabelLayoutDefaults.defaultAlignment,
                            flexibility: Flexibility = LabelLayoutDefaults.defaultFlexibility,
                            viewReuseId: String? = nil,
                            config: ((Label) -> Void)? = nil) {

        self.init(text: .unattributed(text),
                  font: font,
                  lineHeight: lineHeight,
                  numberOfLines: numberOfLines,
                  alignment: alignment,
                  flexibility: flexibility,
                  viewReuseId: viewReuseId,
                  config: config)
    }

    public convenience init(attributedText: NSAttributedString,
                            font: UIFont = LabelLayoutDefaults.defaultFont,
                            lineHeight: CGFloat? = nil,
                            numberOfLines: Int = LabelLayoutDefaults.defaultNumberOfLines,
                            alignment: Alignment = LabelLayoutDefaults.defaultAlignment,
                            flexibility: Flexibility = LabelLayoutDefaults.defaultFlexibility,
                            viewReuseId: String? = nil,
                            config: ((Label) -> Void)? = nil) {

        self.init(text: .attributed(attributedText),
                  font: font,
                  lineHeight: lineHeight,
                  numberOfLines: numberOfLines,
                  alignment: alignment,
                  flexibility: flexibility,
                  viewReuseId: viewReuseId,
                  config: config)
    }

    // MARK: - Layout protocol

    open func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        let fittedSize = textSize(within: maxSize)
        return LayoutMeasurement(layout: self, size: fittedSize.decreasedToSize(maxSize), maxSize: maxSize, sublayouts: [])
    }

    private func textSize(within maxSize: CGSize) -> CGSize {
        var size = text.textSize(within: maxSize, font: font)
        if numberOfLines > 0 {
            let maxHeight = (CGFloat(numberOfLines) * lineHeight).roundedUpToFractionalPoint
            if size.height > maxHeight {
                size = CGSize(width: maxSize.width, height: maxHeight)
            }
        }
        return size
    }

    open func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        let frame = alignment.position(size: measurement.size, in: rect)
        return LayoutArrangement(layout: self, frame: frame, sublayouts: [])
    }

    open override func configure(view label: Label) {
        config?(label)
        label.numberOfLines = numberOfLines
        label.font = font
        switch text {
        case .unattributed(let text):
            label.text = text
        case .attributed(let attributedText):
            label.attributedText = attributedText
        }
    }

    open override var needsView: Bool {
        return true
    }
}

// MARK: - Things that belong in LabelLayout but aren't because LabelLayout is generic.
// "Static stored properties not yet supported in generic types"

public class LabelLayoutDefaults {
    public static let defaultNumberOfLines = 0
    public static let defaultFont = UILabel().font ?? UIFont.systemFont(ofSize: 17)
    public static let defaultAlignment = Alignment.topLeading
    public static let defaultFlexibility = Flexibility.flexible
}

