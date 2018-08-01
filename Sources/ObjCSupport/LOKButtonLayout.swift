// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

@objc open class LOKButtonLayout: LOKBaseLayout {
    @objc public let type: LOKButtonLayoutType
    @objc public let title: String
    @objc public let image: UIImage?
    @objc public let imageSize: CGSize
    @objc public let font: UIFont?
    @objc public let contentEdgeInsets: NSValue?
    @objc public let alignment: LOKAlignment
    @objc public let viewClass: UIButton.Type
    @objc public let config: ((UIButton) -> Void)?

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
        self.type = type
        self.title =  title ?? ""
        self.image = image
        self.imageSize = imageSize
        self.font = font
        self.contentEdgeInsets = contentEdgeInsets
        self.alignment = alignment ?? LOKAlignment(alignment: ButtonLayoutDefaults.defaultAlignment)
        self.viewClass = viewClass ?? UIButton.self
        self.config = config
        let layout = ButtonLayout(
            type: self.type.unwrapped,
            title: self.title,
            image: buttonLayoutImage,
            font: self.font,
            contentEdgeInsets: insets,
            alignment: self.alignment.alignment,
            flexibility: flexibility?.flexibility ?? ButtonLayoutDefaults.defaultFlexibility,
            viewReuseId: viewReuseId,
            viewClass: self.viewClass,
            config: self.config)
        super.init(layout: layout)
    }
}
