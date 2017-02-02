// From https://github.com/linkedin/LayoutKit/blob/master/docs/animations.md

import UIKit
import PlaygroundSupport
import LayoutKit

// The initial layout.
let before = InsetLayout(
    inset: 30,
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
                        view.backgroundColor = UIColor.red
                    }
                ),
                config: { view in
                    view.backgroundColor = UIColor.gray
                }
            ),
            SizeLayout<UIView>(
                width: 80,
                height: 80,
                alignment: .bottomTrailing,
                viewReuseId: "littleSquare",
                config: { view in
                    view.backgroundColor = UIColor.lightGray
                }
            )
        ]
    )
)

// The final layout.
let after = InsetLayout(
    inset: 30,
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
                    view.backgroundColor = UIColor.gray
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
                        view.backgroundColor = UIColor.red
                    }
                ),
                config: { view in
                    view.backgroundColor = UIColor.lightGray
                }
            )
        ]
    )
)

// Setup a root view.
let rootView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 250))
rootView.backgroundColor = UIColor.white
PlaygroundPage.current.liveView = rootView

// Apply the initial layout.
before.arrangement(width: 350, height: 250).makeViews(in: rootView)

// Prepare the animation to the final layout.
let animation = after.arrangement(width: 350, height: 250).prepareAnimation(for: rootView, direction: .rightToLeft)

// Perform the animation.
UIView.animate(withDuration: 5.0, animations: animation.apply, completion: { (_) in
//    PlaygroundPage.current.finishExecution()
})
