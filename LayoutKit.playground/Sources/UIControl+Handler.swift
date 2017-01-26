import UIKit

private var controlHandlerKey: Int8 = 0

extension UIControl {

    public func addHandler(for controlEvents: UIControlEvents, handler: @escaping (UIControl) -> ()) {
        let target = CocoaTarget<UIControl>(handler)
        objc_setAssociatedObject(self, &controlHandlerKey, target, .OBJC_ASSOCIATION_RETAIN)

        self.removeTarget(target, action: #selector(target.sendNext), for: controlEvents)
        self.addTarget(target, action: #selector(target.sendNext), for: controlEvents)
    }

}
