// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "LayoutKit",
    // platforms: [.iOS("8.0"), .macOS("10.10"), tvOS("9.0")],
    products: [
        .library(name: "LayoutKit", targets: ["LayoutKit"])
    ],
    targets: [
        .target(
            name: "LayoutKit",
            path: "Sources"
        )
    ]
)
