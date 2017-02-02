import UIKit

public enum Debug {

    public static func color(at index: Int, isVivid: Bool) -> UIColor {
        let hue = (CGFloat(index) * 0.618033988749895).truncatingRemainder(dividingBy: 1)
        let saturation: CGFloat = isVivid ? 0.9 : 0.1
        return UIColor(hue: hue, saturation: saturation, brightness: 1, alpha: 0.8)
    }

    public static func addBorderColorsRecursively(_ view: UIView) {
        var i = 0
        func _addBorderColorsRecursively(_ view: UIView) {
            view.layer.borderColor = color(at: i, isVivid: view.subviews.isEmpty).cgColor
            view.layer.borderWidth = 2

            for subview in view.subviews {
                i += 1
                _addBorderColorsRecursively(subview)
            }
        }
        _addBorderColorsRecursively(view)
    }

    public static func printRecursiveDescription(_ view: UIView) {
        print(view.perform(Selector(("recursiveDescription"))).takeUnretainedValue())
    }

}
