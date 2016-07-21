// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKitExampleLayouts

class BackgroundMiniProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        edgesForExtendedLayout = .None
        
        let width = view.bounds.width
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            let nickProfile = MiniProfileLayout(
                imageName: "nick.jpg",
                name: "Nick Snyder",
                headline: "Software Engineer at LinkedIn"
            )

            let arrangement = nickProfile.arrangement(width: width)
            dispatch_async(dispatch_get_main_queue(), {
                arrangement.makeViews(in: self.view)
            })
        }
    }
}
