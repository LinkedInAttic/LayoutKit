# Interfacing with UIKit

This page guides you through the process of interfacing with UIKit.

## Threading

There are three steps to the layout process.

1. Instantiate a layout object.
2. Compute the layout's view frames.
3. Instantiate views and assign frames.

Unlike UIKit, LayoutKit can perform steps #1 and #2 on a background thread, but doing so is completely optional.

Examples:

- [BackgroundMiniProfileViewController](https://github.com/linkedin/LayoutKit/blob/master/LayoutKitSampleApp/BackgroundMiniProfileViewController.swift)
- [ForegroundMiniProfileViewController](https://github.com/linkedin/LayoutKit/blob/master/LayoutKitSampleApp/ForegroundMiniProfileViewController.swift)

LayoutKit is faster than Auto Layout by default so it is perfectly fine to not bother with background layout if performance on the main thread is acceptable.

## UICollectionView and UITableView

If you have a UICollectionView or UITableView and all of the cells use LayoutKit, then you can use [ReloadableViewLayoutAdapter](https://github.com/linkedin/LayoutKit/blob/master/Sources/Views/ReloadableViewLayoutAdapter.swift) to automatically handle computing cell layouts on a background thread.

## Mixing Auto Layout and LayoutKit

If you have a UI that mixes LayoutKit and Auto Layout (e.g. some cells use LayoutKit and others use Auto Layout), then you may want to avoid the additional complexity of background layout.

Instead, perform all layout computations on the main thread (similar to how [StackView](https://github.com/linkedin/LayoutKit/blob/master/Sources/Views/StackView.swift) is implemented).

## StackView

If you don't want to think about layouts or threading, [StackView](https://github.com/linkedin/LayoutKit/blob/master/Sources/Views/StackView.swift) is an easy way to start taking advantage of the performance of LayoutKit.

- It is similar to UIStackView except it uses LayoutKit's StackLayout algorithm to efficiently stack subviews.
- It is faster than UIStackView and it is also faster than manually stacking views with Auto Layout.

You can use StackView like any other UIView, but there are a few extra considerations that you need to be aware of
if you want to use it with Auto Layout (please read StackView's class documentation).

## Summary

We recommend choosing the simplest option that works with any existing code that you have and achieves acceptable performance.
