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

    public let text: Text
    public let font: UIFont?
    public let textContainerInset: UIEdgeInsets
    public let lineFragmentPadding: CGFloat

    private let isTextEmpty: Bool

    // MARK: - initializers

    /// Don't change `textContainerInset`, `lineFragmentPadding` and `usesFontLeading` in `configure` closure that's passed to init.
    /// By changing those, it will cause the Layout's size calculation to be incorrect. So they will be reset by using parameters from initializer.
    /// `TextViewLayout` sets `usesFontLeading = false`, `isScrollEnabled = false` by the default. Don't override those values.
    public init(text: Text,
                font: UIFont? = nil,
                lineFragmentPadding: CGFloat = 0,
                textContainerInset: UIEdgeInsets = .zero,
                layoutAlignment: Alignment = TextViewLayoutDefaults.defaultAlignment,
                flexibility: Flexibility = TextViewLayoutDefaults.defaultFlexibility,
                viewReuseId: String? = nil,
                config: ((TextView) -> Void)? = nil) {
        self.text = text
        self.font = font
        self.lineFragmentPadding = lineFragmentPadding
        self.textContainerInset = textContainerInset

        switch text {
        case .attributed(let attributedText):
            self.isTextEmpty = attributedText.length == 0
        case .unattributed(let text):
            self.isTextEmpty = text.isEmpty
        }

        super.init(alignment: layoutAlignment, flexibility: flexibility, viewReuseId: viewReuseId, config: config)
    }

    // MARK: - Convenience initializers

    public convenience init(text: String,
                            font: UIFont? = nil,
                            lineFragmentPadding: CGFloat = 0,
                            textContainerInset: UIEdgeInsets = .zero,
                            layoutAlignment: Alignment = TextViewLayoutDefaults.defaultAlignment,
                            flexibility: Flexibility = TextViewLayoutDefaults.defaultFlexibility,
                            viewReuseId: String? = nil,
                            config: ((TextView) -> Void)? = nil) {
        self.init(text: .unattributed(text),
                  font: font,
                  lineFragmentPadding: lineFragmentPadding,
                  textContainerInset: textContainerInset,
                  layoutAlignment: layoutAlignment,
                  flexibility: flexibility,
                  viewReuseId: viewReuseId,
                  config: config)
    }

    public convenience init(attributedText: NSAttributedString,
                            font: UIFont? = nil,
                            lineFragmentPadding: CGFloat = 0,
                            textContainerInset: UIEdgeInsets = .zero,
                            layoutAlignment: Alignment = TextViewLayoutDefaults.defaultAlignment,
                            flexibility: Flexibility = TextViewLayoutDefaults.defaultFlexibility,
                            viewReuseId: String? = nil,
                            config: ((TextView) -> Void)? = nil) {
        self.init(
            text: .attributed(attributedText),
            font: font,
            lineFragmentPadding: lineFragmentPadding,
            textContainerInset: textContainerInset,
            layoutAlignment: layoutAlignment,
            flexibility: flexibility,
            viewReuseId: viewReuseId,
            config: config)
    }

    convenience init(text: String,
                     font: UIFont? = nil,
                     lineFragmentPadding: CGFloat = 0,
                     textContainerInset: UIEdgeInsets = .zero,
                     layoutAlignment: Alignment = TextViewLayoutDefaults.defaultAlignment,
                     flexibility: Flexibility = TextViewLayoutDefaults.defaultFlexibility,
                     viewReuseId: String? = nil,
                     viewClass: TextView.Type? = nil,
                     config: ((TextView) -> Void)? = nil) {
        self.init(
            text: .unattributed(text),
            font: font,
            lineFragmentPadding: lineFragmentPadding,
            textContainerInset: textContainerInset,
            layoutAlignment: layoutAlignment,
            flexibility: flexibility,
            viewReuseId: viewReuseId,
            viewClass: viewClass,
            config: config)
    }

    convenience init(attributedText: NSAttributedString,
                     font: UIFont? = nil,
                     lineFragmentPadding: CGFloat = 0,
                     textContainerInset: UIEdgeInsets = .zero,
                     layoutAlignment: Alignment = TextViewLayoutDefaults.defaultAlignment,
                     flexibility: Flexibility = TextViewLayoutDefaults.defaultFlexibility,
                     viewReuseId: String? = nil,
                     viewClass: TextView.Type? = nil,
                     config: ((TextView) -> Void)? = nil) {
        self.init(
            text: .attributed(attributedText),
            font: font,
            lineFragmentPadding: lineFragmentPadding,
            textContainerInset: textContainerInset,
            layoutAlignment: layoutAlignment,
            flexibility: flexibility,
            viewReuseId: viewReuseId,
            viewClass: viewClass,
            config: config)
    }

    init(text: Text,
         font: UIFont? = nil,
         lineFragmentPadding: CGFloat = 0,
         textContainerInset: UIEdgeInsets = .zero,
         layoutAlignment: Alignment = TextViewLayoutDefaults.defaultAlignment,
         flexibility: Flexibility = TextViewLayoutDefaults.defaultFlexibility,
         viewReuseId: String? = nil,
         viewClass: TextView.Type? = nil,
         config: ((TextView) -> Void)? = nil) {
        self.text = text
        self.font = font
        self.lineFragmentPadding = lineFragmentPadding
        self.textContainerInset = textContainerInset

        switch text {
        case .attributed(let attributedText):
            self.isTextEmpty = attributedText.length == 0
        case .unattributed(let text):
            self.isTextEmpty = text.isEmpty
        }

        super.init(alignment: layoutAlignment, flexibility: flexibility, viewReuseId: viewReuseId, viewClass: viewClass ?? TextView.self, config: config)
    }

    // MARK: - Layout protocol

    open func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        let fittedSize = textSize(within: maxSize)
        let decreasedToSize = fittedSize.decreasedToSize(maxSize)
        return LayoutMeasurement(layout: self, size: decreasedToSize, maxSize: maxSize, sublayouts: [])
    }

    open func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        let frame = alignment.position(size: measurement.size, in: rect)
        return LayoutArrangement(layout: self, frame: frame, sublayouts: [])
    }

    // MARK: - private helpers

    private func textSize(within maxSize: CGSize) -> CGSize {
        var insetMaxSize = maxSize.decreased(by: textContainerInset)
        insetMaxSize.width -= lineFragmentPadding * 2

        let size = isTextEmpty
            ? text.textSizeWithEmptyText(within: insetMaxSize, font: font ?? TextViewLayout.defaultFont(withText: text))
            : text.textSize(within: insetMaxSize, font: font ?? TextViewLayout.defaultFont(withText: text))

        var textSize = size.increased(by: textContainerInset)
        textSize.width += lineFragmentPadding * 2
        return textSize
    }

    private static func defaultFont(withText text: Text) -> UIFont {
        switch text {
        case .unattributed(_):
            return TextViewDefaultFont.unattributedTextFont
        case .attributed(let attributedText):
            return attributedText.length == 0
                ? TextViewDefaultFont.attributedTextFontWithEmptyString
                : TextViewDefaultFont.attributedTextFont
        }
    }

    // MARK: - overriden methods

    open override func configure(view textView: TextView) {
        super.configure(view: textView)
        textView.textContainerInset = textContainerInset
        textView.textContainer.lineFragmentPadding = lineFragmentPadding
        textView.layoutManager.usesFontLeading = false
        textView.isScrollEnabled = false
        // tvOS doesn't support `isEditable`
        #if !os(tvOS)
            textView.isEditable = false
        #endif
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

private extension Text {

    /// By the default behavior of `UITextView`, it will give a height for an empty text
    /// For the measurement, we can measure a space string to match the default behavior
    func textSizeWithEmptyText(within maxSize: CGSize, font: UIFont) -> CGSize {
        let spaceString = " "

        let size: CGSize
        switch self {
        case .attributed(_):
            let text = Text.attributed(NSAttributedString(
                string: spaceString,
                attributes: [NSAttributedString.Key.font: font]))
            size = text.textSize(within: maxSize, font: font)

        case .unattributed(_):
            let text = Text.unattributed(spaceString)
            size = text.textSize(within: maxSize, font: font)
        }

        return CGSize(width: 0, height: size.height)
    }
}

// MARK: - Things that belong in TextViewLayout but aren't because TextViewLayout is generic.
// "Static stored properties not yet supported in generic types"

public class TextViewLayoutDefaults {
    public static let defaultAlignment = Alignment.topLeading
    public static let defaultFlexibility = Flexibility.flexible
}

