![](assets/EFQRCodeImage.jpg)

[![CI Status](http://img.shields.io/travis/EyreFree/EFQRCode.svg?style=flat)](https://travis-ci.org/EyreFree/EFQRCode)
[![Version](https://img.shields.io/cocoapods/v/EFQRCode.svg?style=flat)](http://cocoapods.org/pods/EFQRCode)
[![License](https://img.shields.io/cocoapods/l/EFQRCode.svg?style=flat)](https://github.com/EyreFree/EFQRCode/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/EFQRCode.svg?style=flat)](http://cocoapods.org/pods/EFQRCode)
[![Language: Swift](https://img.shields.io/badge/language-swift-orange.svg)](https://travis-ci.org/EyreFree/EFQRCode)
[![Gitter](https://badges.gitter.im/EyreFree/EFQRCode.svg)](https://gitter.im/EyreFree/EFQRCode?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

EFQRCode is a tool to create QRCode UIImage or scan QRCode from UIImage, in Swift. It is based on `CIDetector` and `CIFilter` but better.

- Generation: Create QRCode image with a lot of styles
- Recognition: Recognition rate is higher than simply `CIDetector`

> [中文介绍](https://github.com/EyreFree/EFQRCode/blob/master/README_CN.md)

## Overview

![](assets/screenshot.png)

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

EFQRCode is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod "EFQRCode", '~> 1.1.1'
```

## Use

#### 1. Import EFQRCode module where you want to use it:

```swift
import EFQRCode
```

#### 2. Get QR Codes from UIImage, maybe there are several codes in a image, so it will return an array:

```swift
if let testImage = UIImage(named: "test.png") {
	let codes = EFQRCode.GetQRCodeString(From: testImage)
	if codes.count > 0 {
		print("There are \(codes.count) codes in testImage.")
		for (index, code) in codes.enumerated() {
			print("The content of \(index) QR Code is: \(code).")
		}
	} else {
		print("There is no QR Codes in testImage.")
	}
}
```

#### 3. Create QR Code image:

```swift
//                          string: Content of QR Code
// inputCorrectionLevel (Optional): error-tolerant rate
// 		                            L 7%
// 		                            M 15%
// 		                            Q 25%
// 		                            H 30%
//                 size (Optional): Width and height of image
//              quality (Optional): Quality of QRCode
//            backColor (Optional): Background color of QRCode
//           frontColor (Optional): Front color of QRCode
//                 icon (Optional): icon in the middle of QR Code Image
//             iconSize (Optional): Width and height of icon
//         iconColorful (Optional): Is icon colorful
//            watermark (Optional): Watermark background image
//        watermarkMode (Optional): Watermark background image mode, like UIViewContentMode
//    watermarkColorful (Optional): Is Watermark colorful
```

```swift
if let tryImage = EFQRCode.createQRImage(
    string: "https://github.com/EyreFree/EFQRCode",
    inputCorrectionLevel: .h,
    size: 750,
    quality: .low,
    backColor: .white,
    frontColor: .black,
    icon: nil,
    iconSize: nil,
    iconColorful: true,
    watermark: UIImage(named: "eyrefree"),
    watermarkMode: .scaleAspectFill,
    watermarkColorful: false
    ) {
    print("Create QRCode image success!")
} else {
    print("Create QRCode image failed!")
}
```

Result：

<img src="assets/QRCode5.jpg" width = "40%"/>

## Examples

![](assets/QRCode1.jpg)|![](assets/QRCode2.jpg)|![](assets/QRCode4.jpg)|![](assets/QRCode6.jpg)  
:---------------------:|:---------------------:|:---------------------:|:---------------------:
![](assets/QRCode7.jpg)|![](assets/QRCode8.jpg)|![](assets/QRCode9.jpg)|![](assets/QRCode10.jpg)  

## PS

1. Please select a high contrast foreground and background color combinations;
2. Want to improve the definition of QRCode image, you can improve the quality and size;
3. Quality too high／Size too long／Content too much may cause failure;
4. It is recommended to test the QRCode image before put it into use;
5. You can contact me if there is any problem, both Issue and Pull request are welcome.

PS of PS：I wish you can click the `Star` button if this tool is useful for you, thanks, QAQ...

## Author

EyreFree, eyrefree@eyrefree.org

## License

EFQRCode is available under the MIT license. See the LICENSE file for more info.
