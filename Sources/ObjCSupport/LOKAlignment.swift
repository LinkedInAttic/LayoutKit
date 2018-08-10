// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

/**
 Specifies how a layout positions itself inside of the rect that it is given to it by its parent during arrangement.
 */
@objc open class LOKAlignment: NSObject {
    let alignment: Alignment
    init(alignment: Alignment) {
        self.alignment = alignment
    }
    @objc public static let center = LOKAlignment(alignment: .center)
    @objc public static let fill = LOKAlignment(alignment: .fill)
    @objc public static let topCenter = LOKAlignment(alignment: .topCenter)
    @objc public static let topFill = LOKAlignment(alignment: .topFill)
    @objc public static let topLeading = LOKAlignment(alignment: .topLeading)
    @objc public static let topTrailing = LOKAlignment(alignment: .topTrailing)
    @objc public static let bottomCenter = LOKAlignment(alignment: .bottomCenter)
    @objc public static let bottomFill = LOKAlignment(alignment: .bottomFill)
    @objc public static let bottomLeading = LOKAlignment(alignment: .bottomLeading)
    @objc public static let bottomTrailing = LOKAlignment(alignment: .bottomTrailing)
    @objc public static let centerFill = LOKAlignment(alignment: Alignment(vertical: .center, horizontal: .fill))
    @objc public static let centerLeading = LOKAlignment(alignment: .centerLeading)
    @objc public static let centerTrailing = LOKAlignment(alignment: .centerTrailing)
    @objc public static let fillLeading = LOKAlignment(alignment: .fillLeading)
    @objc public static let fillTrailing = LOKAlignment(alignment: .fillTrailing)
    @objc public static let fillCenter = LOKAlignment(alignment: Alignment(vertical: .fill, horizontal: .center))
    @objc public static let aspectFit = LOKAlignment(alignment: .aspectFit)

    /**
     Positions a rect of the given size inside the given rect using the alignment spec.
     */
    @objc public func position(size: CGSize, in rect: CGRect) -> CGRect {
        return alignment.position(size: size, in: rect)
    }
}
