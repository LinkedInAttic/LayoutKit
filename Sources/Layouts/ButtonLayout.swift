// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/**
 Layout for a UIButton.

 Since UIKit does not provide threadsafe methods to determine the size of a button given its content
 it's implememtation hard-codes the current observed style of UIButton.
 If the style of UIButton changes in the future, then the current implementation will need to be updated to reflect the new style.

 If future-proofing is a concern for your application, then you should not use ButtonLayout and instead implement your own
 custom layout that uses you own custom button view (e.g. by subclassing UIControl).
 
 Similary, if you have your own custom button view, you will need to create your own custom layout for it.
 */
open class ButtonLayout<Button: UIButton>: BaseLayout<Button>, ConfigurableLayout {

    open let type: ButtonLayoutType
    open let title: Text
    open let image: ButtonLayoutImage
    open let font: UIFont?
    open let contentEdgeInsets: UIEdgeInsets

    public init(type: ButtonLayoutType,
                title: String, // TODO: support attributed text once we figure out how to get tests to pass
                image: ButtonLayoutImage = .defaultImage,
                font: UIFont? = nil,
                contentEdgeInsets: UIEdgeInsets? = nil,
                alignment: Alignment = ButtonLayoutDefaults.defaultAlignment,
                flexibility: Flexibility = ButtonLayoutDefaults.defaultFlexibility,
                viewReuseId: String? = nil,
                config: ((Button) -> Void)? = nil) {

        self.type = type
        self.title = .unattributed(title)
        self.image = image
        self.font = font
        self.contentEdgeInsets = contentEdgeInsets ?? ButtonLayout.defaultContentEdgeInsets(for: type, image: image)
        super.init(alignment: alignment, flexibility: flexibility, viewReuseId: viewReuseId, config: config)
    }

    init(type: ButtonLayoutType,
         title: String,
         image: ButtonLayoutImage = .defaultImage,
         font: UIFont? = nil,
         contentEdgeInsets: UIEdgeInsets? = nil,
         alignment: Alignment = ButtonLayoutDefaults.defaultAlignment,
         flexibility: Flexibility = ButtonLayoutDefaults.defaultFlexibility,
         viewReuseId: String? = nil,
         viewClass: Button.Type? = nil,
         config: ((UIButton) -> Void)? = nil) {

        self.type = type
        self.title = .unattributed(title)
        self.image = image
        self.font = font
        self.contentEdgeInsets = contentEdgeInsets ?? ButtonLayout.defaultContentEdgeInsets(for: type, image: image)
        super.init(alignment: alignment, flexibility: flexibility, viewReuseId: viewReuseId, viewClass: viewClass ?? Button.self, config: config)
    }

    private static func defaultContentEdgeInsets(for type: ButtonLayoutType, image: ButtonLayoutImage) -> UIEdgeInsets {
        switch type {
        case .custom, .detailDisclosure, .infoLight, .infoDark, .contactAdd:
            return .zero
        case .system:
            #if os(tvOS)
                if case .defaultImage = image {
                    return .zero
                }
                return UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
            #else
                return .zero
            #endif
        }
    }

