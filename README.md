![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/EFQRCode.jpg)

<p align="center">
    <a href="https://travis-ci.org/EFPrefix/EFQRCode">
        <img src="http://img.shields.io/travis/EFPrefix/EFQRCode.svg">
    </a>
    <a href="https://codecov.io/gh/EFPrefix/EFQRCode">
        <img src="https://codecov.io/gh/EFPrefix/EFQRCode/branch/master/graph/badge.svg">
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
    <a href="http://cocoapods.org/pods/EFQRCode">
        <img src="https://img.shields.io/cocoapods/p/EFQRCode.svg?style=flat">
    </a>
    <a href="https://github.com/apple/swift">
        <img src="https://img.shields.io/badge/language-swift-orange.svg">
    </a>
    <a href="https://codebeat.co/projects/github-com-efprefix-efqrcode-master">
        <img src="https://codebeat.co/badges/c2ae977c-157a-4cb7-a476-76530e7f292b">
    </a>
    <a href="https://raw.githubusercontent.com/EFPrefix/EFQRCode/master/LICENSE">
        <img src="https://img.shields.io/cocoapods/l/EFQRCode.svg?style=flat">
    </a>
    <a href="https://gitter.im/EFQRCode/Lobby">
        <img src="https://img.shields.io/gitter/room/EFPrefix/EFQRCode.svg">
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
    <a href="https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/icon/MadeWith%3C3.png">
        <img src="https://img.shields.io/badge/made%20with-%3C3-orange.svg">
    </a>
</p>

EFQRCode is a lightweight, pure-Swift library for generating pretty QRCode image with input watermark or icon and recognizing QRCode from image, it is based on `CoreGraphics`, `CoreImage` and `ImageIO`. EFQRCode provides you a better way to operate QRCode in your app, it works on `iOS`, `macOS`, `watchOS` and `tvOS`, and it is available through `CocoaPods`, `Carthage` and `Swift Package Manager`. This project is inspired by [qrcode](https://github.com/sylnsfar/qrcode). 

> [中文介绍](https://github.com/EFPrefix/EFQRCode/blob/master/README_CN.md)

## Overview

![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode5.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode6.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode7.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode8.jpg)  
:---------------------:|:---------------------:|:---------------------:|:---------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF1.gif)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF2.gif)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF7.gif)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF8.gif)  

## Demo

### App Store

You can click the `App Store` button below to download demo, support `iOS`, `tvOS` and `watchOS`:

<a target='_blank' href='https://itunes.apple.com/cn/app/EFQRCode/id1242337058?mt=8'>
    <img src='https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/icon/AppStore.jpeg' width='144' height='49'/>
</a>

You can also click the `Mac App Store` button below to download demo for `macOS`:

<a target='_blank' href='https://itunes.apple.com/cn/app/EFQRCode/id1306793539?mt=8'>
    <img src='https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/icon/AppStoreMac.png' width='168.5' height='49'/>
</a>

### Manual

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

## Installation

### CocoaPods

EFQRCode is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EFQRCode', '~> 5.1.7'
```

Try `pod 'EFQRCode/watchOS'` instead if you need to use it in watchOS.

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
github "EFPrefix/EFQRCode" ~> 5.1.7
```

Run `carthage update` to build the framework and drag the built `EFQRCode.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding EFQRCode as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .Package(url: "https://github.com/EFPrefix/EFQRCode.git", Version(5, 1, 7))
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
if let testImage = UIImage(named: "test.png")?.cgImage() {
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
    content: "https://github.com/EFPrefix/EFQRCode",
    watermark: UIImage(named: "WWF")?.cgImage()
) {
    print("Create QRCode image success: \(tryImage)")
} else {
    print("Create QRCode image failed!")
}
```

Result: 

<img src="https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/sample1.jpg" width = "36%"/>

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

<img src="https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF6.gif" width = "36%"/>

#### 5. Next

