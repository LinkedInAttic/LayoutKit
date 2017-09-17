public class LayoutAdapterWithAutomaticBatchUpdates {
    var viewModel = [[Any]]()

    let layoutAdapter: LayoutAdapterCacheHandler

    public init(layoutAdapter: LayoutAdapterCacheHandler) {
        self.layoutAdapter = layoutAdapter
    }

    /// Reloads data and automaticaly calculates and performs animations
    public func reload(
        viewModel: [[Any]],
        elementCompareCallback: @escaping (Any, Any) -> Bool = { _ in return false },
        layoutProvider: @escaping (IndexPath) -> Layout,
        animated: Bool = true,
        completion: (() -> Void)? = nil) {
        let batchUpdates = BatchUpdates
            .calculate(
                old: self.viewModel.filter { $0.count > 0},
                new: viewModel.filter { $0.count > 0 },
                elementCompareCallback: elementCompareCallback
        )

        self.viewModel = viewModel

        layoutAdapter.reload(
            batchUpdates: batchUpdates,
            layoutProvider: layoutProvider,
            animated: animated,
            completion: completion
        )
    }
}
