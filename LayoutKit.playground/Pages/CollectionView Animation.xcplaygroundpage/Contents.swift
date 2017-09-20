//: [Previous](@previous)

import Foundation
import LayoutKit
import UIKit
import PlaygroundSupport

class ContentCollectionViewFlowLayout : UICollectionViewFlowLayout {

    private var animations: [Animation] = []

    func add(animations: [Animation]) {
        self.animations.append(contentsOf: animations)
    }

    // MARK: UICollectionViewFlowLayout

    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        self.animations.forEach { animation in
            animation.apply()
        }
        self.animations = []
    }
}


class MyViewController : UIViewController {

    lazy var layouts: [[Layout]] = {
        return [
            [
                self.itemLayout(text: "Section 0 item 0"),
                self.itemLayout(text: "Section 0 item 1")
            ],
            [
                self.itemLayout(text: "Section 1 item 0"),
                self.itemLayout(text: "Section 1 item 1")
            ]
        ]
    }()

    let collectionViewLayout: ContentCollectionViewFlowLayout = {
        let layout = ContentCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return layout
    }()

    lazy var layoutAdapterCollectionView: LayoutAdapterCollectionView = {
        let collectionView = LayoutAdapterCollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.backgroundColor = .lightGray
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutAdapterCollectionView.frame = self.view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.layoutAdapterCollectionView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


        self.layoutAdapterCollectionView.layoutAdapter.reload(
            width: self.layoutAdapterCollectionView.bounds.width,
            synchronous: true,
            layoutProvider: self.layoutAdapter,
            completion: nil
        )
    }


    private func layoutAdapter() -> [Section<[Layout]>] {
        return [
            Section<[Layout]>(header: self.headerLayout(title: "Reload item"), items: self.layouts[0]),
            Section<[Layout]>(header: self.headerLayout(title: "Invalidate layout item"), items: self.layouts[1])
        ]
    }

    private func headerLayout(title: String) -> Layout {
        let labelLayout = LabelLayout(
            text: title,
            font: .boldSystemFont(ofSize: 24),
            numberOfLines: 0,
            alignment: .centerLeading,
            viewReuseId: "headerlabel"
        )

        return InsetLayout(
            insets: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
            sublayout: labelLayout
        )
    }

    private func itemLayout(text: String, minHeight: CGFloat = 100, color: UIColor = .red) -> Layout {

        let imageLayout = SizeLayout(
            width: 80,
            height: 80,
            viewReuseId: "image",
            config: { view in
                view.backgroundColor = color
            }
        )

        let labelLayout = LabelLayout(
            text: text,
            font: .systemFont(ofSize: 18),
            numberOfLines: 0,
            alignment: .centerLeading,
            viewReuseId: "label"
        )

        let resizeButtonLayout = ButtonLayout(
            type: .custom,
            title: "Resize",
            font: .systemFont(ofSize: 18),
            contentEdgeInsets: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8),
            alignment: .centerTrailing,
            viewReuseId: "button",
            config: { [unowned self] button in
                button.backgroundColor = .lightGray
                button.addHandler(for: .touchUpInside, handler: { control in
                    self.updateCell(withSubview: button)
                })
            }
        )

        let stackLayout = StackLayout(
            axis: .horizontal,
            spacing: 10,
            viewReuseId: "stackView",
            sublayouts: [
                imageLayout,
                labelLayout,
                resizeButtonLayout
            ],
            config: { view in
                view.backgroundColor = .white
            }
        )

        return SizeLayout(minHeight: minHeight, sublayout: stackLayout)
    }

    private func updateCell(withSubview subview: UIView) {
        guard let cell = self.findIndexPathForCell(withSubview: subview) else { return }
        guard let indexPath = self.layoutAdapterCollectionView.indexPath(for: cell) else { return }

        let randomNum: UInt32 = arc4random_uniform(100) + 100
        let colors: [UIColor] = [.blue, .green, .yellow]

        self.layouts[indexPath.section][indexPath.item] = self.itemLayout(
            text: "Section \(indexPath.section) item \(indexPath.item)",
            minHeight: CGFloat(randomNum),
            color: colors[Int(arc4random_uniform(UInt32(colors.count)))]
        )

        if indexPath.section == 0 {
            self.reloadItem(at: indexPath)
        }
        else {
            self.invalidateItem(at: indexPath)
        }

    }

    private func reloadItem(at indexPath: IndexPath) {

        let batchUpdates = BatchUpdates()
        batchUpdates.reloadItems = [indexPath]

        self.layoutAdapterCollectionView.layoutAdapter.reload(
            width: self.layoutAdapterCollectionView.bounds.width,
            synchronous: true,
            batchUpdates: batchUpdates,
            layoutProvider: self.layoutAdapter
        )
    }

    private func invalidateItem(at indexPath: IndexPath) {
        let items: [IndexPath] = [indexPath]

        self.layoutAdapterCollectionView.layoutAdapter.reload(
            items: items,
            width: self.layoutAdapterCollectionView.bounds.width,
            layoutProvider: self.layoutAdapter,
            completion: { animations in
                self.collectionViewLayout.add(animations: animations)
                let invalidationContext = UICollectionViewFlowLayoutInvalidationContext()
                invalidationContext.invalidateItems(at: items)

                self.layoutAdapterCollectionView.performBatchUpdates({
                    self.layoutAdapterCollectionView.collectionViewLayout.invalidateLayout(with: invalidationContext)
                })
            }
        )
    }

    private func findIndexPathForCell(withSubview view: UIView) -> UICollectionViewCell? {

        if let cell = view as? UICollectionViewCell {
            return cell
        }

        if let superview = view.superview {
            return findIndexPathForCell(withSubview: superview)
        }

        return nil
    }

}


PlaygroundPage.current.liveView = MyViewController()
PlaygroundPage.current.needsIndefiniteExecution = true
