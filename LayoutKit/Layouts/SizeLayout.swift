// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

/**
 A layout that measures to a predetermined size.

 Some common use cases:

 ```
 // A fixed size UIImageView.
 SizeLayout<UIImageView>(width: 50, height: 50)
 
 // A 1px tall divider that fills the width of its parent.
 SizeLayout<UIView>(height: 1)
 
 // A fixed height label.
 SizeLayout<UIView>(height: 50, sublayout: LabelLayout(text: "Hello"))
 ```
*/
public class SizeLayout<V: View>: PositioningLayout<V>, Layout {

    public let width: CGFloat?
    public let height: CGFloat?
    public let alignment: Alignment
    public let flexibility: Flexibility
    public let sublayout: Layout?

    /**
     Creates a SizeLayout that measures to a specific width and/or height.
     
     If a dimension is nil, then
     - The measurement along that dimension is inherited from the sublayout, or zero if there is no sublayout.
     - The alignment along that dimension defaults to .fill.
     - The flexiblity along that dimension defaults to .defaultFlex.

     If a dimension is not nil, then
     - The alignment along that dimension defaults to .center.
     - The flexibility along that dimension defaults to .inflexible.
     */
    public init(width: CGFloat? = nil,
                height: CGFloat? = nil,
                alignment: Alignment? = nil,
                flexibility: Flexibility? = nil,
                sublayout: Layout? = nil,
                config: (V -> Void)? = nil) {

        self.width = width
        self.height = height
        self.alignment = alignment ?? SizeLayout.defaultAlignment(width: width, height: height)
        self.flexibility = flexibility ?? SizeLayout.defaultFlexibility(width: width, height: height)
        self.sublayout = sublayout
        super.init(config: config)
    }

    private static func defaultAlignment(width width: CGFloat?, height: CGFloat?) -> Alignment {
        return Alignment(vertical: height == nil ? .fill : .center,
                         horizontal: width == nil ? .fill : .center)
    }

    private static func defaultFlexibility(width width: CGFloat?, height: CGFloat?) -> Flexibility {
        return Flexibility(horizontal: width == nil ? Flexibility.defaultFlex : Flexibility.inflexibleFlex,
                           vertical: height == nil ? Flexibility.defaultFlex : Flexibility.inflexibleFlex)
    }
    
    /**
     Creates a SizeLayout that measures to the provided size.
     By default it centers itself the available space and is inflexible.
     */
    public convenience init(size: CGSize,
                alignment: Alignment? = nil,
                flexibility: Flexibility? = nil,
                sublayout: Layout? = nil,
                config: (V -> Void)? = nil) {

        self.init(width: size.width,
                  height: size.height,
                  alignment: alignment,
                  flexibility: flexibility,
                  sublayout: sublayout,
                  config: config)
    }

    public func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        let size = CGSize(width: width ?? .max, height: height ?? .max)
        var constrainedSize = size.sizeDecreasedToSize(maxSize)

        // If at least one dimension is nil, then we need to measure the sublayout to inherit its value (zero if there is no sublayout).
        if width == nil || height == nil {
            let subsize = sublayout?.measurement(within: constrainedSize).size ?? CGSizeZero
            if width == nil {
                constrainedSize.width = subsize.width
            }
            if height == nil {
                constrainedSize.height = subsize.height
            }
        }

        return LayoutMeasurement(layout: self, size: constrainedSize, maxSize: maxSize, sublayouts: [])
    }

    public func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        let frame = alignment.position(size: measurement.size, inRect: rect)
        let sublayouts = sublayout.map { layout in
            return [layout.arrangement(width: frame.size.width, height: frame.size.height)]
        }
        return LayoutArrangement(layout: self, frame: frame, sublayouts: sublayouts ?? [])
    }
}