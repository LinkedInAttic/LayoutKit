// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

@objc open class LOKTextViewLayout: LOKBaseLayout {
    @objc public init(text: String? = nil,
                      font: UIFont? = nil,
                      lineFragmentPadding: CGFloat = 0,
                      textContainerInset: UIEdgeInsets = .zero,
                      layoutAlignment: LOKAlignment? = nil,
                      flexibility: LOKFlexibility? = nil,
                      viewReuseId: String? = nil,
                      viewClass: UITextView.Type? = nil,
                      configure: ((UITextView) -> Void)? = nil) {
        super.init(layout: TextViewLayout(
            text: text ?? "",
            font: font,
            lineFragmentPadding: lineFragmentPadding,
            textContainerInset: textContainerInset,
            layoutAlignment: layoutAlignment?.alignment ?? TextViewLayoutDefaults.defaultAlignment,
            flexibility: flexibility?.flexibility ?? TextViewLayoutDefaults.defaultFlexibility,
            viewReuseId: viewReuseId,
            viewClass: viewClass,
            config: configure))
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
        super.init(layout: TextViewLayout(
            attributedText: attributedText ?? NSAttributedString(),
            font: font,
            lineFragmentPadding: lineFragmentPadding,
            textContainerInset: textContainerInset,
            layoutAlignment: layoutAlignment?.alignment ?? TextViewLayoutDefaults.defaultAlignment,
            flexibility: flexibility?.flexibility ?? TextViewLayoutDefaults.defaultFlexibility,
            viewReuseId: viewReuseId,
            viewClass: viewClass,
            config: configure))
    }
}
