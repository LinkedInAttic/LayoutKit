import UIKit

public protocol LayoutAdapter {
    func reload<T: Collection, U: Collection>(
        width: CGFloat?,
        height: CGFloat?,
        synchronous: Bool,
        batchUpdates: BatchUpdates?,
        layoutProvider: @escaping (Void) -> T,
        completion: (() -> Void)?) where U.Iterator.Element == Layout, T.Iterator.Element == Section<U>
}

extension ReloadableViewLayoutAdapter: LayoutAdapter {}
