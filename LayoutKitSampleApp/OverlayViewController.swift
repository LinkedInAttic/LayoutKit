// Copyright 2017 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit
import ExampleLayouts

class OverlayViewController: UIViewController {

    // MARK: - constants

    // A smattering of alignments to test for the overlay and underlay views
    private static let alignments: [Alignment] = [
        .topLeading,
        .topTrailing,
        .topCenter,
        .bottomLeading,
        .bottomTrailing,
        .bottomCenter,
        .centerLeading,
        .centerTrailing,
        .center,
        .fill
    ]

    // MARK: - variables

    private var tableView = LayoutAdapterTableView(frame: .zero, style: .grouped)
    private var cachedLayouts: [Layout] = {
        return (0..<alignments.count).flatMap { backgroundCount in
            return (0..<alignments.count).map { overlayCount in
                let backgroundLayouts = (0...backgroundCount).map { index in
                    return SizeLayout(
                        width: 60,
                        height: 40,
                        alignment: alignments[index],
                        config: { $0.backgroundColor = .orange })
                }
                let overlayLayouts = (0...overlayCount).map { index in
                    return SizeLayout(
                        width: 40,
                        height: 80,
                        alignment: alignments[index],
                        config: { $0.backgroundColor = .yellow })
                }
                let text = "Primary alignment is me!\n"
                    + "Background: \(backgroundCount + 1) views (orange)\n"
                    + "Overlay: \(overlayCount + 1) views (yellow)"
                let baseLayout = InsetLayout(
                    inset: 70,
                    sublayout: LabelLayout(text: text))
                return OverlayLayout(
                    primaryLayouts: [baseLayout],
                    backgroundLayouts: backgroundLayouts,
                    overlayLayouts: overlayLayouts)
            }
        }
    }()

    // MARK: - layout methods

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = UIColor.purple

        view.addSubview(tableView)
        self.layoutOverlays(width: tableView.frame.width, synchronous: false)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        layoutOverlays(width: size.width, synchronous: true)
    }

    private func layoutOverlays(width: CGFloat, synchronous: Bool) {
        tableView.layoutAdapter.reload(width: width, synchronous: synchronous, layoutProvider: { [weak self] in
            return [Section(header: nil, items: self?.cachedLayouts ?? [], footer: nil)]
        })
    }

}
