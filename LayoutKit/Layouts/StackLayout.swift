// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

/**
 A layout that stacks sublayouts along an axis.
 
 Axis space is allocated to sublayouts according to the distribution policy.
 
 If this not enough space along the axis for all sublayouts then layouts with the highest flexibility are removed
 until there is enough space to posistion the remaining layouts.
 */
public class StackLayout: PositioningLayout<View> {

    /// The axis along which sublayouts are stacked.
    public let axis: Axis

    /**
     The distance in points between adjacent edges of sublayouts along the axis.
     For Distribution.EqualSpacing, this is a minimum spacing. For all other distributions it is an exact spacing.
     */
    public let spacing: CGFloat

    /// The distribution of space along the stack's axis.
    public let distribution: Distribution

    /// The stack's alignment inside its parent.
    public let alignment: Alignment

    /// The stack's flexibility.
    public let flexibility: Flexibility
    
    /// The stacked layouts.
    public let sublayouts: [Layout]

    public init(axis: Axis,
                spacing: CGFloat = 0,
                distribution: Distribution = .fillFlexing,
                alignment: Alignment = .fill,
                flexibility: Flexibility? = nil,
                sublayouts: [Layout],
                config: (View -> Void)? = nil) {
        
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
        self.flexibility = flexibility ?? StackLayout.defaultFlexibility(axis: axis, sublayouts: sublayouts)
        self.sublayouts = sublayouts
        super.init(config: config)
    }
}

// MARK: - Layout interface

extension StackLayout: Layout {

    public func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        var availableSize = AxisSize(axis: axis, size: maxSize)
        var sublayoutMeasurements = [LayoutMeasurement?](count: sublayouts.count, repeatedValue: nil)
        var usedSize = AxisSize(axis: axis, size: CGSizeZero)

        let sublayoutLengthForEqualSizeDistribution: CGFloat?
        if distribution == .fillEqualSize {
            sublayoutLengthForEqualSizeDistribution = sublayoutSpaceForEqualSizeDistribution(
                totalAvailableSpace: availableSize.axisLength, sublayoutCount: sublayouts.count)
        } else {
            sublayoutLengthForEqualSizeDistribution = nil
        }

        for (index, sublayout) in sublayoutsByAxisFlexibilityAscending() {
            if availableSize.axisLength <= 0 || availableSize.crossLength <= 0 {
                // There is no more room in the stack so don't bother measuring the rest of the sublayouts.
                break
            }

            let sublayoutMasurementAvailableSize: CGSize
            if let sublayoutLengthForEqualSizeDistribution = sublayoutLengthForEqualSizeDistribution {
                sublayoutMasurementAvailableSize = AxisSize(axis: axis,
                                                            axisLength: sublayoutLengthForEqualSizeDistribution,
                                                            crossLength: availableSize.crossLength).size
            } else {
                sublayoutMasurementAvailableSize = availableSize.size
            }

            let sublayoutMeasurement = sublayout.measurement(within: sublayoutMasurementAvailableSize)
            sublayoutMeasurements[index] = sublayoutMeasurement
            let sublayoutAxisSize = AxisSize(axis: axis, size: sublayoutMeasurement.size)

            if sublayoutAxisSize.axisLength > 0 {
                // If we are the first sublayout in the stack, then no leading spacing is required.
                // Otherwise account for the spacing.
                let leadingSpacing = (usedSize.axisLength > 0) ? spacing : 0
                usedSize.axisLength += leadingSpacing + sublayoutAxisSize.axisLength
                usedSize.crossLength = max(usedSize.crossLength, sublayoutAxisSize.crossLength)

                // Reserve spacing for the next sublayout.
                availableSize.axisLength -= sublayoutAxisSize.axisLength + spacing
            }
        }

        let nonNilMeasuredSublayouts = sublayoutMeasurements.flatMap { $0 }

