![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/EFQRCode.jpg)

<p align="center">
<a href="https://travis-ci.org/EyreFree/EFQRCode"><img src="http://img.shields.io/travis/EyreFree/EFQRCode.svg"></a>
<a href="https://codecov.io/gh/EyreFree/EFQRCode"><img src="https://codecov.io/gh/EyreFree/EFQRCode/branch/master/graph/badge.svg"></a>
<a href="https://github.com/Carthage/Carthage/"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-ready-orange.svg"></a>
<a href="http://cocoapods.org/pods/EFQRCode"><img src="https://img.shields.io/cocoapods/v/EFQRCode.svg?style=flat"></a>
<a href="http://cocoapods.org/pods/EFQRCode"><img src="https://img.shields.io/cocoapods/p/EFQRCode.svg?style=flat"></a>
<a href="https://github.com/apple/swift"><img src="https://img.shields.io/badge/language-swift-orange.svg"></a>
<a href="https://codebeat.co/projects/github-com-eyrefree-efqrcode-master"><img src="https://codebeat.co/badges/01f53e9d-542c-4c22-adc7-d1dbff0d2a6f"></a>
<a href="https://raw.githubusercontent.com/EyreFree/EFQRCode/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/EFQRCode.svg?style=flat"></a>
<a href="https://gitter.im/EFQRCode/Lobby"><img src="https://img.shields.io/gitter/room/EyreFree/EFQRCode.svg"></a>
<a href="https://twitter.com/EyreFree777"><img src="https://img.shields.io/badge/twitter-@EyreFree777-blue.svg?style=flat"></a>
<a href="http://weibo.com/eyrefree777"><img src="https://img.shields.io/badge/weibo-@EyreFree-red.svg?style=flat"></a>
<img src="https://img.shields.io/badge/made%20with-%3C3-orange.svg">
</p>

EFQRCode is a lightweight, pure-Swift library for generating pretty QRCode image with input watermark or icon and recognizing QRCode from image, it is based on `CoreImage`. This project is inspired by [qrcode](https://github.com/sylnsfar/qrcode). It provides you a better way to operate QRCode in your app.

> [中文介绍](https://github.com/EyreFree/EFQRCode/blob/master/README_CN.md)

## Overview

![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode2.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode3.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode4.jpg)  
:---------------------:|:---------------------:|:---------------------:|:---------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode5.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode6.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode7.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode8.jpg)  

## Demo

### AppStore

You can click the AppStore button below to download demo, support iOS and tvOS.

<a target='_blank' href='https://itunes.apple.com/cn/app/EFQRCode/id1242337058?mt=8'>
	<img src='http://ww2.sinaimg.cn/large/0060lm7Tgw1f1hgrs1ebwj308102q0sp.jpg' width='144' height='49'/>
</a>

### Manual

To run the example project manually, clone the repo, demos are in the 'Examples' folder.

Or you can run the following command in terminal:

```bash
git clone git@github.com:EyreFree/EFQRCode.git; cd EFQRCode/Examples/iOS; open 'iOS Example.xcodeproj'
```

## Requirements

- XCode 8.0+
- Swift 3.0+
- iOS 8.0+ / macOS 10.11+ / tvOS 9.0+

## Installation

### CocoaPods

EFQRCode is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "EFQRCode", '~> 1.2.5'
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
github "EyreFree/EFQRCode" ~> 1.2.5
```

Run `carthage update` to build the framework and drag the built `EFQRCode.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding EFQRCode as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .Package(url: "https://github.com/EyreFree/EFQRCode.git", Version(1, 2, 5))
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

#### 4. Next

Learn more from [User Guide](https://github.com/EyreFree/EFQRCode/blob/master/USERGUIDE.md).

## Todo

- [ ] Support GIF
- [ ] Support more styles

## PS

1. Please select a high contrast foreground and background color combinations;
2. You should use `magnification` instead of `size` if you want to improve the definition of QRCode image, you can also increase the value of them;
3. Magnification too high／Size too long／Content too much may cause failure;
4. It is recommended to test the QRCode image before put it into use;
5. You can contact me if there is any problem, both `Issue` and `Pull request` are welcome.

PS of PS: I wish you can click the `Star` button if this tool is useful for you, thanks, QAQ...

## Other Platforms/Languages

Platforms/Languages|Link
:-------------------------|:-------------------------
Java|[https://github.com/SumiMakito/AwesomeQRCode](https://github.com/SumiMakito/AwesomeQRCode)
JavaScript|[https://github.com/SumiMakito/Awesome-qr.js](https://github.com/SumiMakito/Awesome-qr.js)
Kotlin|[https://github.com/SumiMakito/AwesomeQRCode-Kotlin](https://github.com/SumiMakito/AwesomeQRCode-Kotlin)
Python|[https://github.com/sylnsfar/qrcode](https://github.com/sylnsfar/qrcode)

## Contact

Email: [eyrefree@eyrefree.org](mailto:eyrefree@eyrefree.org)   
Weibo: [@EyreFree](http://weibo.com/eyrefree777)   
Twitter: [@EyreFree777](https://twitter.com/EyreFree777)   

## License

![](https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/License_icon-mit-88x31-2.svg/128px-License_icon-mit-88x31-2.svg.png)

EFQRCode is available under the MIT license. See the LICENSE file for more info.
