// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

@objc open class LOKTextViewLayout: LOKBaseLayout {
    @objc public let attributedText: NSAttributedString?
    @objc public let text: String?
    @objc public let font: UIFont?
    @objc public let lineFragmentPadding: CGFloat
    @objc public let textContainerInset: UIEdgeInsets
    @objc public let layoutAlignment: LOKAlignment
    @objc public let viewClass: UITextView.Type
    @objc public let configure: ((UITextView) -> Void)?

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
