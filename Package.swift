// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "VersionUpdater",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
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
    ]
)
