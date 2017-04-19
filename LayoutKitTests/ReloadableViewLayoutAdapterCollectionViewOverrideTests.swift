// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
@testable import LayoutKit

class ReloadableViewLayoutAdapterCollectionViewOverrideTests: XCTestCase {

    var reloadableViewLayoutAdapter: MockReloadableCollectionViewAdapter!
    var collectionView: UICollectionView!

    override func setUp() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        reloadableViewLayoutAdapter = MockReloadableCollectionViewAdapter(reloadableView: collectionView)
    }

    func testSizeForItemAt_Called_ShouldCallMock() {
        _ = reloadableViewLayoutAdapter.collectionView(collectionView, layout: UICollectionViewFlowLayout(), sizeForItemAt: IndexPath(item: 0, section: 0))

        XCTAssert(reloadableViewLayoutAdapter.collectionViewSizeForItemAtCallCount == 1)
    }


    func testCellForItemAt_Called_ShouldCallMock() {
        _ = reloadableViewLayoutAdapter.collectionView(collectionView, cellForItemAt: IndexPath(row: 0, section: 0))

        XCTAssert(reloadableViewLayoutAdapter.collectionViewCellForItemAtCallCount == 1)
    }

    func testViewForSupplementaryElementOfKind_Called_ShouldCallMock() {
        _ = reloadableViewLayoutAdapter.collectionView(collectionView, viewForSupplementaryElementOfKind: "", at: IndexPath(row: 0, section: 0))

        XCTAssert(reloadableViewLayoutAdapter.collectionViewViewForSupplementaryElementOfKindCallCount == 1)
    }
}

class MockReloadableCollectionViewAdapter: ReloadableViewLayoutAdapter {

    var collectionViewSizeForItemAtCallCount = 0

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionViewSizeForItemAtCallCount += 1

        return CGSize.zero
    }

    var collectionViewCellForItemAtCallCount = 0

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionViewCellForItemAtCallCount += 1

        return UICollectionViewCell()
    }

    var collectionViewViewForSupplementaryElementOfKindCallCount = 0

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        collectionViewViewForSupplementaryElementOfKindCallCount += 1

        return UICollectionReusableView()
    }
}
