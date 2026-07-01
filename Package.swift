// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "VersionUpdater",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "VersionUpdater",
            targets: ["VersionUpdater"]
        )
    ],
    targets: [
        .target(
            name: "VersionUpdater",
            path: "Sources/Classes"
        ),
        .testTarget(
            name: "VersionUpdaterTests",
            dependencies: ["VersionUpdater"],
            path: "VersionUpdaterTests"
        )
    ],
    swiftLanguageModes: [.v6]
)
