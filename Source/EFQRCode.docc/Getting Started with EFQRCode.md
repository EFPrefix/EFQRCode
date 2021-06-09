# Getting Started with EFQRCode

Create and recognize QRCode images with style.

## Overview

You can use the convenience methods on ``EFQRCode`` to configure and generate/recognize stylized QRCode images, or use ``EFQRCodeGenerator`` and ``EFQRCodeRecognizer`` for more customizations (or if you are programming in Objective-C).

## Recognition

Use ``EFQRCode/EFQRCode/recognize(_:)`` to read contents of an image that contains a QRCode.

> Note: A String Array is returned as there might be several QR Codes in a single `CGImage`.

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

## Generation

Create QR Code image is very simple; just use ``EFQRCode/EFQRCode/generate(for:encoding:inputCorrectionLevel:size:magnification:backgroundColor:foregroundColor:watermark:watermarkMode:watermarkIsTransparent:icon:iconSize:pointShape:pointOffset:isTimingPointStyled:mode:)`` and pass in the desired configurations.

Too much parameters? No worries, many of these have default values so you only need to specify what you care about:

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

![QRCode linking to EFQRCode's GitHub page](EFQRCode-WWF.jpg)

### Generation from GIF

Use ``EFQRCode/EFQRCode/generateGIF(using:withWatermarkGIF:delay:loopCount:useMultipleThreads:)`` to create an animated QRCode. The basic parameters are configured through an ``EFQRCodeGenerator`` instance.

> Tip: Check out the [sample projects](https://github.com/EFPrefix/EFQRCode/tree/main/Examples) for more info.

```swift
if let qrCodeData = EFQRCode.generateGIF(
    using: generator, withWatermarkGIF: data
) {
    print("Create QRCode image success.")
} else {
    print("Create QRCode image failed!")
}
```

![Animated QRCode](EFQRCode-GIF.gif)

### Best Practices

1. Select a high contrast foreground and background color combination;
2. To improve the definition of QRCode images, increase ``EFQRCodeGenerator/size``, or scale up using ``EFQRCodeGenerator/magnification`` (instead);
3. Magnification too high/size too large/contents too long may cause generation to fail;
4. Test the QRCode image to make sure it works before putting into use.
