![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/EFQRCode.jpg)

<p align="center">
    <a href="https://travis-ci.org/EFPrefix/EFQRCode">
        <img src="https://img.shields.io/travis/EFPrefix/EFQRCode.svg">
    </a>
    <a href="https://codecov.io/gh/EFPrefix/EFQRCode">
        <img src="https://codecov.io/gh/EFPrefix/EFQRCode/branch/main/graph/badge.svg">
    </a>
    <a href="https://efprefix.github.io/EFQRCode/">
        <img src="https://efprefix.github.io/EFQRCode/badge.svg">
    </a>
    <a href="https://github.com/Carthage/Carthage/">
        <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat">
    </a>
    <a href="https://swift.org/package-manager/">
        <img src="https://img.shields.io/badge/SPM-ready-orange.svg">
    </a>
    <a href="http://cocoapods.org/pods/EFQRCode">
        <img src="https://img.shields.io/cocoapods/v/EFQRCode.svg?style=flat">
    </a>
    <a href="https://swiftpackageindex.com/EFPrefix/EFQRCode">
        <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FEFPrefix%2FEFQRCode%2Fbadge%3Ftype%3Dplatforms" alt="Compatible with all Platforms">
    </a>
    <a href="https://github.com/apple/swift">
        <img src="https://img.shields.io/badge/language-swift-orange.svg">
    </a>
    <a href="https://codebeat.co/projects/github-com-efprefix-efqrcode-master">
        <img src="https://codebeat.co/badges/c2ae977c-157a-4cb7-a476-76530e7f292b">
    </a>
    <a href="https://raw.githubusercontent.com/EFPrefix/EFQRCode/main/LICENSE">
        <img src="https://img.shields.io/cocoapods/l/EFQRCode.svg?style=flat">
    </a>
    <a href="https://app.fossa.com/projects/git%2Bgithub.com%2FEFPrefix%2FEFQRCode?ref=badge_shield">
        <img src="https://app.fossa.com/api/projects/git%2Bgithub.com%2FEFPrefix%2FEFQRCode.svg?type=shield">
    </a>
</p>

EFQRCode is a lightweight, pure-Swift library for generating stylized QRCode images with watermark or icon, and for recognizing QRCode from images, inspired by [qrcode](https://github.com/sylnsfar/qrcode). Based on `CoreGraphics`, `CoreImage`, and `ImageIO`, EFQRCode provides you a better way to handle QRCode in your app, no matter if it is on iOS, macOS, watchOS, and/or tvOS. You can integrate EFQRCode through CocoaPods, Carthage, and/or Swift Package Manager.

> [中文介绍](https://github.com/EFPrefix/EFQRCode/blob/main/README_CN.md)

## Examples

![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode5.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode6.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode7.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode8.jpg)  
:---------------------:|:---------------------:|:---------------------:|:---------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF1.gif)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF2.gif)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF7.gif)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF8.gif)  

## Demo Projects

### App Store

You can click the `App Store` button below to download demo, support iOS, tvOS and watchOS:

<a target='_blank' href='https://itunes.apple.com/app/EFQRCode/id1242337058?mt=8'>
    <img src='https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/icon/AppStore.jpeg' width='144' height='49'/>
</a>

You can also click the `Mac App Store` button below to download demo for macOS:

<a target='_blank' href='https://itunes.apple.com/app/EFQRCode/id1306793539?mt=8'>
    <img src='https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/icon/AppStoreMac.png' width='168.5' height='49'/>
</a>

### Compile Demo Manually

To run the example project manually, clone the repo, demos are in the 'Examples' folder, remember run command `sh Startup.sh` in terminal to get all dependencies first, then open `EFQRCode.xcworkspace` with Xcode and select the target you want, run.

Or you can run the following command in terminal:

```bash
git clone git@github.com:EFPrefix/EFQRCode.git; cd EFQRCode; sh Startup.sh; open 'EFQRCode.xcworkspace'
```

## Requirements

