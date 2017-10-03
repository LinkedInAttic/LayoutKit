// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import XCTest
import LayoutKit // intentionally not @testable

class ReloadableViewTests: XCTestCase {

    // MARK: collection view

    func testCanOverrideCollectionViewRegisterViews() {
        let registerViewsCollectionView = RegisterViewsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        registerViewsCollectionView.registerViewsExpectation = expectation(description: "registerViews")

        // upcast to UICollectionView to make sure that overloading works correctly
        let collectionView: UICollectionView = registerViewsCollectionView
        collectionView.registerViews(withReuseIdentifier: "reuseIdentifier")

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testCanOverride_CollectionView_PerformBatchUpdates() {
        let registerViewsCollectionView = RegisterViewsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        registerViewsCollectionView.reloadDataSynchronouslyExpectation = expectation(description: "reloadDataSynchronously")

        // upcast to UICollectionView to make sure that overloading works correctly
        let collectionView: UICollectionView = registerViewsCollectionView
        collectionView.reloadDataSynchronously()

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testCanOverride_CollectionView_ReloadDataSynchronouslyExpectation() {
        let registerViewsCollectionView = RegisterViewsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        registerViewsCollectionView.performExpectation = expectation(description: "perform")

        // upcast to UICollectionView to make sure that overloading works correctly
        let collectionView: UICollectionView = registerViewsCollectionView
        collectionView.perform(batchUpdates: BatchUpdates(), completion: nil)

        waitForExpectations(timeout: 10.0, handler: nil)
    }


    // MARK: table view

    func testCanOverrideTableViewRegisterViews() {
        let registerViewsTableView = RegisterViewsTableView(frame: .zero)
        registerViewsTableView.registerViewsExpectation = expectation(description: "registerViews")

        // upcast to UITableView to make sure that overloading works correctly
        let tableView: UITableView = registerViewsTableView
        tableView.registerViews(withReuseIdentifier: "reuseIdentifier")

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testCanOverride_PerformBatchUpdates() {
        let registerViewsTableView = RegisterViewsTableView(frame: .zero)
        registerViewsTableView.reloadDataSynchronouslyExpectation = expectation(description: "reloadDataSynchronously")

        // upcast to UITableView to make sure that overloading works correctly
        let tableView: UITableView = registerViewsTableView
        tableView.reloadDataSynchronously()

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testCanOverride_ReloadDataSynchronouslyExpectation() {
        let registerViewsTableView = RegisterViewsTableView(frame: .zero)
        registerViewsTableView.performExpectation = expectation(description: "perform")

        // upcast to UITableView to make sure that overloading works correctly
        let tableView: UITableView = registerViewsTableView
        tableView.perform(batchUpdates: BatchUpdates(), completion: nil)

        waitForExpectations(timeout: 10.0, handler: nil)
    }
}

class RegisterViewsCollectionView: UICollectionView {

    var registerViewsExpectation: XCTestExpectation?

    override func registerViews(withReuseIdentifier reuseIdentifier: String) {
        registerViewsExpectation?.fulfill()
    }

    var reloadDataSynchronouslyExpectation: XCTestExpectation?

    override func reloadDataSynchronously() {
        reloadDataSynchronouslyExpectation?.fulfill()
    }

    var performExpectation: XCTestExpectation?

    override func perform(batchUpdates: BatchUpdates, completion: (() -> Void)?) {
        performExpectation?.fulfill()
    }
}

class RegisterViewsTableView: UITableView {

    var registerViewsExpectation: XCTestExpectation?

    override func registerViews(withReuseIdentifier reuseIdentifier: String) {
        registerViewsExpectation?.fulfill()
    }

    var reloadDataSynchronouslyExpectation: XCTestExpectation?

    override func reloadDataSynchronously() {
        reloadDataSynchronouslyExpectation?.fulfill()
    }

    var performExpectation: XCTestExpectation?

    override func perform(batchUpdates: BatchUpdates, completion: (() -> Void)?) {
        performExpectation?.fulfill()
    }
}
