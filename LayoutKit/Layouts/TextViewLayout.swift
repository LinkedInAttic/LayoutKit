// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/**
 Layout for a UITextView.
 */
open class TextViewLayout<TextView: UITextView>: BaseLayout<TextView>, ConfigurableLayout {

    // MARK: - instance variables

    open let text: Text
    open let font: UIFont
    open let textContainerInset: UIEdgeInsets
    open let lineFragmentPadding: CGFloat
    open let contentInset: UIEdgeInsets
    open let layoutMargins: UIEdgeInsets

    // MARK: - initializers

    public init(text: Text,
                font: UIFont = defaultFont,
                lineFragmentPadding: CGFloat = 0,
                contentInset: UIEdgeInsets = .zero,
                layoutMargins: UIEdgeInsets = .zero,
                textContainerInset: UIEdgeInsets = .zero,
                layoutAlignment: Alignment = defaultAlignment,
                flexibility: Flexibility = defaultFlexibility,
                viewReuseId: String? = nil,
                configure: ((TextView) -> Void)? = nil) {
        self.text = text
        self.font = font
        self.lineFragmentPadding = lineFragmentPadding
        self.contentInset = contentInset
        self.layoutMargins = layoutMargins
        self.textContainerInset = textContainerInset

        super.init(alignment: layoutAlignment, flexibility: flexibility, viewReuseId: viewReuseId, config: configure)
    }

    // MARK: - Convenience initializers

    public convenience init(text: String,
                            font: UIFont = defaultFont,
                            lineFragmentPadding: CGFloat = 0,
                            contentInset: UIEdgeInsets = .zero,
                            layoutMargins: UIEdgeInsets = .zero,
                            textContainerInset: UIEdgeInsets = .zero,
                            layoutAlignment: Alignment = defaultAlignment,
                            flexibility: Flexibility = defaultFlexibility,
                            viewReuseId: String? = nil,
                            configure: ((TextView) -> Void)? = nil) {
        self.init(text: .unattributed(text),
                  font: font,
                  lineFragmentPadding: lineFragmentPadding,
                  contentInset: contentInset,
                  layoutMargins: layoutMargins,
                  textContainerInset: textContainerInset,
                  layoutAlignment: layoutAlignment,
                  flexibility: flexibility,
                  viewReuseId: viewReuseId,
                  configure: configure)
    }

    public convenience init(attributedText: NSAttributedString,
                            font: UIFont = defaultFont,
                            lineFragmentPadding: CGFloat = 0,
                            contentInset: UIEdgeInsets = .zero,
                            layoutMargins: UIEdgeInsets = .zero,
                            textContainerInset: UIEdgeInsets = .zero,
                            layoutAlignment: Alignment = defaultAlignment,
                            flexibility: Flexibility = defaultFlexibility,
                            viewReuseId: String? = nil,
                            configure: ((TextView) -> Void)? = nil) {
        self.init(text: .attributed(attributedText),
                  font: font,
                  lineFragmentPadding: lineFragmentPadding,
                  contentInset: contentInset,
                  layoutMargins: layoutMargins,
                  textContainerInset: textContainerInset,
                  layoutAlignment: layoutAlignment,
                  flexibility: flexibility,
                  viewReuseId: viewReuseId,
                  configure: configure)
    }

    // MARK: - Layout protocol

    open func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        let fittedSize = textSize(within: maxSize)
        return LayoutMeasurement(layout: self, size: fittedSize.decreasedToSize(maxSize), maxSize: maxSize, sublayouts: [])
    }

    open func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        let frame = alignment.position(size: measurement.size, in: rect)
        return LayoutArrangement(layout: self, frame: frame, sublayouts: [])
    }

    // MARK: - private helpers

    private func textSize(within maxSize: CGSize) -> CGSize {
        let options: NSStringDrawingOptions = [
            .usesLineFragmentOrigin
        ]

        var size: CGSize
        let heightInset = (textContainerInset.top + textContainerInset.bottom) + (layoutMargins.top + layoutMargins.bottom)
        let widthInset = (textContainerInset.left + textContainerInset.right) + (layoutMargins.left + layoutMargins.right) + lineFragmentPadding
            + (contentInset.left + contentInset.right)
        let textContainerMaxSize = CGSize(width: maxSize.width + widthInset, height: maxSize.height + heightInset)
        switch text {
        case .attributed(let attributedText):
            if attributedText.length == 0 {
                return .zero
            }

            // UITextView uses a default font if one is not specified in the attributed string.
            // boundingRectWithSize does not appear to have the same logic,
            // so we need to ensure that our attributed string has a default font.
            // We do this by creating a new attributed string with the default font and then
            // applying all of the attributes from the provided attributed string.
            let fontAttribute = [NSFontAttributeName: font]
            let attributedTextWithFont = NSMutableAttributedString(string: attributedText.string, attributes: fontAttribute)
            let fullRange = NSMakeRange(0, (attributedText.string as NSString).length)
            attributedTextWithFont.beginEditing()
            attributedText.enumerateAttributes(in: fullRange, options: .longestEffectiveRangeNotRequired, using: { (attributes, range, _) in
                attributedTextWithFont.addAttributes(attributes, range: range)
            })
            attributedTextWithFont.endEditing()

            size = attributedTextWithFont.boundingRect(with: textContainerMaxSize, options: options, context: nil).size
        case .unattributed(let text):
            if text == "" {
                return .zero
            }
            size = text.boundingRect(with: textContainerMaxSize, options: options, attributes: [NSFontAttributeName: font], context: nil).size
        }

        size.height = ceil(size.height + heightInset)
        size.width = ceil(size.width + widthInset)
        return size
    }

    // MARK: - overriden methods

    open override func configure(view textView: TextView) {
        textView.textContainerInset = textContainerInset
        textView.textContainer.lineFragmentPadding = lineFragmentPadding
        textView.contentInset = contentInset
        textView.layoutMargins = layoutMargins
        config?(textView)
        textView.font = font
        switch text {
        case .unattributed(let text):
            textView.text = text
        case .attributed(let attributedText):
            textView.attributedText = attributedText
        }
    }

    open override var needsView: Bool {
        return true
    }
}

// MARK: - Things that belong in TextViewLayout but aren't because TextViewLayout is generic.
// "Static stored properties not yet supported in generic types"

private let defaultFont = UITextView().font ?? UIFont.systemFont(ofSize: 17)
private let defaultAlignment = Alignment.topLeading
private let defaultFlexibility = Flexibility.flexible
