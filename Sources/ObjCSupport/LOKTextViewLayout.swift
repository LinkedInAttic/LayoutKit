// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/**
 Layout for a `UITextView`.
 */
@objc open class LOKTextViewLayout: LOKBaseLayout {

    /**
     `NSAttributedString` for textView's text.
     */
    @objc public let attributedText: NSAttributedString?

    /**
     `NSString` for textView's text.
     */
    @objc public let text: String?

    /**
     Font for text layout.
     */
    @objc public let font: UIFont?

    /**
     Line padding between text container and actual text in text layout.
     */
    @objc public let lineFragmentPadding: CGFloat

    /**
     EdgeInsets for text layout.
     */
    @objc public let textContainerInset: UIEdgeInsets

    /**
     Specifies how this layout is positioned inside its parent layout.
     */
    @objc public let layoutAlignment: LOKAlignment

    /**
     Class object for the created view. Should be a subclass of `UITextView`.
     */
    @objc public let viewClass: UITextView.Type

    /**
     LayoutKit configuration block called with created `UITextView`.
     */
    @objc public let configure: ((UITextView) -> Void)?

    /**
     Don't change `textContainerInset`, `lineFragmentPadding` in `configure` closure that's passed to init.
     By changing those, it will cause the Layout's size calculation to be incorrect. So they will be reset by using parameters from initializer.
     */
    @objc public init(text: String? = nil,
                      font: UIFont? = nil,
                      lineFragmentPadding: CGFloat = 0,
                      textContainerInset: UIEdgeInsets = .zero,
                      layoutAlignment: LOKAlignment? = nil,
                      flexibility: LOKFlexibility? = nil,
                      viewReuseId: String? = nil,
                      viewClass: UITextView.Type? = nil,
                      configure: ((UITextView) -> Void)? = nil) {
        self.text = text ?? ""
        self.attributedText = nil
        self.font = font
        self.lineFragmentPadding = lineFragmentPadding
        self.textContainerInset = textContainerInset
        self.layoutAlignment = layoutAlignment ?? LOKAlignment(alignment: TextViewLayoutDefaults.defaultAlignment)
        self.viewClass = viewClass ?? UITextView.self
        self.configure = configure
        super.init(layout: TextViewLayout(
            text: self.text ?? "",
            font: self.font,
            lineFragmentPadding: self.lineFragmentPadding,
            textContainerInset: self.textContainerInset,
            layoutAlignment: self.layoutAlignment.alignment,
            flexibility: flexibility?.flexibility ?? TextViewLayoutDefaults.defaultFlexibility,
            viewReuseId: viewReuseId,
            viewClass: self.viewClass,
            config: self.configure))
    }

    @objc public init(attributedText: NSAttributedString? = nil,
                      font: UIFont? = nil,
                      lineFragmentPadding: CGFloat = 0,
                      textContainerInset: UIEdgeInsets = .zero,
                      layoutAlignment: LOKAlignment? = nil,
                      flexibility: LOKFlexibility? = nil,
                      viewReuseId: String? = nil,
                      viewClass: UITextView.Type? = nil,
                      configure: ((UITextView) -> Void)? = nil) {
        self.text = nil
        self.attributedText = attributedText ?? NSAttributedString()
        self.font = font
        self.lineFragmentPadding = lineFragmentPadding
        self.textContainerInset = textContainerInset
        self.layoutAlignment = layoutAlignment ?? LOKAlignment(alignment: TextViewLayoutDefaults.defaultAlignment)
        self.viewClass = viewClass ?? UITextView.self
        self.configure = configure
        super.init(layout: TextViewLayout(
            attributedText: self.attributedText ?? NSAttributedString(),
            font: self.font,
            lineFragmentPadding: self.lineFragmentPadding,
            textContainerInset: self.textContainerInset,
            layoutAlignment: self.layoutAlignment.alignment,
            flexibility: flexibility?.flexibility ?? TextViewLayoutDefaults.defaultFlexibility,
            viewReuseId: viewReuseId,
            viewClass: self.viewClass,
            config: self.configure))
    }
}
