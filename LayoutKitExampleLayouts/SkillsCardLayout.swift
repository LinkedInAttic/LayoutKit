// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import LayoutKit

open class SkillsCardLayout: InsetLayout<View> {

    public init(skill: String, endorsementCount: String, endorserProfileImageName: String) {
        let skillLabel = LabelLayout(
            text: skill,
            alignment: Alignment.center,
            flexibility: Flexibility.high, // Higher than default flexibility
            config: { label in
                label.backgroundColor = UIColor.yellow
            }
        )
        let countLabel = LabelLayout(
            text: endorsementCount,
            alignment: Alignment.center,
            flexibility: Flexibility.low,
            config: { label in
                label.backgroundColor = UIColor.yellow
            }
        )
        let endorserImage = SizeLayout<UIImageView>(
            size: CGSize(width: 20, height: 20),
            alignment: Alignment.center,
            config: { imageView in
                imageView.image = UIImage(named: endorserProfileImageName)
            }
        )
        let layout = StackLayout(
            axis: .horizontal,
            spacing: 8,
            distribution: .fillFlexing,
            alignment: Alignment(vertical: .center, horizontal: .fill),
            sublayouts: [
                skillLabel,
                countLabel,
                endorserImage,
            ]
        )
        super.init(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), sublayout: layout)
    }
}
