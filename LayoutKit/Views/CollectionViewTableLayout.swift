// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

public protocol CollectionViewTableLayoutDelegate: class {

    /// Returns the length of the item along the scroll axis given the available crossLength.
    /// - parameter indexPath: The index of the item.
    /// - parameter crossLength: The amount of space available to the item perpendicular to the scroll axis.
    /// - parameter layout: The layout that is calling this function.
    func axisLength(forItemAt indexPath: IndexPath, crossLength: CGFloat, layout: CollectionViewTableLayout) -> CGFloat
}

/// A UICollectionViewLayout that arranges items sequentially along the scroll axis.
/// Each item is given the entire length perpendicular to the scroll axis.
/// A vertical CollectionViewTableLayout is similar to a UITableView.
/// CollectionViewTableLayout is more conveneince and performant than using UICollectionViewFlowLayout for the same purpose.
open class CollectionViewTableLayout: UICollectionViewLayout {

    private static let defaultAxis = Axis.vertical

    /// The axis along which the collection view is scrollable.
    public var scrollAxis: Axis = defaultAxis {
        didSet {
            if scrollAxis != oldValue {
                invalidateLayout()
                contentSize.axis = scrollAxis
            }
        }
    }

    /// The spacing between items in the layout.
    public var itemSpacing: CGFloat = 0 {
        didSet {
            if itemSpacing != oldValue {
                invalidateLayout()
            }
        }
    }

    public weak var delegate: CollectionViewTableLayoutDelegate? = nil

    private var contentSize = AxisSize(axis: defaultAxis, size: .zero)

    /// All layout attributes for items in this collection that have been calculated.
    private var layoutAttributes = [UICollectionViewLayoutAttributes]()

    /// Index paths for all items in this collection, in order.
    private var layoutAttributesIndexPaths = [IndexPath]()

    /// An index that allows us to lookup layout attributes for a given index path.
    private var layoutAttributesByIndexPath = [IndexPath: UICollectionViewLayoutAttributes]()

