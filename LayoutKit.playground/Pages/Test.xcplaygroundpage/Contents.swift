import UIKit
import PlaygroundSupport
import LayoutKit

let rootView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
rootView.backgroundColor = .white

let rootSize = rootView.bounds.size

enum Msg {
    case increment, decrement
}

typealias Model = Int
var model: Model = 0

func view(_ model: Model, send: @escaping (Msg) -> ()) -> SizeLayout<UIView> {

    func label(key: String? = nil, text: String) -> LabelLayout<UILabel> {
        return LabelLayout<UILabel>(
            text: .unattributed(text),
            font: .systemFont(ofSize: 48),
            alignment: .center,
            viewReuseId: key
        )
    }

    func button(key: String? = nil, title: String, msg: Msg, config: @escaping (UIButton) -> ()) -> ButtonLayout<UIButton> {
        return ButtonLayout<UIButton>(
            type: .custom,
            title: title,
            font: .systemFont(ofSize: 24),
            contentEdgeInsets: EdgeInsets(top: 10, left: 50, bottom: 10, right: 50),
            viewReuseId: key,
            config: {
                config($0)
                $0.setTitleColor(.white, for: .normal)
                $0.addHandler(for: .touchUpInside) { _ in
                    send(msg)
                }
            }
        )
    }

    func stackLayout() -> StackLayout<UIView> {
        return StackLayout<UIView>(
            axis: .vertical,
            spacing: 40,
            alignment: .center,
            viewReuseId: "Label & Buttons Stack",
            sublayouts: [
                // NOTE: Reusing test.
                SizeLayout<UIView>(
                    width: 200,
                    height: 100,
                    alignment: .center,
                    viewReuseId: "Small Square Container",
                    sublayout: SizeLayout<UIView>(
                        width: model % 2 == 0 ? 20 : 60,
                        height: model % 2 == 0 ? 20 : 40,
                        alignment: model % 2 == 0 ? .topLeading : .bottomTrailing,
                        viewReuseId: "Small Square",
                        config: {
                            $0.backgroundColor = .red
                        }
                    )
                ),

                // NOTE: Non-reusing test.
                model % 2 == 0 ? label(text: "Hello") : label(text: "World"),

                // Below are same "Counter" example.
                label(
                    key: "label1",
                    text: "\(model)"
                ),
                StackLayout<UIView>(
                    axis: .horizontal,
                    spacing: 20,
                    distribution: .fillEqualSize,
                    alignment: .center,
                    viewReuseId: "Buttons Stack",
                    sublayouts: [
                        button(key: "decrement", title: "-", msg: .decrement) {
                            $0.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                        },
                        button(key: "increment", title: "+", msg: .increment) {
                            $0.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                        }
                    ],
                    config: { _ in }
                )
            ],
            config: { _ in }
        )
    }

    return SizeLayout<UIView>(
        size: rootSize,
        viewReuseId: "Root",
        sublayout: stackLayout(),
        config: {
            $0.backgroundColor = .white
        }
    )
}

func handleMsg(_ msg: Msg) {
    print(msg)

    switch msg {
    case .increment:
        model += 1
    case .decrement:
        model -= 1
    }

    render(animated: true)
}

func render(animated: Bool) {
    let arrangement = view(model, send: handleMsg).arrangement()
    print(arrangement)

    if animated {
        let animation = arrangement.prepareAnimation(for: rootView)

        UIView.animate(withDuration: 0.3, animations: {
            animation.apply()
        })
    }
    else {
        arrangement.makeViews(in: rootView)
    }

    Debug.addBorderColorsRecursively(rootView)
    Debug.printRecursiveDescription(rootView)
}
render(animated: false)

PlaygroundPage.current.liveView = rootView
