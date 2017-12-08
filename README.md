# [![LayoutKit](https://cdn.rawgit.com/linkedin/LayoutKit/master/docs/img/layoutkit.svg)](http://layoutkit.org/)

[![CocoaPods](https://img.shields.io/cocoapods/p/LayoutKit.svg?maxAge=3601)](#)
[![GitHub release](https://img.shields.io/github/release/linkedin/layoutkit.svg?maxAge=3600)](https://github.com/linkedin/LayoutKit/releases)
[![Build Status](https://travis-ci.org/linkedin/LayoutKit.svg?branch=master)](https://travis-ci.org/linkedin/LayoutKit)
[![codecov](https://codecov.io/gh/linkedin/LayoutKit/branch/master/graph/badge.svg)](https://codecov.io/gh/linkedin/LayoutKit)

LayoutKit is a fast view layout library for iOS, macOS, and tvOS.

## Motivation

LinkedIn created LayoutKit because we have found that Auto Layout is not performant enough for complicated view hierarchies in scrollable views.
For more background, read the [blog post](https://engineering.linkedin.com/blog/2016/06/open-sourcing-layoutkit--a-fast-view-layout-library-for-ios-appl).

## Benefits

LayoutKit has many benefits over using Auto Layout:

- **Fast**: LayoutKit is as fast as manual layout code and is [significantly faster than Auto Layout](http://layoutkit.org/benchmarks).
- **Asynchronous**: Layouts can be computed in a background thread so user interactions are not interrupted.
- **Declarative**: Layouts are declared with immutable data structures. This makes layout code easier to develop, document, code review, test, debug, profile, and maintain.
- **Cacheable**: Layout results are immutable data structures so they can be precomputed in the background and cached to increase user perceived performance.

LayoutKit also provides benefits that make it as easy to use as Auto Layout:

- **UIKit friendly**: LayoutKit produces UIViews and also provides an adapter that makes it easy to use with UITableView and UICollectionView.
- **Internationalization**: LayoutKit automatically adjusts view frames for right-to-left languages.
- **Swift**: LayoutKit can be used in Swift applications and playgrounds.
- **Tested and production ready**: LayoutKit is covered by unit tests and is being used inside of recent versions of the [LinkedIn](https://itunes.apple.com/us/app/linkedin/id288429040?mt=8) and [LinkedIn Job Search](https://itunes.apple.com/us/app/linkedin-job-search/id886051313?mt=8) iOS apps.
- **Open-source**: Not a black box like Auto Layout.
- **Apache License (v2)**: Your lawyers will be happy that there are no patent shenanigans.

## Hello world

```swift
let image = SizeLayout<UIImageView>(width: 50, height: 50, config: { imageView in
    imageView.image = UIImage(named: "earth.jpg")
})

let label = LabelLayout(text: "Hello World!", alignment: .center)

let stack = StackLayout(
    axis: .horizontal,
    spacing: 4,
    sublayouts: [image, label])

let insets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 8)
let helloWorld = InsetLayout(insets: insets, sublayout: stack)
helloWorld.arrangement().makeViews(in: rootView)
```

![Hello world example layout](docs/img/helloworld.png)

## Limitations

We have found LayoutKit to be a useful tool, but you should be aware of what it is not.

* LayoutKit is not a constraint based layout system. If you wish to express a constraint between views, then those views need to be children of a single layout that implements code to enforce that constraint.
* LayoutKit is not [flexbox](https://www.w3.org/TR/css-flexbox-1/), but you may find similarities.

## Installation

LayoutKit can be installed with [CocoaPods](https://cocoapods.org/) or [Carthage](https://github.com/Carthage/Carthage).

### CocoaPods

Add this to your Podspec:
```
pod 'LayoutKit'
```

Then run `pod install`.

### Carthage

Add this to your Cartfile:
```
github "linkedin/LayoutKit"
```

Then run `carthage update`.

## Documentation

Now you are ready to start [building UI](http://layoutkit.org/building-ui).
