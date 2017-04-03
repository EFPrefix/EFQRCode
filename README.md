![](assets/EFQRCode.jpg)

<p align="center">
<a href="https://travis-ci.org/EyreFree/EFQRCode"><img src="http://img.shields.io/travis/EyreFree/EFQRCode.svg"></a>
<a href="https://codecov.io/gh/EyreFree/EFQRCode"><img src="https://codecov.io/gh/EyreFree/EFQRCode/branch/master/graph/badge.svg" alt="Codecov" /></a>
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-ready-orange.svg"></a>
<a href="http://cocoapods.org/pods/EFQRCode"><img src="https://img.shields.io/cocoapods/v/EFQRCode.svg?style=flat"></a>
<a href="https://raw.githubusercontent.com/EyreFree/EFQRCode/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/EFQRCode.svg?style=flat"></a>
<a href="http://cocoapods.org/pods/EFQRCode"><img src="https://img.shields.io/cocoapods/p/EFQRCode.svg?style=flat"></a>
<a href="https://travis-ci.org/EyreFree/EFQRCode"><img src="https://img.shields.io/badge/language-swift-orange.svg"></a>
<a href="https://gitter.im/EFQRCode/Lobby"><img src="https://badges.gitter.im/EyreFree/EFQRCode.svg"></a>
<a href="https://codebeat.co/projects/github-com-eyrefree-efqrcode-master"><img alt="codebeat badge" src="https://codebeat.co/assets/svg/badges/A-398b39-669406e9e1b136187b91af587d4092b0160370f271f66a651f444b990c2730e9.svg" /></a>
</p>

EFQRCode is a tool to generate QRCode UIImage or recognize QRCode from UIImage, in Swift. It is based on `CIDetector` and `CIFilter`.

- Generation: Create pretty two-dimensional code image with input watermark or icon;
- Recognition: Recognition rate is higher than simply `CIDetector`.