    open func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        let imageSize = sizeOf(image: image)
        let titleSize = sizeOfTitle(within: maxSize)
        let width = max(minWidth, ceil(imageSize.width + titleSize.width + contentEdgeInsets.left + contentEdgeInsets.right))
        let height = ceil(max(imageSize.height, titleSize.height) + contentEdgeInsets.top + contentEdgeInsets.bottom + verticalPadding)
        let size = CGSize(width: width, height: height).decreasedToSize(maxSize)
        return LayoutMeasurement(layout: self, size: size, maxSize: maxSize, sublayouts: [])
    }

    /// Unlike UILabel, UIButton has nonzero height when the title is empty.
    private func sizeOfTitle(within maxSize: CGSize) -> CGSize {
        switch title {
        case .attributed(let text):
            if text.string.isEmpty && preserveHeightOfEmptyTitle {
                let attributedText = NSMutableAttributedString(attributedString: text)
                attributedText.mutableString.setString(" ")
                return CGSize(width: 0, height: sizeOf(text: .attributed(attributedText), maxSize: maxSize).height)
            } else {
                return sizeOf(text: title, maxSize: maxSize)
            }
        case .unattributed(let text):
            if text.isEmpty && preserveHeightOfEmptyTitle {
                return CGSize(width: 0, height: sizeOf(text: .unattributed(" "), maxSize: maxSize).height)
            } else {
                return sizeOf(text: title, maxSize: maxSize)
            }
        }
    }

    private var preserveHeightOfEmptyTitle: Bool {
        switch type {
        case .custom, .system:
            return true
        case .detailDisclosure, .infoLight, .infoDark, .contactAdd:
            return false
        }
    }

    private func sizeOf(text: Text, maxSize: CGSize) -> CGSize {
        return LabelLayout(text: text, font: fontForMeasurement, numberOfLines: 0).measurement(within: maxSize).size
    }

    /**
     The font that should be used to measure the button's title.
     This is based on observed behavior of UIButton.
     */
    private var fontForMeasurement: UIFont {
        switch type {
        case .custom:
            return font ?? defaultFontForCustomButton
        case .system:
            return font ?? defaultFontForSystemButton
        case .contactAdd, .infoLight, .infoDark, .detailDisclosure:
            // Setting a custom font has no effect in this case.
            return defaultFontForSystemButton
        }
    }

    private var defaultFontForCustomButton: UIFont {
        #if os(tvOS)
            return UIFont.systemFont(ofSize: 38, weight: UIFont.Weight.medium)
        #else
            return UIFont.systemFont(ofSize: 18)
        #endif
    }

    private var defaultFontForSystemButton: UIFont {
        #if os(tvOS)
            return UIFont.systemFont(ofSize: 38, weight: UIFont.Weight.medium)
        #else
            return UIFont.systemFont(ofSize: 15)
        #endif
    }

    private func sizeOf(image: ButtonLayoutImage) -> CGSize {
        switch image {
        case .size(let size):
            return size
        case .image(let image):
            return image?.size ?? .zero
        case .defaultImage:
            switch type {
            case .custom, .system:
                return .zero
            case .contactAdd, .infoLight, .infoDark, .detailDisclosure:
                #if os(tvOS)
                    return CGSize(width: 37, height: 46)
                #else
                    return CGSize(width: 22, height: 22)
                #endif
            }
        }
    }

    private var minWidth: CGFloat {
        switch type {
        case .custom, .system:
            return hasCustomStyle ? 0 : 30
        case .detailDisclosure, .infoLight, .infoDark, .contactAdd:
            return 0
        }
    }

    private var hasCustomStyle: Bool {
        return hasCustomImage || contentEdgeInsets != .zero
    }

    private var hasCustomImage: Bool {
        switch image {
        case .size, .image:
            return true
        case .defaultImage:
            return false
        }
    }

    private var verticalPadding: CGFloat {
        switch type {
        case .custom, .system:
            return hasCustomStyle ? 0 : 12
        case .detailDisclosure, .infoLight, .infoDark, .contactAdd:
            #if os(tvOS)
                return isTitleEmpty && !hasCustomImage ? -9 : 0
            #else
                return 0
            #endif
        }
    }

    private var isTitleEmpty: Bool {
        switch title {
        case .unattributed(let text):
            return text.isEmpty
        case .attributed(let text):
            return text.string.isEmpty
        }
    }

    open func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        let frame = alignment.position(size: measurement.size, in: rect)
        return LayoutArrangement(layout: self, frame: frame, sublayouts: [])
    }

    open override func makeView() -> View {
        return Button(type: type.buttonType)
    }

    open override func configure(view: Button) {
        config?(view)
        view.contentEdgeInsets = contentEdgeInsets

        if let font = font {
            view.titleLabel?.font = font
        }

        switch title {
        case .unattributed(let text):
            view.setTitle(text, for: .normal)
        case .attributed(let text):
            view.setAttributedTitle(text, for: .normal)
        }

        switch image {
        case .image(let image):
            view.setImage(image, for: .normal)
        case .size, .defaultImage:
            break
        }
    }

    open override var needsView: Bool {
        return true
    }
}

/**
 The image that appears on the button.
 */
public enum ButtonLayoutImage {
    /**
     Use the default image for the button type.
     (i.e. no image for .custom and .system, and the appropriate image for the other button types).
     */
    case defaultImage

    /**
     Specify the size of the image that will be set on the UIButton at a later point
     (e.g. if you are loading the image from network).
     */
    case size(CGSize)

    /**
     The image to set on the button for UIControlState.normal.
     You may configure the image for other states in the config block,
     but they should be the same size as this image.
     */
    case image(UIImage?)
}

/**
 Maps to UIButtonType.
 This prevents LayoutKit from breaking if a new UIButtonType is added.
 */
public enum ButtonLayoutType {
    case custom
    case system
    case detailDisclosure
    case infoLight
    case infoDark
    case contactAdd

    public var buttonType: UIButtonType {
        switch (self) {
        case .custom:
            return .custom
        case .system:
            return .system
        case .detailDisclosure:
            return .detailDisclosure
        case .infoLight:
            return .infoLight
        case .infoDark:
            return .infoDark
        case .contactAdd:
            return .contactAdd
        }
    }
}

public class ButtonLayoutDefaults {
    public static let defaultAlignment = Alignment.topLeading
    public static let defaultFlexibility = Flexibility.flexible
}

