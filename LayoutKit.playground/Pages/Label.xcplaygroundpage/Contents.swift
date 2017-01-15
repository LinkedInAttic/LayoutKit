import UIKit
import PlaygroundSupport
import LayoutKit

let rootView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
rootView.backgroundColor = .white

func labelLayout(_ text: String) -> LabelLayout<UILabel> {
    return LabelLayout<UILabel>(
        text: text,
        font: .systemFont(ofSize: 18),
        numberOfLines: 0,
        alignment: .center,
        flexibility: .high,
        viewReuseId: "label",
        config: { _ in }
    )
}

//let arrangement = labelLayout("Hello World").arrangement(width: 100, height: 150)
let arrangement = labelLayout("Hello World").arrangement()
print(arrangement)

arrangement.makeViews(in: rootView)

Debug.addBorderColorsRecursively(rootView)
Debug.printRecursiveDescription(rootView)

PlaygroundPage.current.liveView = rootView
