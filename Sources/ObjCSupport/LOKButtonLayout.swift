// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

@objc public class LOKButtonLayout: LOKBaseLayout {
    @objc public init(type: LOKButtonLayoutType,
                      title: String?,
                      image: UIImage?,
                      imageSize: CGSize,
                      font: UIFont? = nil,
                      contentEdgeInsets: NSValue?, // UIEdgeInsets
                      alignment: LOKAlignment? = nil,
                      flexibility: LOKFlexibility? = nil,
                      viewReuseId: String? = nil,
                      viewClass: UIButton.Type? = nil,
                      config: ((UIButton) -> Void)? = nil) {
        let insets: UIEdgeInsets?
        if let contentEdgeInsets = contentEdgeInsets {
            if contentEdgeInsets.objCType == NSValue(uiEdgeInsets: .zero).objCType {
                insets = contentEdgeInsets.uiEdgeInsetsValue
            } else {
                fatalError("wrong NSValue type passed to LOKButtonLayout contentEdgeInsets")
            }
        } else {
            insets = nil
        }
        let buttonLayoutImage: ButtonLayoutImage
        if let image = image {
            buttonLayoutImage = .image(image)
        } else if imageSize == .zero {
            buttonLayoutImage = .defaultImage
        } else {
            buttonLayoutImage = .size(imageSize)
        }
        let layout = ButtonLayout(
            type: type.unwrapped,
            title: title ?? "",
            image: buttonLayoutImage,
            font: font,
            contentEdgeInsets: insets,
            alignment: alignment?.alignment ?? ButtonLayoutDefaults.defaultAlignment,
            flexibility: flexibility?.flexibility ?? ButtonLayoutDefaults.defaultFlexibility,
            viewReuseId: viewReuseId,
            viewClass: viewClass,
            config: config)
        super.init(layout: layout)
    }
}
