// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit

class TableLayoutViewController: CollectionViewLayoutViewController {

    init() {
        let layout = CollectionViewTableLayout()
        super.init(collectionViewLayout: layout)
        layout.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TableLayoutViewController: CollectionViewTableLayoutDelegate {

    func axisLength(forItemAt indexPath: IndexPath, crossLength: CGFloat, layout: CollectionViewTableLayout) -> CGFloat {
        NSLog("axisLength(forItemAtIndexPath:\(indexPath.item)) = \(cellSizes[indexPath.item].height)")
        //usleep(1000) // 1ms
        return cellSizes[indexPath.item].height
    }
}
