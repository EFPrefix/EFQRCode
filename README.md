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
<a href="https://gitter.im/EFQRCode/Lobby"><img src="https://badges.gitter.im/EyreFree/EFQRCode.svg"></a>
<a href="https://twitter.com/EyreFree777"><img src="https://img.shields.io/badge/twitter-@EyreFree777-blue.svg?style=flat"></a>
<a href="http://weibo.com/eyrefree777"><img src="https://img.shields.io/badge/weibo-@EyreFree-red.svg?style=flat"></a>
</p>

EFQRCode is a lightweight, pure-Swift library for generating pretty QRCode image with input watermark or icon and recognizing QRCode from image, it is based on `CoreImage`. This project is inspired by [qrcode](https://github.com/sylnsfar/qrcode). It provides you a better way to operate QRCode in your app.

> [中文介绍](https://github.com/EyreFree/EFQRCode/blob/master/README_CN.md)

## Overview

![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode2.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode3.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode4.jpg)  
:---------------------:|:---------------------:|:---------------------:|:---------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode5.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode6.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode7.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCode8.jpg)  

## Demo

To run the example project, clone the repo, demos are in the 'Examples' folder.

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
pod "EFQRCode", '~> 1.2.4'
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
github "EyreFree/EFQRCode" ~> 1.2.4
```

Run `carthage update` to build the framework and drag the built `EFQRCode.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding EFQRCode as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .Package(url: "https://github.com/EyreFree/EFQRCode.git", Version(1, 2, 4))
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
// Common parameters:
//                         content: Content of QR Code
// inputCorrectionLevel (Optional): error-tolerant rate
//                                  L 7%
//                                  M 15%
//                                  Q 25%
//                                  H 30%(Default)
//                 size (Optional): Width and height of image
//        magnification (Optional): Magnification of QRCode compare with the minimum size
//                                  (Parameter size will be ignored if magnification is not nil)
//      backgroundColor (Optional): Background color of QRCode
//      foregroundColor (Optional): Foreground color of QRCode
//                 icon (Optional): Icon in the middle of QR Code Image and it's setting
//            watermark (Optional): Watermark background image and it's setting
//                extra (Optional): Extra parameters
```

```swift
if let tryImage = EFQRCode.generate(
    content: "https://github.com/EyreFree/EFQRCode",
    magnification: EFIntSize(width: 9, height: 9),
    watermark: EFWatermark(image: UIImage(named: "WWF")?.toCGImage(), mode: .scaleAspectFill, isColorful: false)
) {
    print("Create QRCode image success: \(tryImage)")
} else {
    print("Create QRCode image failed!")
}
```

Result: 

<img src="https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/sample1.jpg" width = "36%"/>

## User Guide

### 1. Recognition

```swift
EFQRCode.recognize(image: CGImage)
```

Or

```swift
EFQRCodeRecognizer(image: CGImage).contents
```

Two way before is exactly the same, because of the possibility of more than one two-dimensional code in the same iamge, so the return value is `[String]? ', if the return is nil means that the input data is incorrect or null. If the return array is empty, it means we can not recognize  any two-dimensional code at the image.

### 2. Generation

```swift
EFQRCode.generate(
    content: String,
    inputCorrectionLevel: EFInputCorrectionLevel,
    size: EFIntSize,
    magnification: EFIntSize?,
    backgroundColor: CIColor,
    foregroundColor: CIColor,
    icon: EFIcon?,
    watermark: EFWatermark?,
    extra: EFExtra?
)
```

Or

```swift
let generator = EFQRCodeGenerator(
    content: String,
    inputCorrectionLevel: EFInputCorrectionLevel,
    size: EFIntSize,
    magnification: EFIntSize?,
    backgroundColor: CIColor,
    foregroundColor: CIColor
)
if let tryIcon = icon {
    generator.setIcon(icon: EFIcon?)
}
if let tryWatermark = watermark {
    generator.setWatermark(watermark: EFWatermark?)
}
if let tryExtra = extra {
    generator.setExtra(extra: EFExtra?)
}

// Final two-dimensional code image we get
generator.image
```

Two way before is exactly the same, the return value is `CGImage?`, if the return is nil means that there is some wrong during the generation.

#### Parameters Explaination

* **content: String?**

Content, compulsive, capacity is limited, 1273 character most, the density of the two-dimensional lattice increases with the increase of the content. Comparison of different capacity is as follows:

10 characters | 250 characters
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareContent1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareContent2.jpg)

* **inputCorrectionLevel: EFInputCorrectionLevel**

Error-tolerant rate, optional, 4 different level, L: 7% / M 15% / Q 25% / H 30%, default is H, the definition of EFInputCorrectionLevel:

```swift
// EFInputCorrectionLevel
public enum EFInputCorrectionLevel: Int {
    case l = 0;     // L 7%
    case m = 1;     // M 15%
    case q = 2;     // Q 25%
    case h = 3;     // H 30%
}
```

Comparison of different inputCorrectionLevel:

L | M | Q | H
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareInputCorrectionLevel1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareInputCorrectionLevel2.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareInputCorrectionLevel3.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareInputCorrectionLevel4.jpg)

* **size: EFIntSize**

Two-dimensional code length, optional, default is 256 (PS: if magnification is not nil, size will be ignored), the definition of EFIntSize:

```swift
public class EFIntSize {
    public private(set) var width: Int = 0
    public private(set) var height: Int = 0

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    public func toCGSize() -> CGSize {
        return CGSize(width: self.width, height: self.height)
    }

    public func widthCGFloat() -> CGFloat {
        return CGFloat(width)
    }

    public func heightCGFloat() -> CGFloat {
        return CGFloat(height)
    }
}
```