        if distribution == .fillEqualSize && !nonNilMeasuredSublayouts.isEmpty {
            let maxAxisLength = nonNilMeasuredSublayouts.map({ AxisSize(axis: axis, size: $0.size).axisLength }).maxElement() ?? 0
            usedSize.axisLength = (maxAxisLength + spacing) * CGFloat(nonNilMeasuredSublayouts.count) - spacing
        }

        return LayoutMeasurement(layout: self, size: usedSize.size, maxSize: maxSize, sublayouts: nonNilMeasuredSublayouts)
    }

    public func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        let frame = alignment.position(size: measurement.size, inRect: rect)
        let availableSize = AxisSize(axis: axis, size: frame.size)
        let excessAxisLength = availableSize.axisLength - AxisSize(axis: axis, size: measurement.size).axisLength
        let config = distributionConfig(excessAxisLength: excessAxisLength)

        var nextOrigin = AxisPoint(axis: axis, axisOffset: config.initialAxisOffset, crossOffset: 0)
        var sublayoutArrangements = [LayoutArrangement]()
        for (index, sublayout) in measurement.sublayouts.enumerate() {
            var sublayoutAvailableSize = AxisSize(axis: axis, size: sublayout.size)
            sublayoutAvailableSize.crossLength = availableSize.crossLength
            if distribution == .fillEqualSize {
                sublayoutAvailableSize.axisLength = sublayoutSpaceForEqualSizeDistribution(
                    totalAvailableSpace: AxisSize(axis: axis, size: frame.size).axisLength,
                    sublayoutCount: measurement.sublayouts.count)
            } else if config.stretchIndex == index {
                sublayoutAvailableSize.axisLength += excessAxisLength
            }
            let sublayoutArrangement = sublayout.arrangement(within: CGRect(origin: nextOrigin.point, size: sublayoutAvailableSize.size))
            sublayoutArrangements.append(sublayoutArrangement)
            nextOrigin.axisOffset += sublayoutAvailableSize.axisLength
            if sublayoutAvailableSize.axisLength > 0 {
                // Only add spacing below a view if it was allocated non-zero height.
                nextOrigin.axisOffset += config.axisSpacing
            }
        }
        return LayoutArrangement(layout: self, frame: frame, sublayouts: sublayoutArrangements)
    }

    private func sublayoutSpaceForEqualSizeDistribution(totalAvailableSpace totalAvailableSpace: CGFloat, sublayoutCount: Int) -> CGFloat {
        guard sublayoutCount > 0 else {
            return totalAvailableSpace
        }
        if spacing == 0 {
            return totalAvailableSpace / CGFloat(sublayoutCount)
        }
        // Note: we don't actually need to check for zero spacing above, because division by zero produces a valid result for floating point values.
        // We check anyway for the sake of clarity.
        let maxSpacings = floor(totalAvailableSpace / spacing)
        let visibleSublayoutCount = min(CGFloat(sublayoutCount), maxSpacings + 1)
        let spaceAvailableForSublayouts = totalAvailableSpace - CGFloat(visibleSublayoutCount - 1) * spacing
        return spaceAvailableForSublayouts / CGFloat(visibleSublayoutCount)
    }
}

// MARK: - Distribution

extension StackLayout {
    /**
     Specifies how excess space along the axis is allocated.
     */
    public enum Distribution {

        /**
         Sublayouts are positioned starting at the top edge of vertical stacks or at the leading edge of horizontal stacks.
         */
        case leading

        /**
         Sublayouts are positioned starting at the bottom edge of vertical stacks or at the the trailing edge of horizontal stacks.
         */
        case trailing

        /**
         Sublayouts are positioned so that they are centered along the stack's axis.
         */
        case center

        /**
         Distributes excess axis space by increasing the spacing between each sublayout by an equal amount.
         The sublayouts and the adjusted spacing consume all of the available axis space.
         */
        case fillEqualSpacing

