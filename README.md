# VersionUpdater

[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/VersionUpdater.svg?style=flat)](http://cocoapods.org/pods/VersionUpdater)
[![License](https://img.shields.io/cocoapods/l/VersionUpdater.svg?style=flat)](http://cocoapods.org/pods/VersionUpdater)
[![Platform](https://img.shields.io/cocoapods/p/VersionUpdater.svg?style=flat)](http://cocoapods.org/pods/VersionUpdater)

VersionUpdater inform users about new app version release, and can force users update the application to the version.

Inspired: https://github.com/kazu0620/SRGVersionUpdater (Objective-C)

## Requirements

- iOS 10.0+
- Xcode 10+
- Swift 5.2+

#### Swift Package Manager

Add via Xcode in the [usual way](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)


## CocoaPods

VersionUpdater is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:


```ruby
pod "VersionUpdater"
```

Then, run the following code:

```ruby
$ pod install
```

## Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager for Cocoa applications.

``` bash
$ brew update
$ brew install carthage
```

To integrate VersionUpdater into your Xcode project using Carthage, specify it in your `Cartfile`:

``` ogdl
github "nakajijapan/VersionUpdater"
```

Then, run the following command to build the VersionUpdater framework:

``` bash
$ carthage update
```

## Author

nakajijapan, pp.kupepo.gattyanmo@gmail.com

## License

VersionUpdater is available under the MIT license. See the LICENSE file for more info.
