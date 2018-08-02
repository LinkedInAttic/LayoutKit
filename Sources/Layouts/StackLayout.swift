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
open class StackLayout<V: View>: BaseLayout<V> {

    /// The axis along which sublayouts are stacked.
    open let axis: Axis

    /**
     The distance in points between adjacent edges of sublayouts along the axis.
     For Distribution.EqualSpacing, this is a minimum spacing. For all other distributions it is an exact spacing.
     */
    open let spacing: CGFloat

    /// The distribution of space along the stack's axis.
    open let distribution: StackLayoutDistribution
    
    /// The stacked layouts.
    open let sublayouts: [Layout]

    public init(axis: Axis,
                spacing: CGFloat = 0,
                distribution: StackLayoutDistribution = .fillFlexing,
                alignment: Alignment = .fill,
                flexibility: Flexibility? = nil,
                viewReuseId: String? = nil,
                sublayouts: [Layout],
                config: ((V) -> Void)? = nil) {

        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.sublayouts = sublayouts
        let flexibility = flexibility ?? StackLayout.defaultFlexibility(axis: axis, sublayouts: sublayouts)
        super.init(alignment: alignment, flexibility: flexibility, viewReuseId: viewReuseId, config: config)
    }

    init(axis: Axis,
         spacing: CGFloat = 0,
         distribution: StackLayoutDistribution = .fillFlexing,
         alignment: Alignment = .fill,
         flexibility: Flexibility? = nil,
         viewReuseId: String? = nil,
         viewClass: V.Type? = nil,
         sublayouts: [Layout],
         config: ((V) -> Void)? = nil) {

        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.sublayouts = sublayouts
        let flexibility = flexibility ?? StackLayout.defaultFlexibility(axis: axis, sublayouts: sublayouts)
        super.init(alignment: alignment, flexibility: flexibility, viewReuseId: viewReuseId, viewClass: viewClass ?? V.self, config: config)
    }
}

// MARK: - Layout interface

extension StackLayout: ConfigurableLayout {

    public func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        var availableSize = AxisSize(axis: axis, size: maxSize)
        var sublayoutMeasurements = [LayoutMeasurement?](repeating: nil, count: sublayouts.count)
        var usedSize = AxisSize(axis: axis, size: .zero)

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

        let nonNilMeasuredSublayouts = sublayoutMeasurements.compactMap { $0 }

        if distribution == .fillEqualSize && !nonNilMeasuredSublayouts.isEmpty {
            let maxAxisLength = nonNilMeasuredSublayouts.map({ AxisSize(axis: axis, size: $0.size).axisLength }).max() ?? 0
            usedSize.axisLength = (maxAxisLength + spacing) * CGFloat(nonNilMeasuredSublayouts.count) - spacing
        }

        return LayoutMeasurement(layout: self, size: usedSize.size, maxSize: maxSize, sublayouts: nonNilMeasuredSublayouts)
    }

    public func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        let frame = alignment.position(size: measurement.size, in: rect)
        let availableSize = AxisSize(axis: axis, size: frame.size)
        let excessAxisLength = availableSize.axisLength - AxisSize(axis: axis, size: measurement.size).axisLength
        let config = distributionConfig(excessAxisLength: excessAxisLength)

        var nextOrigin = AxisPoint(axis: axis, axisOffset: config.initialAxisOffset, crossOffset: 0)
        var sublayoutArrangements = [LayoutArrangement]()
        for (index, sublayout) in measurement.sublayouts.enumerated() {
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

    private func sublayoutSpaceForEqualSizeDistribution(totalAvailableSpace: CGFloat, sublayoutCount: Int) -> CGFloat {
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

/**
 Specifies how excess space along the axis is allocated.
 */
public enum StackLayoutDistribution {

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

extension StackLayout {

    fileprivate func distributionConfig(excessAxisLength: CGFloat) -> DistributionConfig {
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
            let numberOfSpaces = CGFloat(sublayouts.count - 1)
            let availableAxisLengthForSpacing = excessAxisLength + numberOfSpaces * spacing
            axisSpacing = availableAxisLengthForSpacing / numberOfSpaces
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

    // MARK: - Axis flexing

    /**
     Returns the sublayouts sorted by flexibility ascending.
     */
    fileprivate func sublayoutsByAxisFlexibilityAscending() -> [(offset: Int, element: Layout)] {
        return sublayouts.enumerated().sorted(by: layoutsFlexibilityAscending)
    }

    /**
     Returns the index of the most flexible sublayout.
     It returns nil if there are no flexible sublayouts.
     */
    private func stretchableSublayoutIndex() -> Int? {
        guard let (index, sublayout) = sublayouts.enumerated().max(by: layoutsFlexibilityAscending) else {
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
    private func layoutsFlexibilityAscending(left: (offset: Int, element: Layout), right: (offset: Int, element: Layout)) -> Bool {
        let leftFlex = left.element.flexibility.flex(axis)
        let rightFlex = right.element.flexibility.flex(axis)
        if leftFlex == rightFlex {
            return left.offset < right.offset
        }
        // nil is less than all integers
        return leftFlex ?? .min < rightFlex ?? .min
    }

    /**
     Inherit the maximum flexibility of sublayouts along the axis and minimum flexibility of sublayouts across the axis.
     */
    fileprivate static func defaultFlexibility(axis: Axis, sublayouts: [Layout]) -> Flexibility {
        let initial = AxisFlexibility(axis: axis, axisFlex: nil, crossFlex: .max)
        return sublayouts.reduce(initial) { (flexibility: AxisFlexibility, sublayout: Layout) -> AxisFlexibility in
            let subflex = AxisFlexibility(axis: axis, flexibility: sublayout.flexibility)
            let axisFlex = Flexibility.max(flexibility.axisFlex, subflex.axisFlex)
            let crossFlex = Flexibility.min(flexibility.crossFlex, subflex.crossFlex)
            return AxisFlexibility(axis: axis, axisFlex: axisFlex, crossFlex: crossFlex)
        }.flexibility
    }
}