        /**
         Distributes axis space equally among the sublayouts.
         The spacing between the sublayouts remains equal to the spacing parameter.
         */
        case fillEqualSize

        /**
         Distributes excess axis space by growing the most flexible sublayout along the axis.
         */
        case fillFlexing
    }

    private struct DistributionConfig {
        let initialAxisOffset: CGFloat
        let axisSpacing: CGFloat
        let stretchIndex: Int?
    }

    private func distributionConfig(excessAxisLength excessAxisLength: CGFloat) -> DistributionConfig {
        let initialAxisOffset: CGFloat
        let axisSpacing: CGFloat
        var stretchIndex: Int? = nil
        switch distribution {
        case .leading:
            initialAxisOffset = 0
            axisSpacing = spacing
        case .trailing:
            initialAxisOffset = excessAxisLength
            axisSpacing = spacing
        case .center:
            initialAxisOffset = excessAxisLength / 2.0
            axisSpacing = spacing
        case .fillEqualSpacing:
            initialAxisOffset = 0
            axisSpacing = max(spacing, excessAxisLength / CGFloat(sublayouts.count - 1))
        case .fillEqualSize:
            initialAxisOffset = 0
            axisSpacing = spacing
        case .fillFlexing:
            axisSpacing = spacing
            initialAxisOffset = 0
            if excessAxisLength > 0 {
                stretchIndex = stretchableSublayoutIndex()
            }
        }
        return DistributionConfig(initialAxisOffset: initialAxisOffset, axisSpacing: axisSpacing, stretchIndex: stretchIndex)
    }
}

// MARK: - Axis flexing

extension StackLayout {

    /**
     Returns the sublayouts sorted by flexibility ascending.
     */
    private func sublayoutsByAxisFlexibilityAscending() -> [(index: Int, element: Layout)] {
        return sublayouts.enumerate().sort(compareLayoutsByFlexibilityAscending)
    }

    /**
     Returns the index of the most flexible sublayout.
     It returns nil if there are no flexible sublayouts.
     */
    private func stretchableSublayoutIndex() -> Int? {
        guard let (index, sublayout) = sublayouts.enumerate().maxElement(compareLayoutsByFlexibilityAscending) else {
            return nil
        }
        if sublayout.flexibility.flex(axis) == nil {
            // The most flexible sublayout is still not flexible, so don't stretch it.
            return nil
        }
        return index
    }

    /**
     Returns true iff the left layout is less flexible than the right layout.
     If two sublayouts have the same flexibility, then sublayout with the higher index is considered more flexible.
     Inflexible layouts are sorted before all flexible layouts.
     */
    private func compareLayoutsByFlexibilityAscending(left: (index: Int, layout: Layout), right: (index: Int, layout: Layout)) -> Bool {
        let leftFlex = left.layout.flexibility.flex(axis)
        let rightFlex = right.layout.flexibility.flex(axis)
        if leftFlex == rightFlex {
            return left.index < right.index
        }
        // nil is less than all integers
        return leftFlex < rightFlex
    }

    /**
     Inherit the maximum flexibility of sublayouts along the axis and minimum flexibility of sublayouts across the axis.
     */
    private static func defaultFlexibility(axis axis: Axis, sublayouts: [Layout]) -> Flexibility {
        let initial = AxisFlexibility(axis: axis, axisFlex: nil, crossFlex: .max)
        return sublayouts.reduce(initial) { (flexibility: AxisFlexibility, sublayout: Layout) -> AxisFlexibility in
            let subflex = AxisFlexibility(axis: axis, flexibility: sublayout.flexibility)
            let axisFlex = Flexibility.max(flexibility.axisFlex, subflex.axisFlex)
            let crossFlex = Flexibility.min(flexibility.crossFlex, subflex.crossFlex)
            return AxisFlexibility(axis: axis, axisFlex: axisFlex, crossFlex: crossFlex)
        }.flexibility
    }
}
