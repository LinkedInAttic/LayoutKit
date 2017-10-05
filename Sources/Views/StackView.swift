// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/**
 A view that stacks its subviews along a single axis.
 
 It is similar to UIStackView except that it uses StackLayout instead of Auto Layout, which means layout is much faster.
 
 Although StackView is faster than UIStackView, it still does layout on the main thread.
 If you want to get the full benefit of LayoutKit, use StackLayout directly.
 
 Unlike UIStackView, if you position StackView with Auto Layout, you must call invalidateIntrinsicContentSize on that StackView
 whenever any of its subviews' intrinsic content sizes change (e.g. changing the text of a UILabel that is positioned by the StackView).
 Otherwise, Auto Layout won't recompute the layout of the StackView.
 
 Subviews MUST implement sizeThatFits so StackView can allocate space correctly.
 If a subview uses Auto Layout, then the subview may implement sizeThatFits by calling systemLayoutSizeFittingSize.
 */
open class StackView: UIView {

    /// The axis along which arranged views are stacked.
    open let axis: Axis

    /**
     The distance in points between adjacent edges of sublayouts along the axis.
     For Distribution.EqualSpacing, this is a minimum spacing. For all other distributions it is an exact spacing.
     */
    open let spacing: CGFloat

    /// The distribution of space along the stack's axis.
    open let distribution: StackLayoutDistribution

    /// The distance that the arranged views are inset from the stack view. Defaults to 0.
    open let contentInsets: UIEdgeInsets

    /// The stack's alignment inside its parent.
    open let alignment: Alignment

    /// The stack's flexibility.
    open let flexibility: Flexibility?

    private var arrangedSubviews: [UIView] = []

    public init(axis: Axis,
                spacing: CGFloat = 0,
                distribution: StackLayoutDistribution = .leading,
                contentInsets: UIEdgeInsets = .zero,
                alignment: Alignment = .fill,
                flexibility: Flexibility? = nil) {

        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.contentInsets = contentInsets
        self.alignment = alignment
        self.flexibility = flexibility
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Adds a subview to the stack.
     
     Subviews MUST implement sizeThatFits so StackView can allocate space correctly.
     If a subview uses Auto Layout, then the subview can implement sizeThatFits by calling systemLayoutSizeFittingSize.
     */
    open func addArrangedSubviews(_ subviews: [UIView]) {
        arrangedSubviews.append(contentsOf: subviews)
        for subview in subviews {
            addSubview(subview)
        }
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }

    /**
     Deletes all subviews from the stack.
     */
    open func removeArrangedSubviews() {
        for subview in arrangedSubviews {
            subview.removeFromSuperview()
        }
        arrangedSubviews.removeAll()
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return stackLayout.measurement(within: size).size
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    open override func layoutSubviews() {
        stackLayout.measurement(within: bounds.size).arrangement(within: bounds).makeViews(in: self)
    }

    private var stackLayout: Layout {
        let sublayouts = arrangedSubviews.map { view -> Layout in
            return ViewLayout(view: view)
        }
        let stack = StackLayout(
            axis: axis,
            spacing: spacing,
            distribution: distribution,
            alignment: alignment,
            flexibility: flexibility,
            sublayouts: sublayouts,
            config: nil)

        return InsetLayout(insets: contentInsets, sublayout: stack)
    }
}

/// Wraps a UIView so that it conforms to the Layout protocol.
private struct ViewLayout: ConfigurableLayout {

    let needsView = true
    let view: UIView
    let viewReuseId: String? = nil

    func measurement(within maxSize: CGSize) -> LayoutMeasurement {
        let size = view.sizeThatFits(maxSize)
        return LayoutMeasurement(layout: self, size: size, maxSize: maxSize, sublayouts: [])
    }

    func arrangement(within rect: CGRect, measurement: LayoutMeasurement) -> LayoutArrangement {
        return LayoutArrangement(layout: self, frame: rect, sublayouts: [])
    }

    func makeView() -> UIView {
        return view
    }

    func configure(view: UIView) {
        // Nothing to configure.
    }

    var flexibility: Flexibility {
        let horizontal = flexForAxis(.horizontal)
        let vertical = flexForAxis(.vertical)
        return Flexibility(horizontal: horizontal, vertical: vertical)
    }

    private func flexForAxis(_ axis: UILayoutConstraintAxis) -> Flexibility.Flex {
        switch view.contentHuggingPriority(for: .horizontal) {
        case UILayoutPriority.required:
            return nil
        case let priority:
            return -Int32(priority.rawValue)
        }
    }
}
