![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/EFQRCode.jpg)

<p align="center">
    <a href="https://travis-ci.org/EyreFree/EFQRCode">
        <img src="http://img.shields.io/travis/EyreFree/EFQRCode.svg">
    </a>
    <a href="https://codecov.io/gh/EyreFree/EFQRCode">
        <img src="https://codecov.io/gh/EyreFree/EFQRCode/branch/master/graph/badge.svg">
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
    <a href="http://cocoapods.org/pods/EFQRCode">
        <img src="https://img.shields.io/cocoapods/p/EFQRCode.svg?style=flat">
    </a>
    <a href="https://github.com/apple/swift">
        <img src="https://img.shields.io/badge/language-swift-orange.svg">
    </a>
    <a href="https://codebeat.co/projects/github-com-eyrefree-efqrcode-master">
        <img src="https://codebeat.co/badges/01f53e9d-542c-4c22-adc7-d1dbff0d2a6f">
    </a>
    <a href="https://raw.githubusercontent.com/EyreFree/EFQRCode/master/LICENSE">
        <img src="https://img.shields.io/cocoapods/l/EFQRCode.svg?style=flat">
    </a>
    <a href="https://gitter.im/EFQRCode/Lobby">
        <img src="https://img.shields.io/gitter/room/EyreFree/EFQRCode.svg">
    </a>
    <a href="#backers" alt="sponsors on Open Collective">
        <img src="https://opencollective.com/EFQRCode/backers/badge.svg" />
    </a>
    <a href="#sponsors" alt="Sponsors on Open Collective">
        <img src="https://opencollective.com/EFQRCode/sponsors/badge.svg" />
    </a>
    <a href="https://twitter.com/EyreFree777">
        <img src="https://img.shields.io/badge/twitter-@EyreFree777-blue.svg?style=flat">
    </a>
    <a href="http://weibo.com/eyrefree777">
        <img src="https://img.shields.io/badge/weibo-@EyreFree-red.svg?style=flat">
    </a>
    <a href="https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/icon/MadeWith%3C3.png">
        <img src="https://img.shields.io/badge/made%20with-%3C3-orange.svg">
    </a>
</p>

EFQRCode is a lightweight, pure-Swift library for generating pretty QRCode image with input watermark or icon and recognizing QRCode from image, it is based on `CoreGraphics`, `CoreImage` and `ImageIO`. EFQRCode provides you a better way to operate QRCode in your app, it works on `iOS`, `macOS`, `watchOS` and `tvOS`, and it is available through `CocoaPods`, `Carthage` and `Swift Package Manager`. This project is inspired by [qrcode](https://github.com/sylnsfar/qrcode). 

> [中文介绍](/README_CN.md)

## Overview

![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode5.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode6.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode7.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode8.jpg)  
:---------------------:|:---------------------:|:---------------------:|:---------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCodeGIF1.gif)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCodeGIF2.gif)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCodeGIF7.gif)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCodeGIF8.gif)  

## Demo

### App Store

You can click the `App Store` button below to download demo, support iOS and tvOS:

<a target='_blank' href='https://itunes.apple.com/cn/app/EFQRCode/id1242337058?mt=8'>
    <img src='https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/icon/AppStore.jpeg' width='144' height='49'/>
</a>

You can also click the `Mac App Store` button below to download demo for macOS:

<a target='_blank' href='https://itunes.apple.com/cn/app/EFQRCode/id1306793539?mt=8'>
    <img src='https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/icon/AppStoreMac.png' width='168.5' height='49'/>
</a>

### Manual

To run the example project manually, clone the repo, demos are in the 'Examples' folder.

Or you can run the following command in terminal:

```bash
git clone git@github.com:EyreFree/EFQRCode.git; cd EFQRCode/Examples/iOS; open 'iOS Example.xcodeproj'
```

## Requirements

| Version | Needs                                                           |
|:--------|:----------------------------------------------------------------|
| 1.x     | XCode 8.0+<br>Swift 3.0+<br>iOS 8.0+ / macOS 10.11+ / tvOS 9.0+ |
| 4.x     | XCode 9.0+<br>Swift 4.0+<br>iOS 8.0+ / macOS 10.11+ / tvOS 9.0+ |

## Installation

### CocoaPods

