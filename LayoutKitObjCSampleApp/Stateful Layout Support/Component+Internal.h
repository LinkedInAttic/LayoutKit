// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#include "Component.h"

@interface Component (Internal)

/// A block that produces a layout.
typedef _Nonnull id<LOKLayout>(^LayoutFunction)(void);

/// Caches the current data and state records for this tree of components and
/// produces a block that would construct a layout based on those records.
/// This method will be called by @c ComponentHost. It can only be called on the main thread.
/// The resulting block should be called on a background worker thread.
- (nonnull LayoutFunction)prepareRootForWorkerThread;

@end