    open override var collectionViewContentSize: CGSize {
        return contentSize.size
    }

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate on every bounds change (i.e. scrolling) so we have a chance to incrementally
        // compute the size of cells.
        return true
    }
    
    open override func prepare() {
        super.prepare()

        let availableSize = AxisSize(axis: scrollAxis, size: collectionView?.bounds.size ?? .zero)
        
        if availableSize.crossLength != contentSize.crossLength {
            // If the cross length has changed, then we need to recompute all layouts.
            resetLayoutAttributes()
            contentSize.crossLength = availableSize.crossLength
        }

        if contentSize.crossLength > 0 {
            // There are two reasons to precompute layout here:
            //     1. We need the size of a non-zero number of cells to be able to estimate content height.
            //     2. We want to compute cell layouts incrementally as scrolling happens, instead of
            //        in large batches as a result of `layoutAttributesForElementsInRect`. This is a tradeoff
            //
            // The amount of layout that we precompute (prepareAxisOffset) is the minimum number of cells necessary
            // to avoid preparing cells in `layoutAttributesForElementsInRect`, even if rotation happens.
            // prepareAxisOffset is tuned based on the observed behavior of UICollectionView.
            let currentAxisOffset = max(AxisPoint(axis: scrollAxis, point: collectionView?.contentOffset ?? .zero).axisOffset, 0)
            let prepareAxisOffset = currentAxisOffset + 3 * max(availableSize.axisLength, availableSize.crossLength)
            prepareLayoutAttributes(untilAxisOffset: prepareAxisOffset)
            contentSize.axisLength = estimatedContentAxisLength
        } else {
            contentSize.axisLength = 0
        }
    }

    /// The estimated axis length for all of the items and spacing.
    /// Items that haven't been measured are assumed to have an axis length
    /// equal to the average of the axis length of the items that have been measured.
    private var estimatedContentAxisLength: CGFloat {
        let estimatedAxisLengthPerItem = preparedAxisLength / CGFloat(layoutAttributes.count)
        let unknownCount = layoutAttributesIndexPaths.count - layoutAttributes.count
        return preparedAxisLength + ceil(CGFloat(unknownCount) * estimatedAxisLengthPerItem)
    }

    /// The cumulative axis length of all the items and spacing that have been measured.
    private var preparedAxisLength: CGFloat {
        return AxisRect(axis: scrollAxis, rect: layoutAttributes.last?.frame ?? .zero).axisMax
    }

    /// Prepares layout attributes for all items up until axisOffset.
    /// Returns the number of items prepared.
    @discardableResult
    private func prepareLayoutAttributes(untilAxisOffset axisOffset: CGFloat) -> Int {
        var count: Int = 0
        while true {
            if preparedAxisLength >= axisOffset {
                break
            }
            guard let indexPath = layoutAttributesIndexPaths[safe: layoutAttributes.endIndex] else {
                break
            }

            let itemCrossLength = contentSize.crossLength
            let itemAxisLength = delegate?.axisLength(forItemAt: indexPath, crossLength: itemCrossLength, layout: self) ?? 0
            let itemSize = AxisSize(axis: scrollAxis, axisLength: itemAxisLength, crossLength: itemCrossLength).size
            let itemAxisOffset = preparedAxisLength + itemSpacing

            let itemOrigin = AxisPoint(axis: scrollAxis, axisOffset: itemAxisOffset, crossOffset: 0).point

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(origin: itemOrigin, size: itemSize)

            //NSLog("prepare item \(indexPath.item) frame \(attributes.frame)")
            layoutAttributes.append(attributes)
            layoutAttributesByIndexPath[indexPath] = attributes

            count += 1
        }
        //NSLog("prepareLayoutAttributes(untilAxisOffset \(axisOffset)) = preparedAxisLength \(preparedAxisLength)")
        return count
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //NSLog("layoutAttributesForElementsInRect(\(rect))")
        let axisOffset = AxisPoint(axis: scrollAxis, point: rect.origin).axisOffset
        let axisLength = AxisSize(axis: scrollAxis, size: rect.size).axisLength
        let count = prepareLayoutAttributes(untilAxisOffset: axisOffset + axisLength)
        if count > 0 {
            NSLog("\(count) layoutAttributes were computed in layoutAttributesForElementsInRect. " +
                "This means that scrolling may not be as smooth as possible and we should probably adjust `prepareAxisOffset` in `prepareLayout()`.")
        }

        guard let firstIndex = layoutAttributes.binarySearch(forFirstIndexMatchingPredicate: { (attributes: UICollectionViewLayoutAttributes) -> Bool in
            return attributes.frame.maxY >= rect.minY
        }) else {
            return nil
        }

        var attributesInRect = [UICollectionViewLayoutAttributes]()
        for attributes in layoutAttributes.suffix(from: firstIndex) {
            if !attributes.frame.intersects(rect) {
                break
            }
            attributesInRect.append(attributes)
        }
        return attributesInRect
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // TODO: call prepareLayoutAttributes(untilAxisOffset) to handle inserts
        return layoutAttributesByIndexPath[indexPath]
    }

    open override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        if context.invalidateDataSourceCounts || context.invalidateEverything {
            resetLayoutAttributes()

            layoutAttributesIndexPaths.removeAll()
            for section in 0..<(collectionView?.numberOfSections ?? 0) {
                for item in 0..<(collectionView?.numberOfItems(inSection: section) ?? 0) {
                    let indexPath = IndexPath(item: item, section: section)
                    layoutAttributesIndexPaths.append(indexPath)
                }
            }
        }
    }

    private func resetLayoutAttributes() {
        NSLog("resetLayoutAttributes")
        layoutAttributes.removeAll()
        layoutAttributesByIndexPath.removeAll()
    }
}
