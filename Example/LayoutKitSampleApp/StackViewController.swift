// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit

/**
 Uses a stack view to layout subviews.
 */
class StackViewController: UIViewController {

    private var stackView: StackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = UIRectEdge()

        stackView = StackView(axis: .vertical, spacing: 4)
        stackView.addArrangedSubviews([
            UILabel(text: "Nick"),
            UILabel(text: "Software Engineer")
        ])
        stackView.frame = view.bounds
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.backgroundColor = UIColor.purple

        view.addSubview(stackView)
    }
}

extension UILabel {
    convenience init(text: String) {
        self.init()
        self.text = text
    }
}
