// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "Component.h"

NS_ASSUME_NONNULL_BEGIN

/// Hosts a @c Component in a @c UIView.
///
/// All of the properties and methods of this class should be accessed
/// on the main queue.
@interface ComponentHost : NSObject<ComponentOwner>

/// The component to display in the view.
/// UI updates asynchronously after this property is set.
@property (nonatomic, strong, nullable, readwrite) Component *component;

/// The view in which to display the component.
@property (nonatomic, strong, nullable, readonly) UIView *view;

/// Any insets to apply inside the view. Can be used for safeAreaInsets.
/// UI updates asynchronously after this property is set.
@property (nonatomic, assign, readwrite) UIEdgeInsets insets;

/// Call this to host a @c Component in a @c UIView.
/// This method can be called once per @c ComponentHost instance.
/// UI updates asynchronously after this method is called.
-(void)hostInView:(nonnull UIView *)view;

/// Asynchronously updates the layout to match the view's size.
-(void)viewDidChangeSize;

/// Updates the layout for the given view size.
/// UI updates synchronously when this method is called.
/// This method can be useful for rotation.
-(void)viewWillChangeSizeTo:(CGSize)size;

typedef void(^VoidVoidBlock)(void);

/// Produces an array of three tasks that can be executed to update
/// the UI asynchronously. First and last tasks should be executed on
/// the main queue and the second task should be executed off the main
/// queue. All the produced tasks should be executed in order, or not at all.
- (NSArray<VoidVoidBlock>*)makeAsyncLayoutTasksForViewSize:(CGSize)size
                                                completion:(nullable VoidVoidBlock)completion;


@end

NS_ASSUME_NONNULL_END
