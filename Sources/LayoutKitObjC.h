// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>

//! Project version number for LayoutKitObjC.
FOUNDATION_EXPORT double LayoutKitObjCVersionNumber;

//! Project version string for LayoutKitObjC.
FOUNDATION_EXPORT const unsigned char LayoutKitObjCVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <LayoutKitObjC/PublicHeader.h>

#if __has_include("LOKButtonLayoutBuilder.h")
#import "LOKButtonLayoutBuilder.h"
#endif
#import "LOKInsetLayoutBuilder.h"
#if __has_include("LOKLabelLayoutBuilder.h")
#import "LOKLabelLayoutBuilder.h"
#endif
#import "LOKOverlayLayoutBuilder.h"
#import "LOKSizeLayoutBuilder.h"
#import "LOKStackLayoutBuilder.h"
#if __has_include("LOKTextViewLayoutBuilder.h")
#import "LOKTextViewLayoutBuilder.h"
#endif

#if __has_include("LayoutKitObjC-Swift.h")
#import "LayoutKitObjC-Swift.h"
#endif
