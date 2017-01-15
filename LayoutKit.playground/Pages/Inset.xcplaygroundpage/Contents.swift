import UIKit
import PlaygroundSupport
import LayoutKit

let rootView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
rootView.backgroundColor = .white

func sizeLayout() -> SizeLayout<UIView> {
    return SizeLayout<UIView>(
        width: 280,
        height: 100,
        config: {
            $0.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
    )
}

func insetLayout() -> InsetLayout<UIView> {
    return InsetLayout(
        insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
        alignment: .center,
        sublayout: sizeLayout(),
        config: { _ in }
    )
}

//let arrangement = insetLayout().arrangement(width: 100, height: 150)
let arrangement = insetLayout().arrangement()
print(arrangement)

arrangement.makeViews(in: rootView)

Debug.addBorderColorsRecursively(rootView)
Debug.printRecursiveDescription(rootView)

PlaygroundPage.current.liveView = rootView