234*234 | 312*234
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/size1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/size2.jpg)

* **magnification: EFIntSize?**

Magnification, optional, default is nil.

Because by the existence of size scaling two-dimensional code clarity is not high, if you want to get a more clear two-dimensional code, you can use magnification to set the size of the final generation of two-dimensional code. Here is the smallest ratio relative to the two-dimensional code matrix is concerned, if there is a wanted size but I hope to have a clear and size and have size approximation of the two-dimensional code by using magnification, through `maxMagnificationLessThanOrEqualTo (size: CGFloat), and `minMagnificationGreaterThanOrEqualTo (size: CGFloat), want to get magnification these two functions the specific value, the use of specific methods are as follows:

```swift
let generator = EFQRCodeGenerator(
    content: String,
    inputCorrectionLevel: EFInputCorrectionLevel,
    size: EFIntSize,
    magnification: EFIntSize?,
    backgroundColor: CIColor,
    foregroundColor: CIColor
)

// Want to get max magnification when size is less than or equalTo 600
if let magnification = generator.maxMagnificationLessThanOrEqualTo(size: 600) {
    generator.magnification = EFIntSize(width: magnification, height: magnification)
}

// Or

// Want to get min magnification when width is greater than or equalTo 600 and height is greater than or equalTo 800
// if let magnificationWidth = generator.minMagnificationGreaterThanOrEqualTo(size: 600),
//     let magnificationHeight = generator.minMagnificationGreaterThanOrEqualTo(size: 600) {
//     generator.magnification = EFIntSize(width: magnificationWidth, height: magnificationHeight)
// }

// Final two-dimensional code image
generator.image
```

size 300 | magnification 9
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareMagnification1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareMagnification2.jpg)

* **backgroundColor: CIColor**

BackgroundColor, optional, default is white.

* **foregroundColor: CIColor**

ForegroundColor, optional, color of code point, default is black.

  ForegroundColor set to red | BackgroundColor set to gray  
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareForegroundcolor.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareBackgroundcolor.jpg)

* **icon: CGImage?**

Icon image in the center of code image, optional, default is nil.

* **iconSize: CGFloat?**

Size of icon image, optional, default is 20% of size: 

  Default 20% size | Set to 64  
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareIcon.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareIconSize.jpg)

* **isIconColorful: Bool**

Is icon colorful, optional, default is `true`.

* **watermark: CGImage?**

Watermark image, optional, default is nil, for example: 

  1 | 2  
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareWatermark1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareWatermark2.jpg)

* **watermarkMode: EFWatermarkMode**

The watermark placed in two-dimensional code position, optional, default is scaleAspectFill, refer to UIViewContentMode, you can treat the two-dimensional code as UIImageView, the definition of UIViewContentMode:

```swift
// Like UIViewContentMode
public enum EFWatermarkMode: Int {
    case scaleToFill        = 0;
    case scaleAspectFit     = 1;
    case scaleAspectFill    = 2;
    case center             = 3;
    case top                = 4;
    case bottom             = 5;
    case left               = 6;
    case right              = 7;
    case topLeft            = 8;
    case topRight           = 9;
    case bottomLeft         = 10;
    case bottomRight        = 11;
}
```

* **isWatermarkColorful: Bool**

Is watermark colorful, optional, default is `true`.

* **foregroundPointOffset: CGFloat**

Foreground point offset, optional, default is 0, is not recommended to use, may make the two-dimensional code broken:

0 | 0.5 
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareForegroundPointOffset1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareForegroundPointOffset2.jpg)

* **allowTransparent: Bool**

Allow watermark image transparent, optional, default is `true`:

true | false
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareAllowTransparent1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareAllowTransparent2.jpg)

* Other

EFIcon is consist of icon, iconSize and isIconColorful, the definition is:

```swift
public struct EFIcon {
    public var image: CGImage?
    public var size: EFIntSize?
    public var isColorful: Bool = true

    public init(image: CGImage?, size: EFIntSize?, isColorful: Bool = true) {
        self.image = image
        self.size = size
        self.isColorful = isColorful
    }
}
```

EFWatermark is consist of watermark, watermarkMode and isWatermarkColorful, the definition is:

```swift
public struct EFWatermark {
    public var image: CGImage?
    public var mode: EFWatermarkMode = .scaleToFill
    public var isColorful: Bool = true

    public init(image: CGImage?, mode: EFWatermarkMode = .scaleToFill, isColorful: Bool = true) {
        self.image = image
        self.mode = mode
        self.isColorful = isColorful
    }
}
```

EFExtra is consist of foregroundPointOffset and allowTransparent, the definition is:

```swift
public struct EFExtra {
    public var foregroundPointOffset: CGFloat = 0
    public var allowTransparent: Bool = true

    public init(foregroundPointOffset: CGFloat = 0, allowTransparent: Bool = true) {
        self.foregroundPointOffset = foregroundPointOffset
        self.allowTransparent = allowTransparent
    }
}
```

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
:-------------------------:|:-------------------------:
Python|[https://github.com/sylnsfar/qrcode](https://github.com/sylnsfar/qrcode)
Android|[https://github.com/SumiMakito/AwesomeQRCode](https://github.com/SumiMakito/AwesomeQRCode)
JavaScript|[https://github.com/SumiMakito/Awesome-qr.js](https://github.com/SumiMakito/Awesome-qr.js)

## Contact

1. Email: [eyrefree@eyrefree.org](mailto:eyrefree@eyrefree.org)
2. Weibo: [@EyreFree](http://weibo.com/eyrefree777)
3. Twitter: [@EyreFree777](https://twitter.com/EyreFree777)

## License

EFQRCode is available under the MIT license. See the LICENSE file for more info.
