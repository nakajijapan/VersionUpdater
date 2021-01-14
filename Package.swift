// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "VersionUpdater",
    defaultLocalization: "en",
    platforms: [.iOS(.v11)],
    products: [.library(name: "VersionUpdater", targets: ["VersionUpdater"])],
    targets: [.target(name: "VersionUpdater", path: "Sources", resources: [.process("Resources")])]
)
