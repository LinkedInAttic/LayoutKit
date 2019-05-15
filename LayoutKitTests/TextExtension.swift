// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit

extension Text {
    struct TestCase {
        let text: Text
        let font: UIFont?
    }

    static var testCases: [TestCase] {
        let fontNames: [String?] = [
            nil,
            "Helvetica",
            "Helvetica Neue"
        ]

        let texts: [Text] = [
            .unattributed(""),
            .unattributed(" "),
            .unattributed("Hi"),
            .unattributed("Hello world"),
            .unattributed("Hello! 😄😄😄"),
            .attributed(NSAttributedString(string: "")),
            .attributed(NSAttributedString(string: " ")),
            .attributed(NSAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.helvetica(size: 42)])),
            .attributed(NSAttributedString(string: " ", attributes: [NSAttributedString.Key.font: UIFont.helvetica(size: 42)])),
            .attributed(NSAttributedString(string: "Hi")),
            .attributed(NSAttributedString(string: "Hello world")),
            .attributed(NSAttributedString(string: "Hello! 😄😄😄")),
            .attributed(NSAttributedString(string: "Hello! 😄😄😄", attributes: [NSAttributedString.Key.font: UIFont.helvetica(size: 42)])),
            ]

        let fontSizes = 0...20

        var tests = [TestCase]()
        for fontName in fontNames {
            for fontSize in fontSizes {
                let font = fontName.flatMap({ (fontName) -> UIFont? in
                    return UIFont(name: fontName, size: CGFloat(fontSize))
                })
                for text in texts {
                    tests.append(TestCase(text: text, font: font))
                }
            }

        }
        return tests
    }
}
