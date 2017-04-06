// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
import LayoutKit

class ButtonLayoutTests: XCTestCase {

    func testNeedsView() {
        let b = ButtonLayout(type: .custom, title: "Hi").arrangement().makeViews()
        XCTAssertNotNil(b as? UIButton)
    }

    func testButtonLayouts() {
        let types: [ButtonLayoutType] = [
            .custom,
            .system,
            .detailDisclosure,
            .infoDark,
            .infoLight,
            .contactAdd,
        ]

        let images: [ButtonLayoutImage] = [
            .defaultImage,
            .size(CGSize(width: 1, height: 1)),
            .size(CGSize(width: 5, height: 5)),
            .size(CGSize(width: 10, height: 10)),
            .size(CGSize(width: 20, height: 20)),
        ]

        let contentInsets: [UIEdgeInsets] = [
            .zero,
            UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1),
            UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40), // default for tvOS system buttons
        ]

        for textTestCase in Text.testCases {
            for type in types {
                for image in images {
                    for contentInset in contentInsets {
                        verifyButtonLayout(textTestCase: textTestCase, type: type, image: image, contentEdgeInsets: contentInset)
                    }
                }
            }
        }
    }

    private func verifyButtonLayout(textTestCase: Text.TestCase, type: ButtonLayoutType, image: ButtonLayoutImage, contentEdgeInsets: UIEdgeInsets) {
        guard case .unattributed(let title) = textTestCase.text else {
            // TODO: ButtonLayout doesn't currently support attributed text.
            // If/when it does, remove this guard.
            return
        }
        let button = UIButton(type: type.buttonType)
        button.contentEdgeInsets = contentEdgeInsets
        if let font = textTestCase.font {
            button.titleLabel?.font = font
        }

        switch textTestCase.text {
        case .unattributed(let text):
            button.setTitle(text, for: .normal)
        case .attributed(let text):
            button.setAttributedTitle(text, for: .normal)
        }

        switch image {
        case .image(let image):
            button.setImage(image, for: .normal)
        case .size(let size):
            if let image = imageOfSize(size) {
                button.setImage(image, for: .normal)
            }
        case .defaultImage:
            break
        }

        let layout = textTestCase.font.map({ (font: UIFont) -> Layout in
            return ButtonLayout(type: type, title: title, image: image, font: font, contentEdgeInsets: contentEdgeInsets)
        }) ?? ButtonLayout(type: type, title: title, image: image, contentEdgeInsets: contentEdgeInsets)

        XCTAssertEqual(
            layout.arrangement().frame.size,
            button.intrinsicContentSize,
            "fontName:\(String(describing: textTestCase.font?.fontName)) title:'\(textTestCase.text)' image:\(image) fontSize:\(String(describing: textTestCase.font?.pointSize)) type:\(type) contentEdgeInsets:\(contentEdgeInsets)")
    }

    private func imageOfSize(_ size: CGSize) -> UIImage? {
        if size == .zero {
            return nil
        }
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        UIColor.black.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIView {

    var recursiveDescription: String {
        var lines = [description]
        for subview in subviews {
            lines.append("  | \(subview.recursiveDescription)")
        }
        return lines.joined(separator: "\n")
    }
}