EFQRCode is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "EFQRCode", '~> 4.3.0'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate EFQRCode into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "EyreFree/EFQRCode" ~> 4.3.0
```

Run `carthage update` to build the framework and drag the built `EFQRCode.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding EFQRCode as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .Package(url: "https://github.com/EyreFree/EFQRCode.git", Version(4, 2, 1))
]
```

## Quick Start

#### 1. Import EFQRCode

Import EFQRCode module where you want to use it:

```swift
import EFQRCode
```

#### 2. Recognition

Get QR Codes from CGImage, maybe there are several codes in a image, so it will return an array:

```swift
if let testImage = UIImage(named: "test.png")?.toCGImage() {
    if let tryCodes = EFQRCode.recognize(image: testImage) {
        if tryCodes.count > 0 {
            print("There are \(tryCodes.count) codes in testImage.")
            for (index, code) in tryCodes.enumerated() {
                print("The content of \(index) QR Code is: \(code).")
            }
        } else {
            print("There is no QR Codes in testImage.")
        }
    } else {
        print("Recognize failed, check your input image!")
    }
}
```

#### 3. Generation

Create QR Code image, quick usage:

```swift
//                    content: Content of QR Code
//            size (Optional): Width and height of image
// backgroundColor (Optional): Background color of QRCode
// foregroundColor (Optional): Foreground color of QRCode
//       watermark (Optional): Background image of QRCode
```

```swift
if let tryImage = EFQRCode.generate(
    content: "https://github.com/EyreFree/EFQRCode",
    watermark: UIImage(named: "WWF")?.toCGImage()
) {
    print("Create QRCode image success: \(tryImage)")
} else {
    print("Create QRCode image failed!")
}
```

Result: 

<img src="https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/sample1.jpg" width = "36%"/>

#### 4. Generation from GIF

You can create GIF QRCode with function `generateWithGIF` of class `EFQRCode`, for example:

```swift
//                  data: Data of input GIF
//             generator: An object of EFQRCodeGenerator, use for setting
// pathToSave (Optional): Path to save the output GIF, default is temp path
//      delay (Optional): Output QRCode GIF delay, default is same as input GIF
//  loopCount (Optional): Output QRCode GIF loopCount, default is same as input GIF
```

```swift
if let qrcodeData = EFQRCode.generateWithGIF(data: data, generator: generator) {
    print("Create QRCode image success.")
} else {
    print("Create QRCode image failed!")
}
```

You can get more information from the demo, result will like this:

<img src="https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCodeGIF6.gif" width = "36%"/>

#### 5. Next

Learn more from [User Guide](/.github/USERGUIDE.md).

## Todo

- [x] Support GIF
- [ ] Support more styles

## PS

1. Please select a high contrast foreground and background color combinations;
2. You should use `magnification` instead of `size` if you want to improve the definition of QRCode image, you can also increase the value of them;
3. Magnification too high／Size too long／Content too much may cause failure;
4. It is recommended to test the QRCode image before put it into use;
5. You can contact me if there is any problem, both `Issue` and `Pull request` are welcome.

PS of PS: I wish you can click the `Star` button if this tool is useful for you, thanks, QAQ...

## Other

The original generation code of QRCode in `watchOS` is based on [swift_qrcodejs](https://github.com/ApolloZhu/swift_qrcodejs)，thanks for [ApolloZhu](https://github.com/ApolloZhu)'s work.

## Other Platforms/Languages

Platforms/Languages|Link
:-------------------------|:-------------------------
Java|[https://github.com/SumiMakito/AwesomeQRCode](https://github.com/SumiMakito/AwesomeQRCode)
JavaScript|[https://github.com/SumiMakito/Awesome-qr.js](https://github.com/SumiMakito/Awesome-qr.js)
Kotlin|[https://github.com/SumiMakito/AwesomeQRCode-Kotlin](https://github.com/SumiMakito/AwesomeQRCode-Kotlin)
Python|[https://github.com/sylnsfar/qrcode](https://github.com/sylnsfar/qrcode)

## Contributors

This project exists thanks to all the people who contribute. [[Contribute](/.github/CONTRIBUTING.md)]

<a href="https://opencollective.com/efqrcode#contributors">
    <img src="https://opencollective.com/efqrcode/contributors.svg?width=890" />
</a>

## Backers

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/efqrcode#backer)]

<a href="https://opencollective.com/efqrcode#backers" target="_blank">
    <img src="https://opencollective.com/efqrcode/backers.svg?width=890">
</a>

## Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website. [[Become a sponsor](https://opencollective.com/efqrcode#sponsor)]

<a href="https://opencollective.com/efqrcode/sponsor/0/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/0/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/1/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/1/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/2/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/2/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/3/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/3/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/4/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/4/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/5/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/5/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/6/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/6/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/7/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/7/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/8/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/8/avatar.svg">
</a>
<a href="https://opencollective.com/efqrcode/sponsor/9/website" target="_blank">
    <img src="https://opencollective.com/efqrcode/sponsor/9/avatar.svg">
</a>

## Donations

If you think this project has brought you help, you can buy me a cup of coffee. If you like this project and are willing to provide further support for it's development, you can choose to become `Backer` or `Sponsor` in [Open Collective](https://opencollective.com/efqrcode).

If you don't have a `Open Collective` account or you think it is too complicated, the following way of payment is also supported:

![AliPay](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode/AliPay.jpg?raw=true)|![WeChat](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode/WeChat.jpg?raw=true)|![PayPal](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode/PayPal.jpg?raw=true)  
:---------------------:|:---------------------:|:---------------------:

Thank you for your support, 🙏!

## Contact

Email: [eyrefree@eyrefree.org](mailto:eyrefree@eyrefree.org)   

## License

<a href="https://github.com/EyreFree/EFQRCode/blob/master/LICENSE">
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/License_icon-mit-88x31-2.svg/128px-License_icon-mit-88x31-2.svg.png">
</a>

EFQRCode is available under the MIT license. See the LICENSE file for more info.
