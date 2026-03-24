# VersionUpdater

[![License](https://img.shields.io/cocoapods/l/VersionUpdater.svg?style=flat)](http://cocoapods.org/pods/VersionUpdater)
[![Platform](https://img.shields.io/cocoapods/p/VersionUpdater.svg?style=flat)](http://cocoapods.org/pods/VersionUpdater)

Inform users about new app version releases and optionally force updates.

Inspired by: https://github.com/kazu0620/SRGVersionUpdater (Objective-C)

## Requirements

- iOS 15.0+
- Xcode 15+
- Swift 5.9+

## Installation

### Swift Package Manager (Recommended)

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/nakajijapan/VersionUpdater.git", from: "2.0.0")
]
```

Or add it via Xcode: File > Add Package Dependencies and enter the repository URL.

### CocoaPods

```ruby
pod "VersionUpdater", "~> 2.0"
```

## Usage

### JSON Endpoint

Provide a JSON endpoint that returns version information:

```json
{
    "required_version": "2.0.0",
    "type": "force",
    "update_url": "https://apps.apple.com/app/id123456789"
}
```

- `type`: `"force"` (only download button) or `"optional"` (download + cancel buttons)

### Basic Usage

```swift
import VersionUpdater

let updater = VersionUpdater(
    endPointURL: URL(string: "https://example.com/ios.json")!
)

Task {
    try await updater.executeVersionCheck()
}
```

### Custom Alert Text

```swift
let updater = VersionUpdater(
    endPointURL: URL(string: "https://example.com/ios.json")!,
    customAlertTitle: "Update Available",
    customAlertBody: "A new version is available."
)
```

### Fetch Version Info Without UI

```swift
let info = try await updater.fetchVersionInfo()
print(info.requiredVersion) // "2.0.0"
print(info.type)            // .force or .optional
```

### Version Comparison

```swift
let needsUpdate = updater.isUpdateNeeded(
    currentVersion: "1.0.0",
    requiredVersion: "2.0.0"
)
```

## Author

nakajijapan, pp.kupepo.gattyanmo@gmail.com

## License

VersionUpdater is available under the MIT license. See the LICENSE file for more info.
