// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit

/// Data to populate a feed item.
struct FeedItemData {

    let actionText: String
    let posterName: String
    let posterHeadline: String
    let posterTimestamp: String
    let posterComment: String
    let contentTitle: String
    let contentDomain: String
    let actorComment: String

    static func generate(count: Int) -> [FeedItemData] {
        var datas = [FeedItemData]()
        for i in 0..<count {
            let data = FeedItemData(
                actionText: "action text \(i)",
                posterName: "poster name \(i)",
                posterHeadline: "poster title \(i) with some longer stuff",
                posterTimestamp: "poster timestamp \(i)",
                posterComment: "poster comment \(i)",
                contentTitle: "content title \(i)",
                contentDomain: "content domain \(i)",
                actorComment: "actor comment \(i)"
            )
            datas.append(data)
        }
        return datas
    }
}
