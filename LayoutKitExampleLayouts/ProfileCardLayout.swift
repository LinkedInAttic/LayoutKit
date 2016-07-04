// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit

public class ProfileCardLayout: StackLayout {

    public init(name: String, connectionDegree: String, headline: String, timestamp: String, profileImageName: String) {
        let labelConfig = { (label: UILabel) in
            label.backgroundColor = UIColor.yellow()
        }

        let nameAndConnectionDegree = StackLayout(
            axis: .horizontal,
            spacing: 4,
            sublayouts: [
                LabelLayout(text: name, config: labelConfig),
                LabelLayout(text: connectionDegree, config: { label in
                    label.backgroundColor = UIColor.gray()
                }),
            ]
        )

        let headline = LabelLayout(text: headline, numberOfLines: 2, config: labelConfig)
        let timestamp = LabelLayout(text: timestamp, numberOfLines: 2, config: labelConfig)

        let verticalLabelStack = StackLayout(
            axis: .vertical,
            spacing: 2,
            alignment: Alignment(vertical: .center, horizontal: .leading),
            sublayouts: [nameAndConnectionDegree, headline, timestamp]
        )

        let profileImage = SizeLayout<UIImageView>(
            size: CGSize(width: 50, height: 50),
            config: { imageView in
                imageView.image = UIImage(named: profileImageName)
            }
        )

        super.init(
            axis: .horizontal,
            spacing: 4,
            sublayouts: [
                profileImage,
                verticalLabelStack
            ]
        )
    }
}
