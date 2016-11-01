// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import ExampleLayouts

class BackgroundMiniProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = UIRectEdge()
        
        let width = view.bounds.width
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            let nickProfile = MiniProfileLayout(
                imageName: "nick.jpg",
                name: "Nick Snyder",
                headline: "Software Engineer at LinkedIn"
            )

            let arrangement = nickProfile.arrangement(width: width)
            DispatchQueue.main.async(execute: {
                arrangement.makeViews(in: self.view)
            })
        }
    }
}
