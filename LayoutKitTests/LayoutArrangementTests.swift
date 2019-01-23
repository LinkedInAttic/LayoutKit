// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
import LayoutKit

class LayoutArrangementTests: XCTestCase {

    func testMakeViewsSingle() {
        let layout = SizeLayout<View>(width: 50, height: 50)
        let view = layout.arrangement().makeViews()
        XCTAssertTrue(view.subviews.isEmpty)
        XCTAssertEqual(view.frame, CGRect(x: 0, y: 0, width: 50, height: 50))
    }

    func testMakeViewsMultiple() {
        let insets = EdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let layout1 = InsetLayout(insets: insets, sublayout: SizeLayout<View>(width: 50, height: 50) { _ in })
        let layout2 = InsetLayout(insets: insets, sublayout: SizeLayout<View>(width: 50, height: 50) { _ in })
        let stack = StackLayout(axis: .horizontal, sublayouts: [layout1, layout2])
        let view = stack.arrangement(origin: CGPoint(x: 1, y: 2)).makeViews()
        XCTAssertEqual(view.frame, CGRect(x: 1, y: 2, width: 140, height: 70))
        XCTAssertEqual(view.subviews.count, 2)
        XCTAssertEqual(view.subviews[0].frame, CGRect(x: 10, y: 10, width: 50, height: 50))
        XCTAssertEqual(view.subviews[1].frame, CGRect(x: 80, y: 10, width: 50, height: 50))
    }

    func testMakeViewsDifferentCalls() {
        var createdView: View?
        let sublayout0 = SizeLayout<View>(width: 50, height: 50, viewReuseId: "someID" ) { view in createdView = view }
        let sublayout1 = SizeLayout<View>(width: 50, height: 50, viewReuseId: "otherID" ) { _ in  }
        let stackLayout = StackLayout(axis: .vertical, sublayouts: [sublayout0, sublayout1])
        let arrangement = stackLayout.arrangement()
        let hostView = View()
        hostView.addSubview(arrangement.makeViews())
        let firstView = createdView
        arrangement.makeViews(in: hostView)
        let secondView = createdView
        XCTAssertTrue(firstView == secondView)
    }

    func testSubviewOrderIsStable() {
        // Forces the SizeLayout to produce a view.
        let forceViewConfig: (View) -> Void = { _ in }
        let top = SizeLayout(width: 5, height: 10, config: forceViewConfig)
        let middle = SizeLayout(width: 5, height: 20, viewReuseId: "middle", config: forceViewConfig)
        let bottom = SizeLayout(width: 5, height: 30, config: forceViewConfig)

        let stack = StackLayout(axis: .vertical, sublayouts: [top, middle, bottom])
        let container = View()

        stack.arrangement().makeViews(in: container)
        XCTAssertEqual(container.subviews[0].frame, CGRect(x: 0, y: 0, width: 5, height: 10))
        XCTAssertEqual(container.subviews[1].frame, CGRect(x: 0, y: 10, width: 5, height: 20))
        XCTAssertEqual(container.subviews[2].frame, CGRect(x: 0, y: 30, width: 5, height: 30))

        // Make sure that if we apply the same layout again that the views stay in the same order
        // even if some views are reused and others are not.
        stack.arrangement().makeViews(in: container)
        XCTAssertEqual(container.subviews[0].frame, CGRect(x: 0, y: 0, width: 5, height: 10))
        XCTAssertEqual(container.subviews[1].frame, CGRect(x: 0, y: 10, width: 5, height: 20))
        XCTAssertEqual(container.subviews[2].frame, CGRect(x: 0, y: 30, width: 5, height: 30))
    }

    func testAnimation() {
        let forceViewConfig: (View) -> Void = { _ in }
        var redSquare: View? = nil

        let before = InsetLayout(
            inset: 10,
            sublayout: StackLayout(
                axis: .vertical,
                distribution: .fillEqualSpacing,
                sublayouts: [
                    SizeLayout<View>(
                        width: 100,
                        height: 100,
                        alignment: .topLeading,
                        viewReuseId: "bigSquare",
                        sublayout: SizeLayout<View>(
                            width: 10,
                            height: 10,
                            alignment: .bottomTrailing,
                            viewReuseId: "redSquare",
                            config: { view in
                                redSquare = view
                            }
                        ),
                        config: forceViewConfig
                    ),
                    SizeLayout<View>(
                        width: 80,
                        height: 80,
                        alignment: .bottomTrailing,
                        viewReuseId: "littleSquare",
                        config: forceViewConfig
                    )
                ]
            )
        )


        let after = InsetLayout(
            inset: 10,
            sublayout: StackLayout(
                axis: .vertical,
                distribution: .fillEqualSpacing,
                sublayouts: [
                    SizeLayout<View>(
                        width: 100,
                        height: 100,
                        alignment: .topLeading,
                        viewReuseId: "bigSquare",
                        config: forceViewConfig
                    ),
                    SizeLayout<View>(
                        width: 50,
                        height: 50,
                        alignment: .bottomTrailing,
                        viewReuseId: "littleSquare",
                        sublayout: SizeLayout<View>(
                            width: 20,
                            height: 20,
                            alignment: .topLeading,
                            viewReuseId: "redSquare",
                            config: { view in
                                redSquare = view
                            }
                        ),
                        config: forceViewConfig
                    )
                ]
            )
        )

        let rootView = View(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        before.arrangement(width: 250, height: 250).makeViews(in: rootView)
        XCTAssertEqual(redSquare?.frame, CGRect(x: 90, y: 90, width: 10, height: 10))

        let animation = after.arrangement(width: 250, height: 250).prepareAnimation(for: rootView, direction: .rightToLeft)
        XCTAssertEqual(redSquare?.frame, CGRect(x: -60, y: -60, width: 10, height: 10))

        animation.apply()
        XCTAssertEqual(redSquare?.frame, CGRect(x: 30, y: 0, width: 20, height: 20))
    }
}
