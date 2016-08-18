// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

/**
 A layout that has size constraints.
 
 # Default behavior

 Alignment along a dimension defaults to .fill if there is no maximum constraint along that dimension and .center otherwise.

 Flexibility along a dimension defaults to .inflexible if there is an exact constraint on that dimension, and .defaultFlex otherwise.

 # Constraint precedence

 Constraints are enforced with the following precedence:
 1. The maxSize paremeter of measurement.
 2. The SizeLayout's maxSize
 3. The SizeLayout's minSize
 
 In other words, if it is impossible to satisfy all constraints simultaneously then
 constraints are broken starting with minSize.

 # Use cases

 Some common use cases:

 ```
 // A fixed size UIImageView.
 SizeLayout<UIImageView>(width: 50, height: 50)

 // A 1px tall divider that fills the width of its parent.
 SizeLayout<UIView>(height: 1)

 // A label with maximum width.
 SizeLayout<UIView>(maxWidth: 100, sublayout: LabelLayout(text: "Spills onto two lines"))

 // A label with minimum width.
 SizeLayout<UIView>(minWidth: 100, sublayout: LabelLayout(text: "Hello", alignment: .fill))
 ```
*/
public class SizeLayout<V: View>: BaseLayout<V>, ConfigurableLayout {

    public let minWidth: CGFloat?
    public let maxWidth: CGFloat?
    public let minHeight: CGFloat?
    public let maxHeight: CGFloat?
    public let sublayout: Layout?

    public init(minWidth: CGFloat? = nil,
                maxWidth: CGFloat? = nil,
                minHeight: CGFloat? = nil,
                maxHeight: CGFloat? = nil,
                alignment: Alignment? = nil,
                flexibility: Flexibility? = nil,
                viewReuseId: String? = nil,
                sublayout: Layout? = nil,
                config: (V -> Void)? = nil) {

        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.sublayout = sublayout
        let alignment = alignment ?? SizeLayout.defaultAlignment(maxWidth: maxWidth, maxHeight: maxHeight)
        let flexibility = flexibility ?? SizeLayout.defaultFlexibility(minWidth: minWidth,
                                                                       maxWidth: maxWidth,
                                                                       minHeight: minHeight,
                                                                       maxHeight: maxHeight)
        super.init(alignment: alignment, flexibility: flexibility, viewReuseId: viewReuseId, config: config)
    }

    public convenience init(width: CGFloat,
                            height: CGFloat,
                            alignment: Alignment? = nil,
                            flexibility: Flexibility? = nil,
                            viewReuseId: String? = nil,
                            sublayout: Layout? = nil,
                            config: (V -> Void)? = nil) {

        self.init(minWidth: width,
                  maxWidth: width,
                  minHeight: height,
                  maxHeight: height,
                  alignment: alignment,
                  flexibility: flexibility,
                  viewReuseId: viewReuseId,
                  sublayout: sublayout,
                  config: config)
    }

    public convenience init(width: CGFloat,
                            minHeight: CGFloat? = nil,
                            maxHeight: CGFloat? = nil,
                            alignment: Alignment? = nil,
                            flexibility: Flexibility? = nil,
                            viewReuseId: String? = nil,
                            sublayout: Layout? = nil,
                            config: (V -> Void)? = nil) {

        self.init(minWidth: width,
                  maxWidth: width,
                  minHeight: minHeight,
                  maxHeight: maxHeight,
                  alignment: alignment,
                  flexibility: flexibility,
                  viewReuseId: viewReuseId,
                  sublayout: sublayout,
                  config: config)
    }

    public convenience init(height: CGFloat,
                            minWidth: CGFloat? = nil,
                            maxWidth: CGFloat? = nil,
                            alignment: Alignment? = nil,
                            flexibility: Flexibility? = nil,
                            viewReuseId: String? = nil,
                            sublayout: Layout? = nil,
                            config: (V -> Void)? = nil) {

        self.init(minWidth: minWidth,
                  maxWidth: maxWidth,
                  minHeight: height,
                  maxHeight: height,
                  alignment: alignment,
                  flexibility: flexibility,
                  viewReuseId: viewReuseId,
                  sublayout: sublayout,
                  config: config)
    }

