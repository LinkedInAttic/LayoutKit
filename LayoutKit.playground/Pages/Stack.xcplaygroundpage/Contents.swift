import UIKit
import PlaygroundSupport
import LayoutKit

let rootView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
rootView.backgroundColor = .white

func stackLayout(_ text: String, _ distribution: StackLayoutDistribution) -> StackLayout<UIView> {
    return StackLayout<UIView>(
        axis: .horizontal,
        spacing: 10,
        distribution: distribution,
        sublayouts: [
            SizeLayout<UIView>(
                width: 20,
                height: 40,
                alignment: .bottomFill,
                flexibility: .low,
                config: {
                    $0.backgroundColor = .yellow
                }
            ),
            SizeLayout<UIView>(
                width: 20,
                height: 10,
                alignment: .bottomFill,
                flexibility: .high,
                config: {
                    $0.backgroundColor = .orange
                }
            ),
            SizeLayout<UIImageView>(
                width: 50,
                height: 50,
                alignment: .center,
                config: {
                    $0.image = UIImage(named: "earth")
                }
            ),
            LabelLayout(
                text: text,
                alignment: .center
            )
        ]
    )
}

func sizeLayout(_ text: String) -> SizeLayout<UIView> {
    return SizeLayout<UIView>(
        width: 280,
        height: 100,
        sublayout: stackLayout(text, .fillFlexing),
        config: { _ in }
    )
}

//let arrangement = stackLayout("Hello World").arrangement(width: 100, height: 150)
let arrangement = sizeLayout("Hello World").arrangement()
print(arrangement)

arrangement.makeViews(in: rootView)

Debug.addBorderColorsRecursively(rootView)
Debug.printRecursiveDescription(rootView)

PlaygroundPage.current.liveView = rootView
