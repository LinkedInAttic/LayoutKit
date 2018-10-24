// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "Component.h"

NS_ASSUME_NONNULL_BEGIN

// MARK: - ExpandableTextComponentRecord

@interface ExpandableTextComponentRecord : ComponentRecord<NSNumber *, NSString *>

- (nonnull instancetype)initWithText:(nullable NSString *)text initiallyExpanded:(BOOL)isExpanded;

- (nonnull instancetype)copyWithText:(nullable NSString *)text;

- (nonnull instancetype)copyWithExpandedState:(BOOL)expanded;

@property (nonatomic, strong, nullable, readonly) NSString *text;

@property (nonatomic, assign, readonly) BOOL isExpanded;

@end

// MARK: - ExpandableTextComponent

@interface ExpandableTextComponent : Component<ExpandableTextComponentRecord *>

- (nonnull instancetype)initWithText:(nullable NSString *)text initiallyExpanded:(BOOL)isExpanded;
- (nonnull instancetype)initWithState:(nullable id)state data:(nullable id)data NS_UNAVAILABLE;

@property (nonatomic, strong, nonnull, readwrite) ExpandableTextComponentRecord *currentRecord;

@end

NS_ASSUME_NONNULL_END
