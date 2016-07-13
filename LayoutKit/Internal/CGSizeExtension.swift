// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import CoreGraphics

extension CGSize {
    func sizeDecreasedByInsets(insets: EdgeInsets) -> CGSize {
        return CGSize(width: width - insets.left - insets.right, height: height - insets.top - insets.bottom)
    }

    func sizeIncreasedByInsets(insets: EdgeInsets) -> CGSize {
        return CGSize(width: width + insets.left + insets.right, height: height + insets.top + insets.bottom)
    }

    func sizeDecreasedToSize(maxSize: CGSize) -> CGSize {
        let width = min(self.width, maxSize.width)
        let height = min(self.height, maxSize.height)
        return CGSize(width: width, height: height)
    }

    func sizeIncreasedToSize(minSize: CGSize) -> CGSize {
        let width = max(self.width, minSize.width)
        let height = max(self.height, minSize.height)
        return CGSize(width: width, height: height)
    }
}