// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>

#if __has_include(<UIKit/UIKit.h>)
// Importing the UI framework header. We could have just forward-declared `@class UIView` but `UIEdgeInsets` is a struct and cannot be forward-declared.
#import <UIKit/UIKit.h>
typedef UIEdgeInsets EdgeInsets;
typedef UIView View;
#else
#import <AppKit/AppKit.h>
typedef NSEdgeInsets EdgeInsets;
typedef NSView View;
#endif

// Forward-declaring
@class LOKAlignment;
@class LOKFlexibility;
@protocol LOKLayout;

@interface LOKBaseLayoutBuilder : NSObject

@property (nonatomic, nullable) LOKAlignment *alignment;
@property (nonatomic, nullable) LOKFlexibility *flexibility;
@property (nonatomic, nullable) NSString *viewReuseId;
@property (nonatomic, nullable) Class viewClass;
@property (nonatomic, nullable) void (^ configure)(View * _Nonnull);

- (nonnull id<LOKLayout>)build;

@end
