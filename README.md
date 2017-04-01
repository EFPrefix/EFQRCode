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

![](assets/QRCode1.jpg)|![](assets/QRCode2.jpg)|![](assets/QRCode4.jpg)|![](assets/QRCode6.jpg)  
:---------------------:|:---------------------:|:---------------------:|:---------------------:
![](assets/QRCode7.jpg)|![](assets/QRCode8.jpg)|![](assets/QRCode9.jpg)|![](assets/QRCode10.jpg)  

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

## Use

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

Create QR Code image:

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

Result：

<img src="assets/sample1.jpg" width = "36%"/>

## PS

1. Please select a high contrast foreground and background color combinations;
2. You should use `magnification` instead of `size` if you want to improve the definition of QRCode image, you can also increase the value of them;
3. Magnification too high／Size too long／Content too much may cause failure;
4. It is recommended to test the QRCode image before put it into use;
5. You can contact me if there is any problem, both `Issue` and `Pull request` are welcome.

PS of PS：I wish you can click the `Star` button if this tool is useful for you, thanks, QAQ...

## Author

EyreFree, eyrefree@eyrefree.org

## License

EFQRCode is available under the MIT license. See the LICENSE file for more info.
