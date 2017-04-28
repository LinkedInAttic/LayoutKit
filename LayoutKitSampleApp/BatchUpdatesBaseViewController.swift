// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit

/// Base class for batch update examples.
class BatchUpdatesBaseViewController: UIViewController {

    func layoutOne() -> [Section<[Layout]>] {
        return [
            Section(
                header: nil,
                items: [
                    TestLayout(text: "Section 0 item 0"),
                    TestLayout(text: "Section 0 item 1"),
                    TestLayout(text: "Section 0 item 2"),
                ],
                footer: nil
            ),
            Section(
                header: nil,
                items: [
                    TestLayout(text: "Section 1 item 0"),
                    TestLayout(text: "Section 1 item 1"),
                    TestLayout(text: "Section 1 item 2"),
                ],
                footer: nil
            ),
            Section(
                header: nil,
                items: [
                    TestLayout(text: "Section 2 item 0"),
                    TestLayout(text: "Section 2 item 1"),
                    TestLayout(text: "Section 2 item 2"),
                ],
                footer: nil
            ),
            Section(
                header: nil,
                items: [
                    TestLayout(text: "Section 3 item 0"),
                    TestLayout(text: "Section 3 item 1"),
                    TestLayout(text: "Section 3 item 2"),
                ],
                footer: nil
            )
        ]
    }

    func layoutTwo() -> [Section<[Layout]>] {
        return [
            Section(
                header: nil,
                items: [
                    TestLayout(text: "Section 1 item 1"),
                    TestLayout(text: "Section 1 item 2"),
                ],
                footer: nil
            ),
            Section(
                header: nil,
                items: [
                    TestLayout(text: "Section 2 item 0"),
                    TestLayout(text: "Section 2 item 3"),
                    TestLayout(text: "Section 2 item 1"),
                    TestLayout(text: "Section 2 item 2"),
                ],
                footer: nil
            ),
            Section(
                header: nil,
                items: [
                    TestLayout(text: "Section 3 item 1"),
                    TestLayout(text: "Section 3 item 0"),
                    TestLayout(text: "Section 3 item 2"),
                ],
                footer: nil
            ),
            Section(
                header: nil,
                items: [
                    TestLayout(text: "Section 4 item 0"),
                    TestLayout(text: "Section 4 item 1"),
                    TestLayout(text: "Section 4 item 2"),
                ],
                footer: nil
            )
        ]
    }

    func batchUpdates() -> BatchUpdates {
        let batchUpdates = BatchUpdates()
        batchUpdates.deleteSections.insert(0)
        batchUpdates.deleteItems.append(IndexPath(item: 0, section: 1))
        batchUpdates.insertItems.append(IndexPath(item: 1, section: 1))
        batchUpdates.insertSections.insert(3)
        batchUpdates.moveItems.append(ItemMove(from: IndexPath(item: 0, section: 3), to: IndexPath(item: 1, section: 2)))
        return batchUpdates
    }
}

private class TestLayout: LabelLayout<UILabel> {

    init(text: String) {
        super.init(text: .unattributed(text), alignment: .fill, config: { (label: UILabel) in
            label.backgroundColor = UIColor.red
        })
    }
}
