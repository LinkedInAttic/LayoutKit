# Building UI

This page is an overview of how to build UIs using LayoutKit.

## Basic layouts

LayoutKit provides some basic layouts:

- [LabelLayout](https://github.com/linkedin/LayoutKit/blob/master/Sources/Layouts/LabelLayout.swift): A layout for a UILabel.
- [ButtonLayout](https://github.com/linkedin/LayoutKit/blob/master/Sources/Layouts/ButtonLayout.swift): A layout for a UIButton.
- [SizeLayout](https://github.com/linkedin/LayoutKit/blob/master/Sources/Layouts/SizeLayout.swift): A layout for a specific size (e.g. UIImageView).
- [InsetLayout](https://github.com/linkedin/LayoutKit/blob/master/Sources/Layouts/InsetLayout.swift): A layout that insets its child layout (i.e. padding).
- [StackLayout](https://github.com/linkedin/LayoutKit/blob/master/Sources/Layouts/StackLayout.swift): A layout that stacks its child layouts horizontally or vertically.

Most UIs are easily expressed by nesting vertical and horizontal stacks. Nesting layouts does not adversely affect performance because because LayoutKit does not create views for layouts that do not require one (e.g. StackLayout, InsetLayout).

If you are already using UIStackView (or any other Auto Layout based stack) and are looking for a quick performance win, check out [StackView](https://github.com/linkedin/LayoutKit/blob/master/Sources/Views/StackView.swift). It is similar to UIStackView except it is much faster because it uses StackLayout.

## Defining composite layouts

It is easy to compose layouts into reusable components.

Here is an example of a reusable [MiniProfileLayout](https://github.com/linkedin/LayoutKit/blob/master/ExampleLayouts/MiniProfileLayout.swift):

```swift
import UIKit
import LayoutKit

/// A small version of a LinkedIn profile.
public class MiniProfileLayout: InsetLayout {

    public init(imageName: String, name: String, headline: String) {
        let image = SizeLayout<UIImageView>(
            width: 80,
            height: 80,
            alignment: .center,
            config: { imageView in
                imageView.image = UIImage(named: imageName)

                // Not the most performant way to do a corner radius, but this is just a demo.
                imageView.layer.cornerRadius = 40
                imageView.layer.masksToBounds = true
            }
        )

        let nameLayout = LabelLayout(text: name, font: UIFont.systemFontOfSize(40))

        let headlineLayout = LabelLayout(
            text: headline,
            font: UIFont.systemFontOfSize(20),
            config: { label in
                label.textColor = UIColor.darkGrayColor()
            }
        )

        super.init(
            insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
            sublayout: StackLayout(
                axis: .horizontal,
                spacing: 8,
                sublayouts: [
                    image,
                    StackLayout(axis: .vertical, spacing: 2, sublayouts: [nameLayout, headlineLayout])
                ]
            )
        )
    }
}
```

This is how you would use MiniProfileLayout:

```swift
let nickProfile = MiniProfileLayout(
    imageName: "nick.jpg",
    name: "Nick Snyder",
    headline: "Software Engineer at LinkedIn"
)
nickProfile.arrangement().makeViews()
```

![Nick's profile](img/nick.png)

```swift
let sergeiProfile = MiniProfileLayout(
    imageName: "sergei.jpg",
    name: "Sergei Taguer",
    headline: "Software Engineer at LinkedIn"
)
sergeiProfile.arrangement().makeViews()
```

![Sergei's profile](img/sergei.png)

More examples can be found in [ExampleLayouts](https://github.com/linkedin/LayoutKit/blob/master/ExampleLayouts).

## View configuration

Layouts generally only capture information that is necessary to compute the size and position of a layout.

All other properties that don't affect the layout of a view can be configured in the `config` closure passed to a layout's initializer.

## Flexibility

All layouts declare their [Flexibility](https://github.com/linkedin/LayoutKit/blob/master/Sources/Flexibility.swift) along each axis. It is a hint to the layout's parent that indicates the priority at which the layout should be compressed or expanded to fit the available space.

LayoutKit's basic layouts provide reasonable defaults for flexibility so you generally don't need to worry about configuring it unless you need to adjust the relative priority of sibling layouts.

## Alignment

All layouts provided by LayoutKit can be configured with an [Alignment](https://github.com/linkedin/LayoutKit/blob/master/Sources/Alignment.swift).

Alignment determines how a layout positions itself in the rect that that its parent gives it during `arrangement`.
