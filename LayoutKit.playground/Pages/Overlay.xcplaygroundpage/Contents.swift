import UIKit
import PlaygroundSupport
import LayoutKit

/**
 This page demonstrates a complex layout that uses `OverlayLayout`, so that
 you can see the effect of various alignment values and how composing views
 together works. There's an orange view that the layout sits in. The layout
 is bordered by a white border & has a black background. The semi-transparent
 text is the base layout, centered within the overlay layout. The overlay
 layout is set to fill leading space, so it doesn't span the full view. There's
 a red & a green box that overlay the base layout, and a purple and brown box
 that underlay it. They're aligned in various ways, but the sizing is such that
 you can see how they're composed. Try changing the alignment values and sizes
 to see how that affects the outcome!
 */

let baseLayout = TextViewLayout(
    text: "This is the base layout\nAnd it's a bunch of text!",
    textContainerInset: UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60),
    layoutAlignment: .center,
    config: { textView in
        textView.textColor = .white
        textView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
})
let greenBoxLayout = SizeLayout(
    width: 50,
    height: 80,
    alignment: .centerTrailing,
    config: { view in
        view.backgroundColor = .green
})
let redBoxLayout = SizeLayout(
    width: 70,
    height: 90,
    alignment: .topLeading,
    config: { view in
        view.backgroundColor = .red
})
let brownBoxLayout = SizeLayout(
    width: 160,
    height: 130,
    alignment: .bottomCenter,
    config: { view in
        view.backgroundColor = UIColor.brown
})
let purpleBoxLayout = SizeLayout(
    width: 80,
    height: 550,
    alignment: .fillTrailing,
    config: { view in
        view.backgroundColor = .purple
})

// Compose the layouts into an overlay layout
let overlayLayout = OverlayLayout(
    primaryLayouts: [baseLayout],
    backgroundLayouts: [purpleBoxLayout, brownBoxLayout],
    overlayLayouts: [redBoxLayout, greenBoxLayout],
    alignment: .fillLeading,
    config: { overlayView in
        overlayView.backgroundColor = .black
        overlayView.layer.borderWidth = 2.0
        overlayView.layer.borderColor = UIColor.white.cgColor
})


// Root view
let rootView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
rootView.backgroundColor = .orange

// Create arrangement within root view
let arrangement = overlayLayout.arrangement(
    origin: .zero,
    width: rootView.bounds.width,
    height: rootView.bounds.height)
print(arrangement)
arrangement.makeViews(in: rootView)
Debug.printRecursiveDescription(rootView)
PlaygroundPage.current.liveView = rootView
