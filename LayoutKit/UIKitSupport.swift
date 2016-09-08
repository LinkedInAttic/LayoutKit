// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

public typealias View = UIView

public typealias EdgeInsets = UIEdgeInsets

public typealias UserInterfaceLayoutDirection = UIUserInterfaceLayoutDirection

extension UIView {

    func convertToAbsoluteCoordinates(rect: CGRect) -> CGRect {
        return convertRect(rect, toCoordinateSpace: UIScreen.mainScreen().fixedCoordinateSpace)
    }

    func convertFromAbsoluteCoordinates(rect: CGRect) -> CGRect {
        return convertRect(rect, fromCoordinateSpace: UIScreen.mainScreen().fixedCoordinateSpace)
    }

    var userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        if #available(iOS 9.0, *) {
            return UIView.userInterfaceLayoutDirectionForSemanticContentAttribute(semanticContentAttribute)
        } else {
            #if LAYOUTKIT_EXTENSION_SAFE
                // Not aware of any API that we can use on iOS 8.0 in an extension
                // that would allow us to know 
                #if LAYOUTKIT_EXTENSION_DEFAULT_RIGHT_TO_LEFT
                    return .rightToLeft
                #else
                    return .leftToRight
                #endif
            #else
                return UIApplication.sharedApplication().userInterfaceLayoutDirection
            #endif
        }
    }
}
