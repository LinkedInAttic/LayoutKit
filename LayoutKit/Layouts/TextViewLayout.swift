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
        var size = TextCalculatorHelper.textSize(maxSize: maxSize, text: text, font: font)

        let heightInset = (textContainerInset.top + textContainerInset.bottom) + (layoutMargins.top + layoutMargins.bottom)
        let widthInset = (textContainerInset.left + textContainerInset.right) + (layoutMargins.left + layoutMargins.right) + lineFragmentPadding * 2
            + (contentInset.left + contentInset.right)
        size = CGSize(width: size.width + widthInset, height: size.height + heightInset)

        return size
    }

    // MARK: - overriden methods

    /// Don't change `textContainerInset`, `lineFragmentPadding`, `contentInset`
    /// and `layoutMargins` in `configure`. By changing those, it will cause the incorrect
    /// size calculation. So they will be reset by using parameters from initializer.
    /// `usesFontLeading` doesn't support in `TextViewLayout`.
    open override func configure(view textView: TextView) {
        config?(textView)
        textView.textContainerInset = textContainerInset
        textView.textContainer.lineFragmentPadding = lineFragmentPadding
        textView.contentInset = contentInset
        textView.layoutMargins = layoutMargins
        textView.layoutManager.usesFontLeading = false
        textView.font = font
        switch text {
        case .unattributed(let text):
            textView.text = text
        case .attributed(let attributedText):
            textView.attributedText = attributedText
        }
    }

    open override var needsView: Bool {
        switch text {
        case .attributed(let attributedText):
            if attributedText.length == 0 {
                return false
            }
        case .unattributed(let text):
            if text.isEmpty {
                return false
            }
        }

        return true
    }
}

// MARK: - Things that belong in TextViewLayout but aren't because TextViewLayout is generic.
// "Static stored properties not yet supported in generic types"

// Since the `UITextView` will return different font for different iOS/tvOS version,
// we give a fixed default font here
private let defaultFont = UIFont.systemFont(ofSize: 12)
private let defaultAlignment = Alignment.topLeading
private let defaultFlexibility = Flexibility.flexible
