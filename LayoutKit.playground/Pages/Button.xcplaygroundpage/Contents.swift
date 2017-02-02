import UIKit
import PlaygroundSupport
import LayoutKit

let rootView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
rootView.backgroundColor = .white

func buttonLayout(_ text: String) -> ButtonLayout<UIButton> {
    return ButtonLayout<UIButton>(
        type: .custom,
        title: text,
        image: .image(UIImage(named: "earth")?.resize(width: 100)),
        font: .systemFont(ofSize: 36),
        contentEdgeInsets: .zero,
        alignment: .center,
        viewReuseId: "button",
        config: {
            $0.titleLabel?.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            $0.setTitleColor(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), for: .normal)
            $0.addHandler(for: .touchUpInside) { _ in
                print("Button tapped")
            }
        }
    )
}

//let arrangement = buttonLayout("Hello World").arrangement(width: 50)
let arrangement = buttonLayout("Tap me!").arrangement()
print(arrangement)

arrangement.makeViews(in: rootView)

Debug.addBorderColorsRecursively(rootView)
Debug.printRecursiveDescription(rootView)

PlaygroundPage.current.liveView = rootView
