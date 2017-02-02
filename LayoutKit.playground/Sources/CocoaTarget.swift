import Foundation

/// A target that accepts action messages.
internal final class CocoaTarget<Value>: NSObject {
    private let action: (Value) -> ()

    internal init(_ action: @escaping (Value) -> ()) {
        self.action = action
    }

    @objc
    internal func sendNext(_ receiver: Any?) {
        action(receiver as! Value)
    }
}
