// Copyright 2016 LinkedIn Corp.
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
public struct Alignment {

    public static let center = Alignment(vertical: .center, horizontal: .center)
    public static let centerLeading = Alignment(vertical: .center, horizontal: .leading)
    public static let centerTrailing = Alignment(vertical: .center, horizontal: .trailing)

    public static let fill = Alignment(vertical: .fill, horizontal: .fill)
    public static let fillLeading = Alignment(vertical: .fill, horizontal: .leading)
    public static let fillTrailing = Alignment(vertical: .fill, horizontal: .trailing)

    public static let topLeading = Alignment(vertical: .top, horizontal: .leading)
    public static let topTrailing = Alignment(vertical: .top, horizontal: .trailing)
    public static let topCenter = Alignment(vertical: .top, horizontal: .center)
    public static let topFill = Alignment(vertical: .top, horizontal: .fill)

    public static let bottomLeading = Alignment(vertical: .bottom, horizontal: .leading)
    public static let bottomTrailing = Alignment(vertical: .bottom, horizontal: .trailing)
    public static let bottomCenter = Alignment(vertical: .bottom, horizontal: .center)
    public static let bottomFill = Alignment(vertical: .bottom, horizontal: .fill)

    /// Scales down a size to fit inside of a rect while maintaining the original aspect ratio.
    /// The scaled down size is then centered in the available space.
    public static let aspectFit = Alignment(aligner: { (size: CGSize, rect: CGRect) -> CGRect in
        let sizeRatio = size.width / size.height
        let rectRatio = rect.size.width / rect.size.height

        let scaledSize: CGSize
        if rectRatio > sizeRatio {
            scaledSize = CGSize(width: rect.size.height * sizeRatio, height: rect.size.height)
        } else {
            scaledSize = CGSize(width: rect.size.width, height: rect.size.width / sizeRatio)
        }
        return Alignment.center.position(size: scaledSize, in: rect)
    })

    /// Alignment behavior along the vertical dimension.
    public enum Vertical {
        
        /// The layout is aligned to the top edge.
        case top

        /// The layout is aligned to the bottom edge.
        case bottom

        /// The layout is centered in the available vertical space.
        case center

        /// The layout's height is set to be equal to the available height.
        case fill

        public func align(length: CGFloat, availableLength: CGFloat, offset: CGFloat) -> (offset: CGFloat, length: CGFloat) {
            // To avoid implementing the math twice, we just convert to a horizontal alignment and call its apply method.
            let horizontal: Horizontal
            switch self {
            case .top:
                horizontal = .leading
            case .bottom:
                horizontal = .trailing
            case .center:
                horizontal = .center
            case .fill:
                horizontal = .fill
            }
            return horizontal.align(length: length, availableLength: availableLength, offset: offset)
        }
    }

    /// Alignment behavior along the horizontal dimension.
    public enum Horizontal {

        /// The layout is aligned to the leading edge (left for left-to-right languages and right for right-to-left languages).
        case leading

        /// The layout is aligned to the trailing edge (right for left-to-right languages and left for right-to-left languages).
        case trailing

        /// The layout is centered in the available horizontal space.
        case center

        /// The layout's width is set to be equal to the available width.
        case fill

        public func align(length: CGFloat, availableLength: CGFloat, offset: CGFloat) -> (offset: CGFloat, length: CGFloat) {
            let excessLength = availableLength - length
            let clampedLength = min(availableLength, length)
            let alignedLength: CGFloat
            let alignedOffset: CGFloat
            switch self {
            case .leading:
                alignedOffset = 0
                alignedLength = clampedLength
            case .trailing:
                alignedOffset = excessLength
                alignedLength = clampedLength
            case .center:
                alignedOffset = excessLength / 2.0
                alignedLength = clampedLength
            case .fill:
                alignedOffset = 0
                alignedLength = availableLength
            }
            return (offset + alignedOffset, alignedLength)
        }
    }

    /// A function that aligns size in rect.
    public typealias Aligner = (_ size: CGSize, _ rect: CGRect) -> CGRect

    private let aligner: Aligner

    public init(aligner: @escaping Aligner) {
        self.aligner = aligner
    }
    
    public init(vertical: Vertical, horizontal: Horizontal) {
        self.aligner = { (size: CGSize, rect: CGRect) -> CGRect in
            let (x, width) = horizontal.align(length: size.width, availableLength: rect.width, offset: rect.origin.x)
            let (y, height) = vertical.align(length: size.height, availableLength: rect.height, offset: rect.origin.y)
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }

    /// Positions a rect of the given size inside the given rect using the alignment spec.
    public func position(size: CGSize, in rect: CGRect) -> CGRect {
        return aligner(size, rect)
    }
}
