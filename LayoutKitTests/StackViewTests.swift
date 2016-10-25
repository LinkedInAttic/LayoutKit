// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
import LayoutKit

/**
 Basic tests for StackView.

 StackView uses StackLayout, and StackLayout is exhaustively tested, so we don't need exhaustive tests here.
 */
class StackViewTests: XCTestCase {

    func testVerticalStackView() {
        let view1 = FixedSizeView(width: 7, height: 14)
        let view2 = FixedSizeView(width: 18, height: 18.5)
        let view3 = FixedSizeView(width: 33.5, height: 23)

        let sv = StackView(axis: .vertical, spacing: 3, contentInsets: UIEdgeInsets(top: 2, left: 4, bottom: 8, right: 16))
        sv.addArrangedSubviews([view1, view2, view3])

        let ics = sv.intrinsicContentSize
        XCTAssertEqual(ics, CGSize(width: 4 + 33.5 + 16, height: CGFloat(2 + 14 + 3 + 18.5 + 3 + 23 + 8)))

        sv.frame = CGRect(origin: .zero, size: ics)
        sv.layoutIfNeeded()

        XCTAssertEqual(view1.frame, CGRect(x: 4, y: 2, width: 33.5, height: 14))
        XCTAssertEqual(view2.frame, CGRect(x: 4, y: 2+14+3, width: 33.5, height: 18.5))
        XCTAssertEqual(view3.frame, CGRect(x: 4, y: CGFloat(2+14+3+18.5+3), width: 33.5, height: 23))
    }

    func testHorizontalStackView() {
        let view1 = FixedSizeView(width: 7, height: 14)
        let view2 = FixedSizeView(width: 18, height: 18.5)
        let view3 = FixedSizeView(width: 33.5, height: 23)

        let sv = StackView(axis: .horizontal, spacing: 3, contentInsets: UIEdgeInsets(top: 2, left: 4, bottom: 8, right: 16))
        sv.addArrangedSubviews([view1, view2, view3])

        let ics = sv.intrinsicContentSize
        XCTAssertEqual(ics, CGSize(width: CGFloat(4 + 7 + 3 + 18 + 3 + 33.5 + 16),
                                   height: CGFloat(2 + 23 + 8)))

        sv.frame = CGRect(origin: .zero, size: ics)
        sv.layoutIfNeeded()

        XCTAssertEqual(view1.frame, CGRect(x: 4, y: 2, width: 7, height: 23))
        XCTAssertEqual(view2.frame, CGRect(x: 4+7+3, y: 2, width: 18, height: 23))
        XCTAssertEqual(view3.frame, CGRect(x: CGFloat(4+7+3+18+3), y: 2, width: 33.5, height: 23))
    }

    func testStackViewRequiresInvalidateIntrinsicContentSizeWhenContentChanges() {
        let label = UILabel(text: "Nick", font: UIFont(name: "Helvetica", size: 17)!)

        let stackView = StackView(axis: .vertical)
        stackView.addArrangedSubviews([label])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let autoLayoutView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        autoLayoutView.addSubview(stackView)
        let views = ["stackView": stackView]
        autoLayoutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[stackView]-0-|", options: [], metrics: nil, views: views))
        autoLayoutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[stackView]", options: [], metrics: nil, views: views))

        autoLayoutView.layoutIfNeeded()
        AssertEqualDensity(label.frame, [
            1.0: CGRect(x: 0, y: 0, width: 34, height: 20),
            2.0: CGRect(x: 0, y: 0, width: 33.5, height: 20),
            3.0: CGRect(x: 0, y: 0, width: 33 + oneThird, height: 19 + twoThirds),
        ])

        label.text = "Snyder"
        autoLayoutView.setNeedsLayout()
        autoLayoutView.layoutIfNeeded()

        // Unfortunately, the label's frame won't have been updated because the intrinsic content size of the stack view hasn't been invalidated.
        AssertEqualDensity(label.frame, [
            1.0: CGRect(x: 0, y: 0, width: 34, height: 20),
            2.0: CGRect(x: 0, y: 0, width: 33.5, height: 20),
            3.0: CGRect(x: 0, y: 0, width: 33 + oneThird, height: 19 + twoThirds),
        ])

        // Verify that invalidating the intrinsic content size causes layout to happen.
        stackView.invalidateIntrinsicContentSize()
        autoLayoutView.setNeedsLayout()
        autoLayoutView.layoutIfNeeded()
        AssertEqualDensity(label.frame, [
            1.0: CGRect(x: 0, y: 0, width: 54, height: 20),
            2.0: CGRect(x: 0, y: 0, width: 54, height: 20),
            3.0: CGRect(x: 0, y: 0, width: 54, height: 19 + twoThirds),
        ])
    }

    /**
     This tests to make sure we can add subviews to the stack view, lay them out, then
     remove them.
     */
    func testRemoveArrangedSubviews() {
        let view1 = FixedSizeView(width: 7, height: 14)
        let view2 = FixedSizeView(width: 18, height: 18.5)
        let view3 = FixedSizeView(width: 33.5, height: 23)

        let stackView = StackView(axis: .vertical)

        stackView.addArrangedSubviews([view1, view2, view3])
        XCTAssertEqual(stackView.intrinsicContentSize, CGSize(width: 33.5, height: CGFloat(14 + 18.5 + 23)))
        XCTAssertEqual(stackView.subviews.count, 3)

        stackView.removeArrangedSubviews()
        XCTAssertEqual(stackView.intrinsicContentSize, CGSize.zero)
        XCTAssertEqual(stackView.subviews.count, 0)
    }

    func testUIStackViewAutomaticallyInvalidatesIntrinsicContentSizeWhenContentChanges() {
        if #available(iOS 9.0, *) {
            let label = UILabel(text: "Nick", font: UIFont(name: "Helvetica", size: 17)!)

            let stackView = UIStackView(arrangedSubviews: [label])
            stackView.translatesAutoresizingMaskIntoConstraints = false

            let autoLayoutView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
            autoLayoutView.addSubview(stackView)
            let views = ["stackView": stackView]
            autoLayoutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[stackView]-0-|", options: [], metrics: nil, views: views))
            autoLayoutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[stackView]", options: [], metrics: nil, views: views))

            autoLayoutView.layoutIfNeeded()
            AssertEqualDensity(label.frame, [
                1.0: CGRect(x: 0, y: 0, width: 34, height: 20),
                2.0: CGRect(x: 0, y: 0, width: 33.5, height: 20),
                3.0: CGRect(x: 0, y: 0, width: 33.0 + oneThird, height: 20),
            ])

            label.text = "Snyder"

            // Unlike StackView, don't need to manually invalidate intrinsic content size of UIStackView.
            autoLayoutView.setNeedsLayout()
            autoLayoutView.layoutIfNeeded()
            XCTAssertEqual(label.frame, CGRect(x: 0, y: 0, width: 54, height: 20))
        }
    }
}

/// A view that has a fixed size so that tests do not depend on fonts or screen density.
class FixedSizeView: UIView {

    private let width: CGFloat
    private let height: CGFloat

    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: min(width, size.width), height: min(height, size.height))
    }

    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }
}
