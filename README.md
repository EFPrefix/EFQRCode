# EFQRCode

[![CI Status](http://img.shields.io/travis/EyreFree/EFQRCode.svg?style=flat)](https://travis-ci.org/EyreFree/EFQRCode)
[![Version](https://img.shields.io/cocoapods/v/EFQRCode.svg?style=flat)](http://cocoapods.org/pods/EFQRCode)
[![License](https://img.shields.io/cocoapods/l/EFQRCode.svg?style=flat)](http://cocoapods.org/pods/EFQRCode)
[![Platform](https://img.shields.io/cocoapods/p/EFQRCode.svg?style=flat)](http://cocoapods.org/pods/EFQRCode)
[![Language: Swift](https://img.shields.io/badge/language-swift-orange.svg)](https://travis-ci.org/EyreFree/EFQRCode)

An extension for UIImage to create and scan QRCode, in Swift.

## Overview

![](assets/screenshot.png)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- XCode 8.0+
- Swift 3.0+

## Installation

EFQRCode is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod "EFQRCode", '~> 1.0.0'
```

### Use

0. Import EFQRCode module where you want to use it:
```
import EFQRCode
```

1. Get QR Codes from UIImage, maybe there are several codes in a image, so it will return an array:
```
if let testImage = UIImage(named: "test.png") {
	let codes = testImage.toQRCodeString()
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
This can be also written as this:
```
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

2. Create QR Code image:
```
// QRCodeString: Content of QR Code
// size: Width and height of image
// inputCorrectionLevel: error-tolerant rate
// 		L 7%
// 		M 15%
// 		Q 25%
// 		H 30%
// iconImage (Optional): icon in the middle of QR Code Image
// iconImageSize (Optional): Width and height of icon
```
```
if let tryImage = UIImage(QRCodeString: "what the hell.", size: 200, inputCorrectionLevel: .m, iconImage: UIImage(named: "eyrefree"), iconImageSize: 10.0) {
    print("Create QRCode image success!")
} else {
    print("Create QRCode image failed!")
}
```
This can be also written as this:
```
if let tryImage = EFQRCode.CreateQRCodeImage(With: "what the hell.", size: 200, inputCorrectionLevel: .m, iconImage: UIImage(named: "eyrefree"), iconImageSize: 10.0) {
    print("Create QRCode image success!")
} else {
    print("Create QRCode image failed!")
}
```

## Author

EyreFree, eyrefree@eyrefree.org

## License

EFQRCode is available under the MIT license. See the LICENSE file for more info.