Learn more from [User Guide](https://github.com/EFPrefix/EFQRCode/blob/master/USERGUIDE.md).

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

## Other Platforms/Languages

Platforms/Languages|Link
:-------------------------|:-------------------------
Objective-C|[https://github.com/z624821876/YSQRCode](https://github.com/z624821876/YSQRCode)
Java|[https://github.com/SumiMakito/AwesomeQRCode](https://github.com/SumiMakito/AwesomeQRCode)
JavaScript|[https://github.com/SumiMakito/Awesome-qr.js](https://github.com/SumiMakito/Awesome-qr.js)
Kotlin|[https://github.com/SumiMakito/AwesomeQRCode-Kotlin](https://github.com/SumiMakito/AwesomeQRCode-Kotlin)
Python|[https://github.com/sylnsfar/qrcode](https://github.com/sylnsfar/qrcode)

## Contributors

This project exists thanks to all the people who contribute. [[Contribute](https://github.com/EFPrefix/EFQRCode/blob/master/CONTRIBUTING.md)]

<a href="https://opencollective.com/efqrcode#contributors">
    <img src="https://opencollective.com/efqrcode/contributors.svg?width=890" />
</a>

PS: The original generation code of QRCode in `watchOS` is based on [swift_qrcodejs](https://github.com/ApolloZhu/swift_qrcodejs), thanks for [ApolloZhu](https://github.com/ApolloZhu)'s work.

## Donations

If you think this project has brought you help, you can buy me a cup of coffee. If you like this project and are willing to provide further support for it's development, you can choose to become `Backer` or `Sponsor` in [Open Collective](https://opencollective.com/efqrcode).

### Backers

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/efqrcode#backer)]

<a href="https://opencollective.com/efqrcode#backers" target="_blank">
    <img src="https://opencollective.com/efqrcode/backers.svg?width=890">
</a>

### Sponsors

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

Thanks for your support, 🙏

## Thanks

- Thanks for the help from JetBrains's [Open Source Support Program](https://www.jetbrains.com/community/opensource/?from=EFQRCode).

<a href="https://www.jetbrains.com/?from=EFQRCode">
    <img src="https://raw.githubusercontent.com/EFPrefix/EFQRCode/ce8982e1858d62ac8b9fecec96f5369d8b1b62c3/logo/jetbrains.svg?sanitize=true" width = "20%">
</a>

## Apps using EFQRCode

<table>
    <tr>
        <td>
            <a href='https://www.appsight.io/app/blizzard-battle-net' title='Blizzard Battle.net'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/000/863/841/media/small.png?1506955529'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/brushfire' title='Brushfire'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/001/349/312/media/small.png?1552274504'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/826953' title='Coinomi Wallet'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/001/154/094/media/small.png?1523038915'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/join' title='Join - Medical Communication'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/001/253/338/media/small.png?1530300113'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/mume-vpn' title='Mume VPN'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/000/880/440/media/small.png?1507339273'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/mymk' title='myMK'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/001/142/715/media/small.png?1522686154'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/pilot-speech-translator' title='Pilot Speech Translator'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/000/531/486/media/small.png?1491242852'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/promgirl-shop' title='PromGirl Shop'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/001/327/819/media/small.png?1547953350'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/wifi-ch%C3%B9a' title='WiFi Chùa'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/000/282/599/media/small.png?1479441667'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/yamibuy-food-drinks-beauty-health-li' title='Yamibuy-Food&amp; Drinks, Beauty, Health, Li'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/001/324/148/media/small.png?1546987889'>
            </a>
        </td>
    </tr>
    <tr>
        <td>
            <a href='https://www.appsight.io/app/%E5%85%B3%E5%85%AB-%E5%85%A8%E6%B0%91%E5%A8%B1%E4%B9%90%E6%98%8E%E6%98%9F%E5%85%AB%E5%8D%A6%E5%A4%B4%E6%9D%A1%E6%96%B0%E9%97%BB%E8%B5%84%E8%AE%AF%E8%A7%86%E9%A2%91%E7%A4%BE%E5%8C%BA' title='关八-最懂娱乐圈'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/000/613/969/media/small.png?1495232846'>
            </a>
        </td>
        <td>
            <a href='https://www.appsight.io/app/%E7%BA%A2%E8%A2%96%E8%AF%BB%E4%B9%A6' title='红袖读书'>
                <img src='https://d3ixtyf8ei2pcx.cloudfront.net/icons/001/345/043/media/small.png?1551923326'>
            </a>
        </td>
    </tr>
</table>

## Other

Part of the pictures in the demo project and guide come from the internet. If there is any infringement of your legitimate rights and interests, please contact us to delete.

## Contact

Email: [eyrefree@eyrefree.org](mailto:eyrefree@eyrefree.org)   

## License

<a href="https://github.com/EFPrefix/EFQRCode/blob/master/LICENSE">
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/License_icon-mit-88x31-2.svg/128px-License_icon-mit-88x31-2.svg.png">
</a>

EFQRCode is available under the MIT license. See the LICENSE file for more info.
