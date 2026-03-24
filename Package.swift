// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "VersionUpdater",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
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
            path: "Sources/Classes",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "VersionUpdaterTests",
            dependencies: ["VersionUpdater"],
            path: "VersionUpdaterTests"
        )
    ]
)
