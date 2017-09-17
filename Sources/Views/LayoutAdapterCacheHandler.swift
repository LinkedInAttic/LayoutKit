public class LayoutAdapterCacheHandler {
    var layouts = [Section<[Layout]>]()
    let layoutAdapter: LayoutAdapter

    public init(layoutAdapter: LayoutAdapter) {
        self.layoutAdapter = layoutAdapter
    }

    /// Reloads reloadableView calculating only needed layouts
    public func reload(
        batchUpdates: BatchUpdates,
        layoutProvider: @escaping (IndexPath) -> Layout,
        sectionProvider: @escaping (Int, [Layout]) -> Section<[Layout]> = LayoutAdapterCacheHandler.defaultSectionProvider,
        animated: Bool = true,
        completion: (() -> Void)? = nil) {

        layoutAdapter.reload(
            width: nil,
            height: nil,
            synchronous: false,
            batchUpdates: animated ? batchUpdates : nil,
            layoutProvider: {
                self.cachedLayout(
                    batchUpdates: batchUpdates,
                    layoutProvider: layoutProvider,
                    sectionProvider: sectionProvider
                )
        },
            completion: completion
        )
    }

    /// Updates layouts that have changed using batchUpdates
    func cachedLayout(
        batchUpdates: BatchUpdates,
        layoutProvider: @escaping (IndexPath) -> Layout,
        sectionProvider: (Int, [Layout]) -> Section<[Layout]> = LayoutAdapterCacheHandler.defaultSectionProvider) -> [Section<[Layout]>] {

        let elements = batchUpdates
            .updateArray(layouts.map { $0.items }, elementCreationCallback: layoutProvider)

        layouts = elements
            .enumerated()
            .map { sectionProvider($0.offset, $0.element) }

        return layouts
    }

    static func defaultSectionProvider(index: Int, layouts: [Layout]) -> Section<[Layout]> {
        return Section(items: layouts)
    }
}