    public convenience init(size: CGSize,
                            alignment: Alignment? = nil,
                            flexibility: Flexibility? = nil,
                            viewReuseId: String? = nil,
                            sublayout: Layout? = nil,
                            config: (V -> Void)? = nil) {

        self.init(width: size.width,
                  height: size.height,
                  alignment: alignment,
                  flexibility: flexibility,
                  viewReuseId: viewReuseId,
                  sublayout: sublayout,
                  config: config)
    }

    public convenience init(maxSize: CGSize,
                            alignment: Alignment? = nil,
                            flexibility: Flexibility? = nil,
                            viewReuseId: String? = nil,
                            sublayout: Layout? = nil,
                            config: (V -> Void)? = nil) {

        self.init(maxWidth: maxSize.width,
                  maxHeight: maxSize.height,
                  alignment: alignment,
                  flexibility: flexibility,
                  viewReuseId: viewReuseId,
                  sublayout: sublayout,
                  config: config)
    }

    public convenience init(minSize: CGSize,
                            alignment: Alignment? = nil,
                            flexibility: Flexibility? = nil,
                            viewReuseId: String? = nil,
                            sublayout: Layout? = nil,
                            config: (V -> Void)? = nil) {

        self.init(minWidth: minSize.width,
                  minHeight: minSize.height,
                  alignment: alignment,
                  flexibility: flexibility,
                  viewReuseId: viewReuseId,
                  sublayout: sublayout,
                  config: config)
    }

    private static func defaultAlignment(maxWidth maxWidth: CGFloat?, maxHeight: CGFloat?) -> Alignment {
        return Alignment(vertical: maxHeight == nil ? .fill : .center,
                         horizontal: maxWidth == nil ? .fill : .center)
    }

    private static func defaultFlexibility(minWidth minWidth: CGFloat?,
                                                    maxWidth: CGFloat?,
                                                    minHeight: CGFloat?,
                                                    maxHeight: CGFloat?) -> Flexibility {
        let horizontal = dimensionFlex(min: minWidth, max: maxWidth)
        let vertical = dimensionFlex(min: minHeight, max: maxHeight)
        return Flexibility(horizontal: horizontal, vertical: vertical)
    }

    /// If we have an exact constraint on a dimension then it is inflexible.
    /// Otherwise, it has default flex.
    private static func dimensionFlex(min min: CGFloat?, max: CGFloat?) -> Flexibility.Flex {
        return equals(min, max) ? Flexibility.inflexibleFlex : Flexibility.defaultFlex
    }

    /// Returns true if left and right are equal within a small tolerance.
    /// A nil value is not equal to anything else.
    private static func equals(left: CGFloat?, _ right: CGFloat?) -> Bool {
        guard let left = left, right = right else {
            // treat nil != nil
            return false
        }
        return abs(left - right) < 0.0001
    }

    public func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        // Take the smaller of our configured max size and the given max size for measurement.
        let availableSize = maxSize.decreasedToSize(CGSize(width: maxWidth ?? .max, height: maxHeight ?? .max))

        // Measure the sublayout if it exists.
        let sublayoutMeasurement = sublayout?.measurement(within: availableSize)
        let sublayoutSize = sublayoutMeasurement?.size ?? CGSizeZero

        // Make sure that our size is in the desired range.
        let size = sublayoutSize.increasedToSize(CGSize(width: minWidth ?? 0, height: minHeight ?? 0)).decreasedToSize(availableSize)

        let sublayouts = sublayoutMeasurement.map { (measurement) in
            return [measurement]
        }
        return LayoutMeasurement(layout: self, size: size, maxSize: maxSize, sublayouts: sublayouts ?? [])
    }

    public func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        let frame = alignment.position(size: measurement.size, in: rect)
        let sublayoutRect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let sublayouts = measurement.sublayouts.map { (measurement) in
            return measurement.arrangement(within: sublayoutRect)
        }
        return LayoutArrangement(layout: self, frame: frame, sublayouts: sublayouts ?? [])
    }
}
