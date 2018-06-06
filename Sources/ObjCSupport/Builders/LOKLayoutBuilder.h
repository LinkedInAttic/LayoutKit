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
typedef UIEdgeInsets LOKEdgeInsets;
typedef UIView LOKView;
#else
#import <AppKit/AppKit.h>
typedef NSEdgeInsets LOKEdgeInsets;
typedef NSView LOKView;
#endif

// Forward-declaring
@class LOKAlignment;
@class LOKFlexibility;
@class LOKInsetLayoutBuilder;
@protocol LOKLayout;

/**
 This protocol's only purpose is to serve as a gentle reminder when implementing the builder
 to provide support for these common builder properties. This protocol probably shouldn't be
 used as a property, parameter, or return type.

 The protocol defines one method (@c layout) instead of a property because of issues
 in the ObjC/Swift interop. However, when you implement the protocol conformance in your
 builder you should use properties for everything.

 The types being returned (@c id<LOKLayoutBuilder> and @c id<LOKLayout>) should be changed
 to the concrete type in your actual builder. It will still satisfy the protocol requirements
 but will allow the user of your builder to call the other builder-specific properties.
 */
@protocol LOKLayoutBuilder

@property (nonatomic, nonnull, readonly) id<LOKLayoutBuilder> _Nonnull(^alignment)(LOKAlignment * _Nullable);
@property (nonatomic, nonnull, readonly) id<LOKLayoutBuilder> _Nonnull(^flexibility)(LOKFlexibility * _Nullable);
@property (nonatomic, nonnull, readonly) id<LOKLayoutBuilder> _Nonnull(^viewReuseId)(NSString * _Nullable);
@property (nonatomic, nonnull, readonly) id<LOKLayoutBuilder> _Nonnull(^viewClass)(Class _Nullable);

@property (nonatomic, nonnull, readonly) id<LOKLayoutBuilder> _Nonnull(^config)( void(^ _Nullable)(LOKView *_Nonnull));
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^insets)(LOKEdgeInsets);
// This needs to be a function, because if it is a property it produces warnings, because
// of shortcomings in the ObjC/Swift interop. When implemented, it should still be a property.
- (nonnull id<LOKLayout>)layout;

@end
