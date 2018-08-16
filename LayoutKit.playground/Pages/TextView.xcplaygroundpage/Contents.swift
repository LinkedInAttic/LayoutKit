import UIKit
import PlaygroundSupport
import LayoutKit

let rootView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
rootView.backgroundColor = .white

let textString = "Hello World\nHello World\nHello World\nHello World\nHello World\n"
let attributedString1 = NSMutableAttributedString(
    string: textString,
    attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
let attributedString2 = NSMutableAttributedString(
    string: textString,
    attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
attributedString1.append(attributedString2)
let attributedText = Text.attributed(attributedString1)

let textContainerInset = UIEdgeInsets(top: 2, left: 3, bottom: 4, right: 5)

let textViewLayout = TextViewLayout(text: attributedText, textContainerInset: textContainerInset)
let arrangement = textViewLayout.arrangement()
arrangement.makeViews(in: rootView)

Debug.addBorderColorsRecursively(rootView)
Debug.printRecursiveDescription(rootView)

PlaygroundPage.current.liveView = rootView
