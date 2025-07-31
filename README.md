![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/EFQRCode.jpg)

<p align="center">
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
    <a href="https://raw.githubusercontent.com/EFPrefix/EFQRCode/main/LICENSE">
        <img src="https://img.shields.io/cocoapods/l/EFQRCode.svg?style=flat">
    </a>
</p>

EFQRCode is a lightweight, pure-Swift library for generating stylized QRCode images with watermark or icon, and for recognizing QRCode from images, inspired by [qrcode](https://github.com/sylnsfar/qrcode) and [react-qrbtf](https://github.com/CPunisher/react-qrbtf). Based on `CoreGraphics`, `CoreImage`, and `ImageIO`, EFQRCode provides you a better way to handle QRCode in your app, no matter if it is on iOS, macOS, watchOS, tvOS, and/or visionOS. You can integrate EFQRCode through CocoaPods, Carthage, and/or Swift Package Manager.

> [中文介绍](https://github.com/EFPrefix/EFQRCode/blob/main/README_CN.md)

## Examples

![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode5.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode6.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode7.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCode8.jpg)  
:---------------------:|:---------------------:|:---------------------:|:---------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/7sample7.JPG)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/7sample8.JPG)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/7sample2.GIF)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/7sample13.JPG)  
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/7sample4.GIF)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/7sample15.JPG)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/7sample16.JPG)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/7sample1.GIF)  

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

iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+ / visionOS 1.0+

## Installation

### CocoaPods

EFQRCode is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EFQRCode', '~> 7.0.2'
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
github "EFPrefix/EFQRCode" ~> 7.0.2
```

Run `carthage update` to build the framework and drag the built `EFQRCode.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the Swift compiler.

Once you have your Swift package set up, adding EFQRCode as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/EFPrefix/EFQRCode.git", .upToNextMinor(from: "7.0.2"))
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
    let codes = EFQRCode.Recognizer(image: testImage).recognize()
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

##### 3.1 Create QR Code with static image

```swift
let generator = try? EFQRCode.Generator("https://github.com/EFPrefix/EFQRCode", style: .image(
    params: .init(image: .init(image: .static(image: UIImage(named: "WWF")?.cgImage!), allowTransparent: true)))
)
if let image = try? generator?.toImage(width: 180).cgImage {
    print("Create QRCode image success \(image)")
} else {
    print("Create QRCode image failed!")
}
```

Result: 

<img src="https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/sample1.jpg" width = "36%"/>

##### 3.2 Generation from animated images

You can create a dynamic QR code by passing in a sequence of animated images. The usage method is as follows:

```swift
let generator = try? EFQRCode.Generator("https://github.com/EFPrefix/EFQRCode", style: .image(
    params: .init(image: .init(image: .animated(images: cgImages, imageDelays: cgImageDelays))))
)
if let imageData = try? generator?.toGIFData(width: 512) {
    print("Create QRCode image success \(imageData)")
} else {
    print("Create QRCode image failed!")
}
```

You can get more information from the demo, result will like this:

<img src="https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF6.gif" width = "36%"/>

##### 3.3 Exportable types

- Static: NSImage, UIImage, PDF, PNG, JPEG
- Animated: APNG, GIF, SVG, MOV, MP4, M4V

#### 4. Next

Learn more from [DeepWiki](https://deepwiki.com/EFPrefix/EFQRCode).

## Recommendations

1. Please select a high contrast foreground and background color combinations;
2. To improve the definition of QRCode images, increase `size`;
3. Oversized generation dimensions, excessive QR code content, and overly large imported media may lead to generation failures;
4. It is recommended to test the QRCode image before put it into use;
5. Any contributing and pull requests are warmly welcome;
6. Part of the pictures in the demo project and guide come from the internet. If there is any infringement of your legitimate rights and interests, please contact us to delete.

## Contributors

<a href="https://opencollective.com/efqrcode#contributors">
    <img src="https://opencollective.com/efqrcode/contributors.svg?width=890"/>
</a>

## Backers

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

## Contact

Twitter: [@EyreFree777](https://x.com/eyrefree777)   
Weibo: [@EyreFree](https://weibo.com/eyrefree777)   
Email: [eyrefree@eyrefree.org](mailto:eyrefree@eyrefree.org)   

## License

<a href="https://github.com/EFPrefix/EFQRCode/blob/main/LICENSE">
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/License_icon-mit-88x31-2.svg/128px-License_icon-mit-88x31-2.svg.png">
</a>

EFQRCode is available under the MIT license. See the LICENSE file for more info.