| Version | Needs                                                                          |
|:--------|:-------------------------------------------------------------------------------|
| 1.x     | Xcode 8.0+<br>Swift 3.0+<br>iOS 8.0+ / macOS 10.11+ / tvOS 9.0+                |
| 4.x     | Xcode 9.0+<br>Swift 4.0+<br>iOS 8.0+ / macOS 10.11+ / tvOS 9.0+ / watchOS 2.0+ |
| 5.x     | Xcode 11.1+<br>Swift 5.0+<br>iOS 8.0+ / macOS 10.11+ / tvOS 9.0+ / watchOS 2.0+|
| **6.x** | Xcode 12.0+<br>[![latest Swift](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FEFPrefix%2FEFQRCode%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/EFPrefix/EFQRCode)<br>iOS 9.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+|

## Installation

### CocoaPods

EFQRCode is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EFQRCode', '~> 6.2.2'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

> ***IMPORTANT***: this [workaround](https://github.com/Carthage/Carthage/blob/master/Documentation/Xcode12Workaround.md) is necessary for Carthage to somewhat work in Xcode 12.

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate EFQRCode into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "EFPrefix/EFQRCode" ~> 6.2.2
```

Run `carthage update` to build the framework and drag the built `EFQRCode.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the Swift compiler.

Once you have your Swift package set up, adding EFQRCode as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/EFPrefix/EFQRCode.git", .upToNextMinor(from: "6.2.2"))
]
```

## Quick Start

#### 1. Import EFQRCode

Import EFQRCode module where you want to use it:

```swift
import EFQRCode
```

#### 2. Recognition

A String Array is returned as there might be several QR Codes in a single `CGImage`:

```swift
if let testImage = UIImage(named: "test.png")?.cgImage {
    let codes = EFQRCode.recognize(testImage)
    if !codes.isEmpty {
        print("There are \(codes.count) codes")
        for (index, code) in codes.enumerated() {
            print("The content of QR Code \(index) is \(code).")
        }
    } else {
        print("There is no QR Codes in testImage.")
    }
}
```

#### 3. Generation

Create QR Code image, basic usage:

|Parameter|Description|
|-:|:-|
|`content`|***REQUIRED***, content of QR Code|
|`size`|Width and height of image|
|`backgroundColor`|Background color of QRCode|
|`foregroundColor`|Foreground color of QRCode|
|`watermark`|Background image of QRCode|

```swift
if let image = EFQRCode.generate(
    for: "https://github.com/EFPrefix/EFQRCode",
    watermark: UIImage(named: "WWF")?.cgImage
) {
    print("Create QRCode image success \(image)")
} else {
    print("Create QRCode image failed!")
}
```

Result: 

<img src="https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/sample1.jpg" width = "36%"/>

#### 4. Generation from GIF

Use `EFQRCode.generateGIF` to create GIF QRCode.

|Parameter|Description|
|-:|:-|
|`generator`|***REQUIRED***, an `EFQRCodeGenerator` instance with other settings|
|`data`|***REQUIRED***, encoded input GIF|
|`delay`|Output QRCode GIF delay, emitted means no change|
|`loopCount`|Times looped in GIF, emitted means no change|

```swift
if let qrCodeData = EFQRCode.generateGIF(
    using: generator, withWatermarkGIF: data
) {
    print("Create QRCode image success.")
} else {
    print("Create QRCode image failed!")
}
```

You can get more information from the demo, result will like this:

<img src="https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF6.gif" width = "36%"/>

#### 5. Next

Learn more from [User Guide](https://github.com/EFPrefix/EFQRCode/blob/main/USERGUIDE.md).

## Recommendations

1. Please select a high contrast foreground and background color combinations;
2. To improve the definition of QRCode images, increase `size`, or scale up using `magnification` (instead);
3. Magnification too high／size too large／contents too long may cause failure;
4. It is recommended to test the QRCode image before put it into use;
5. You can contact me if there is any problem, both `Issue` and `Pull request` are welcome.

PS of PS: I wish you can click the `Star` button if this tool is useful for you, thanks, QAQ...

## Other Platforms/Languages

Platforms/Languages|Link
:-------------------------|:-------------------------
Objective-C|[https://github.com/z624821876/YSQRCode](https://github.com/z624821876/YSQRCode)
Java|[https://github.com/SumiMakito/AwesomeQRCode](https://github.com/SumiMakito/AwesomeQRCode)
JavaScript|[https://github.com/SumiMakito/Awesome-qr.js](https://github.com/SumiMakito/Awesome-qr.js)
Kotlin|[https://github.com/SumiMakito/AwesomeQRCode-Kotlin](https://github.com/SumiMakito/AwesomeQRCode-Kotlin)
Python|[https://github.com/sylnsfar/qrcode](https://github.com/sylnsfar/qrcode)

## Contributors

This project exists thanks to all the people who already contributed to us. [[Contribute](https://github.com/EFPrefix/EFQRCode/blob/main/.github/CONTRIBUTING.md)]

<a href="https://opencollective.com/efqrcode#contributors">
    <img src="https://opencollective.com/efqrcode/contributors.svg?width=890" />
</a>

## Backers

If you think this project has brought you help, you can buy me a cup of coffee. If you like this project and are willing to provide further support for it's development, you can choose to become `Backer` in [Open Collective](https://opencollective.com/efqrcode). Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/efqrcode#backer)]

<a href="https://opencollective.com/efqrcode#backers" target="_blank">
    <img src="https://opencollective.com/efqrcode/backers.svg?width=890">
</a>

## Sponsors

- Thanks for the help from MacStadium's [Open Source Program](https://www.macstadium.com/opensource?from=EFQRCode).

<a href="https://macstadium.com/?from=EFQRCode">
    <img src="https://uploads-ssl.webflow.com/5ac3c046c82724970fc60918/5c019d917bba312af7553b49_MacStadium-developerlogo.png" width = "46%">
</a>

- Thanks for the help from JetBrains's [Open Source Support Program](https://www.jetbrains.com/community/opensource/?from=EFQRCode).

<a href="https://www.jetbrains.com/?from=EFQRCode">
    <img src="https://raw.githubusercontent.com/EFPrefix/EFQRCode/ce8982e1858d62ac8b9fecec96f5369d8b1b62c3/logo/jetbrains.svg?sanitize=true" width = "20%">
</a>

## Other

Part of the pictures in the demo project and guide come from the internet. If there is any infringement of your legitimate rights and interests, please contact us to delete.

## Contact

Email: [eyrefree@eyrefree.org](mailto:eyrefree@eyrefree.org)   

## License

<a href="https://github.com/EFPrefix/EFQRCode/blob/main/LICENSE">
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/License_icon-mit-88x31-2.svg/128px-License_icon-mit-88x31-2.svg.png">
</a>

EFQRCode is available under the MIT license. See the LICENSE file for more info.
