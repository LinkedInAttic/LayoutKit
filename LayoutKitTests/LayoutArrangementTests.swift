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

    func testAnimation() {

        var redSquare: UIView? = nil

        let before = InsetLayout(
            inset: 10,
            sublayout: StackLayout(
                axis: .vertical,
                distribution: .fillEqualSpacing,
                sublayouts: [
                    SizeLayout<UIView>(
                        width: 100,
                        height: 100,
                        alignment: .topLeading,
                        viewReuseId: "bigSquare",
                        sublayout: SizeLayout<UIView>(
                            width: 10,
                            height: 10,
                            alignment: .bottomTrailing,
                            viewReuseId: "redSquare",
                            config: { view in
                                view.backgroundColor = UIColor.redColor()
                                redSquare = view
                            }
                        ),
                        config: { view in
                            view.backgroundColor = UIColor.grayColor()
                        }
                    ),
                    SizeLayout<UIView>(
                        width: 80,
                        height: 80,
                        alignment: .bottomTrailing,
                        viewReuseId: "littleSquare",
                        config: { view in
                            view.backgroundColor = UIColor.lightGrayColor()
                        }
                    )
                ]
            ),
            config: { view in
                view.backgroundColor = UIColor.blackColor()
            }
        )


        let after = InsetLayout(
            inset: 10,
            sublayout: StackLayout(
                axis: .vertical,
                distribution: .fillEqualSpacing,
                sublayouts: [
                    SizeLayout<UIView>(
                        width: 100,
                        height: 100,
                        alignment: .topLeading,
                        viewReuseId: "bigSquare",
                        config: { view in
                            view.backgroundColor = UIColor.grayColor()
                        }
                    ),
                    SizeLayout<UIView>(
                        width: 50,
                        height: 50,
                        alignment: .bottomTrailing,
                        viewReuseId: "littleSquare",
                        sublayout: SizeLayout<UIView>(
                            width: 20,
                            height: 20,
                            alignment: .topLeading,
                            viewReuseId: "redSquare",
                            config: { view in
                                view.backgroundColor = UIColor.redColor()
                                redSquare = view
                            }
                        ),
                        config: { view in
                            view.backgroundColor = UIColor.lightGrayColor()
                        }
                    )
                ]
            ),
            config: { view in
                view.backgroundColor = UIColor.blackColor()
            }
        )

        let rootView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        before.arrangement(width: 250, height: 250).makeViews(inView: rootView)
        XCTAssertEqual(redSquare?.frame, CGRect(x: 90, y: 90, width: 10, height: 10))

        let animation = after.arrangement(width: 250, height: 250).prepareAnimation(for: rootView, direction: .RightToLeft)
        XCTAssertEqual(redSquare?.frame, CGRect(x: -60, y: -60, width: 10, height: 10))

        animation.apply()
        XCTAssertEqual(redSquare?.frame, CGRect(x: 30, y: 0, width: 20, height: 20))
    }
}