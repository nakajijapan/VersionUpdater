// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "VersionUpdater",
    platforms: [.iOS(.v11)],
    products: [.library(name: "VersionUpdater", targets: ["VersionUpdater"])],
    targets: [.target(name: "VersionUpdater", path: "Sources")]
)
