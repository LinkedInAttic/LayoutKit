// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/**
 Layout for a `UIButton`.

 Since UIKit does not provide threadsafe methods to determine the size of a button given its content
 it's implememtation hard-codes the current observed style of `UIButton`.
 If the style of `UIButton` changes in the future, then the current implementation will need to be updated to reflect the new style.

 If future-proofing is a concern for your application, then you should not use `LOKButtonLayout` and instead implement your own
 custom layout that uses you own custom button view (e.g. by subclassing `UIControl`).

 Similary, if you have your own custom button view, you will need to create your own custom layout for it.
 */
@objc open class LOKButtonLayout: LOKBaseLayout {

    /**
     Button type for button layout.
     */
    @objc public let type: LOKButtonLayoutType

    /**
     Title for button layout.
     */
    @objc public let title: String

    /**
     Button image for button layout.
     */
    @objc public let image: UIImage?

    /**
     Size for button image.
     */
    @objc public let imageSize: CGSize

    /**
     Font for button layout.
     */
    @objc public let font: UIFont?

    /**
     Edge inset for button layout.
     */
    @objc public let contentEdgeInsets: NSValue?

    /**
     Specifies how this layout is positioned inside its parent layout.
     */
    @objc public let alignment: LOKAlignment

    /**
     Class object for the created view. Should be a subclass of `UIButton`.
     */
    @objc public let viewClass: UIButton.Type

    /**
     Layoutkit configuration block called with created `UIButton`
     */
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
