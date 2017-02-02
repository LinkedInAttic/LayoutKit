// Copyright 2016 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import PlaygroundSupport
import LayoutKit
import ExampleLayouts

// REMINDER: you need to manually build ExampleLayouts on the simulator for changes to be reflected in this playground.

let helloWorld = HelloWorldLayout()

helloWorld.arrangement().makeViews()

helloWorld.arrangement(width: 250).makeViews()

helloWorld.arrangement().makeViews(direction: .rightToLeft) // just for testing; RTL happens automatically for RTL languages.