> [中文介绍](https://github.com/EyreFree/EFQRCode/blob/master/README_CN.md)

## Overview

![](assets/QRCode1.jpg)|![](assets/QRCode2.jpg)|![](assets/QRCode3.jpg)|![](assets/QRCode4.jpg)  
:---------------------:|:---------------------:|:---------------------:|:---------------------:
![](assets/QRCode5.jpg)|![](assets/QRCode6.jpg)|![](assets/QRCode7.jpg)|![](assets/QRCode8.jpg)  

## Demo

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Or you can run the following command in terminal:

```bash
git clone git@github.com:EyreFree/EFQRCode.git; cd EFQRCode/Example; pod install; open EFQRCode.xcworkspace
```

## Requirements

- XCode 8.0+
- Swift 3.0+

## Installation

### CocoaPods

EFQRCode is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod "EFQRCode", '~> 1.2.0'
```

## Usage

#### 1. Import EFQRCode

Import EFQRCode module where you want to use it:

```swift
import EFQRCode
```

#### 2. Recognition

Get QR Codes from UIImage, maybe there are several codes in a image, so it will return an array:

```swift
if let testImage = UIImage(named: "test.png") {
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
//                 icon (Optional): Icon in the middle of QR Code Image
//             iconSize (Optional): Width and height of icon
//       isIconColorful (Optional): Is icon colorful
//            watermark (Optional): Watermark background image
//        watermarkMode (Optional): Watermark background image mode, like UIViewContentMode
//  isWatermarkColorful (Optional): Is Watermark colorful

// Extra parameters:
//           foregroundPointOffset: Offset of foreground point
//                allowTransparent: Allow transparent
```

```swift
if let tryImage = EFQRCode.generate(
    content: "https://github.com/EyreFree/EFQRCode",
    magnification: 9,
    watermark: UIImage(named: "WWF"),
    watermarkMode: .scaleAspectFill,
    isWatermarkColorful: false
) {
    print("Create QRCode image success!")
} else {
    print("Create QRCode image failed!")
}
```

Result: 

<img src="assets/sample1.jpg" width = "36%"/>

## User Guide

### 1. Recognition

```swift
EFQRCode.recognize(image: UIImage)
```

Or

```swift
EFQRCodeRecognizer(image: image).contents
```

Two way before is exactly the same, because of the possibility of more than one two-dimensional code in the same iamge, so the return value is `[String]? ', if the return is nil means that the input data is incorrect or null. If the return array is empty, it means we can not recognize  any two-dimensional code at the image.

### 2. Generation

```swift
EFQRCode.generate(
    content: String, 
    inputCorrectionLevel: EFInputCorrectionLevel, 
    size: CGFloat, 
    magnification: UInt?, 
    backgroundColor: UIColor, 
    foregroundColor: UIColor, 
    icon: UIImage?, 
    iconSize: CGFloat?, 
    isIconColorful: Bool, 
    watermark: UIImage?, 
    watermarkMode: EFWatermarkMode, 
    isWatermarkColorful: Bool
)
```

Or

```swift
EFQRCodeGenerator(
    content: content,
    inputCorrectionLevel: inputCorrectionLevel,
    size: size,
    magnification: magnification,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    icon: icon,
    iconSize: iconSize,
    isIconColorful: isIconColorful,
    watermark: watermark,
    watermarkMode: watermarkMode,
    isWatermarkColorful: isWatermarkColorful
).image
```

Two way before is exactly the same, the return value is `UIImage?`, if the return is nil means that there is some wrong during the generation.

If you want to use the extra parameters, you must establish a EFQRCodeGenerator object:

```swift
let generator = EFQRCodeGenerator(
    content: content,
    inputCorrectionLevel: inputCorrectionLevel,
    size: size,
    magnification: magnification,
    backgroundColor: backColor,
    foregroundColor: frontColor,
    icon: icon,
    iconSize: iconSize,
    isIconColorful: iconColorful,
    watermark: watermark,
    watermarkMode: watermarkMode,
    isWatermarkColorful: watermarkColorful
)
generator.foregroundPointOffset = self.foregroundPointOffset
generator.allowTransparent = self.allowTransparent

// Final two-dimensional code image
generator.image
```

Parameters explaination:

* **content: String?**

Content, compulsive, capacity is limited, 1273 character most, the density of the two-dimensional lattice increases with the increase of the content. Comparison of different capacity is as follows:

10 characters | 250 characters
:-------------------------:|:-------------------------:
![](assets/compareContent1.jpg)|![](assets/compareContent2.jpg)

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
![](assets/compareInputCorrectionLevel1.jpg)|![](assets/compareInputCorrectionLevel2.jpg)|![](assets/compareInputCorrectionLevel3.jpg)|![](assets/compareInputCorrectionLevel4.jpg)

* **size: CGFloat**

Two-dimensional code length, optional, default is 256 (PS: if magnification is not nil, size will be ignored).

* **magnification: UInt?**

Magnification, optional, default is nil.

Because in accordance with the existence of size scaling two-dimensional code clarity is not high, if you want to get a more clear two-dimensional code, you can use magnification to set the size of the final generation of two-dimensional code. Here is the smallest ratio relative to the two-dimensional code matrix is concerned, if there is a want size but I hope to have a clear and size and have size approximation of the two-dimensional code by using magnification, through `maxMagnificationLessThanOrEqualTo (size: CGFloat), and `minMagnificationGreaterThanOrEqualTo (size: CGFloat), want to get magnification these two functions the specific value, the use of specific methods are as follows:

```swift
let generator = EFQRCodeGenerator(
    content: content,
    inputCorrectionLevel: inputCorrectionLevel,
    size: size,
    magnification: magnification,
    backgroundColor: backColor,
    foregroundColor: frontColor,
    icon: icon,
    iconSize: iconSize,
    isIconColorful: iconColorful,
    watermark: watermark,
    watermarkMode: watermarkMode,
    isWatermarkColorful: watermarkColorful
)

// Want to get max magnification when size is less than or equalTo 600
generator.magnification = generator.maxMagnificationLessThanOrEqualTo(size: 600)

// Or

// Want to get min magnification when size is greater than or equalTo 600
// generator.magnification = generator.minMagnificationGreaterThanOrEqualTo(size: 600)

// Final two-dimensional code image
generator.image
```

size 300 | magnification 9
:-------------------------:|:-------------------------:
![](assets/compareMagnification1.jpg)|![](assets/compareMagnification2.jpg)

* **backgroundColor: UIColor**

BackgroundColor, optional, default is white.

* **foregroundColor: UIColor**

ForegroundColor, optional, color of code point, default is black.

  ForegroundColor set to red | BackgroundColor set to gray  
:-------------------------:|:-------------------------:
![](assets/compareForegroundcolor.jpg)|![](assets/compareBackgroundcolor.jpg)

* **icon: UIImage?**

Icon image in the center of code image, optional, default is nil.

* **iconSize: CGFloat?**

Size of icon image, optional, default is 20% of size: 

  Default 20% size | Set to 64  
:-------------------------:|:-------------------------:
![](assets/compareIcon.jpg)|![](assets/compareIconSize.jpg)

* **isIconColorful: Bool**

Is icon colorful, optional, default is `true`.

* **watermark: UIImage?**

Watermark image, optional, default is nil, for example: 

  1 | 2  
:-------------------------:|:-------------------------:
![](assets/compareWatermark1.jpg)|![](assets/compareWatermark2.jpg)

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
![](assets/compareForegroundPointOffset1.jpg)|![](assets/compareForegroundPointOffset2.jpg)

* **allowTransparent: Bool**

Allow watermark image transparent, optional, default is `true`:

true | false
:-------------------------:|:-------------------------:
![](assets/compareAllowTransparent1.jpg)|![](assets/compareAllowTransparent2.jpg)

## PS

1. Please select a high contrast foreground and background color combinations;
2. You should use `magnification` instead of `size` if you want to improve the definition of QRCode image, you can also increase the value of them;
3. Magnification too high／Size too long／Content too much may cause failure;
4. It is recommended to test the QRCode image before put it into use;
5. You can contact me if there is any problem, both `Issue` and `Pull request` are welcome.

PS of PS: I wish you can click the `Star` button if this tool is useful for you, thanks, QAQ...

## Author

EyreFree, eyrefree@eyrefree.org

## License

EFQRCode is available under the MIT license. See the LICENSE file for more info.
