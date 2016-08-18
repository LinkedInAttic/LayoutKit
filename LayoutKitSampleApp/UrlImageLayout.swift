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
 A layout for an image that is loaded by URL.
 The size of the layout must be specified before the image is actually loaded.
 */
class UrlImageLayout: SizeLayout<UrlImageView> {

    init(url: NSURL, size: CGSize) {
        let config = { (imageView: UIImageView) in
            imageView.backgroundColor = UIColor.orangeColor()
            imageView.url = url
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                guard let data = NSData(contentsOfURL: url) else {
                    NSLog("failed to load image data \(url)")
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    if imageView.url == url {
                        imageView.image = UIImage(data: data)
                    }
                })
            }
        }
        super.init(minWidth: size.width,
                   maxWidth: size.width,
                   minHeight: size.height,
                   maxHeight: size.height,
                   alignment: .center,
                   flexibility: .inflexible,
                   config: config)
    }
}

/// An UIImageView that has an associated url.
class UrlImageView: UIImageView {
    var url: NSURL? = nil
}