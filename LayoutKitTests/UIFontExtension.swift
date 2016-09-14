// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

extension UIFont {

    /**
     Returns helvetica font.
     Layout tests should always explicitly specify a font so that sizes don't change if the default system font or font size changes.
     */
    static func helvetica(size: CGFloat = 17) -> UIFont {
        return UIFont(name: "Helvetica", size: size)!
    }

    static func helveticaNeue(size: CGFloat = 17) -> UIFont {
        return UIFont(name: "Helvetica Neue", size: size)!
    }
}
