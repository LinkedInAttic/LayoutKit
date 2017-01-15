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

//let arrangement = sizeLayout("Hello World").arrangement(width: 100, height: 100)
let arrangement = sizeLayout().arrangement()
print(arrangement)

arrangement.makeViews(in: rootView)

Debug.addBorderColorsRecursively(rootView)
Debug.printRecursiveDescription(rootView)

PlaygroundPage.current.liveView = rootView
