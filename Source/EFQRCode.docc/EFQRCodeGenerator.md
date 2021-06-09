# ``EFQRCode/EFQRCodeGenerator``

## Overview

Configure the parameters by setting the properties directly, or chain any number of the methods having prefix `with`- like this:

```swift
let generator = EFQRCodeGenerator(
    content: "Hello World",
    size: EFIntSize(width: 15, height: 15)
)
.withColors(backgroundColor: EFColor.gray.ciColor(),
            foregroundColor: CIColor.black())
.withInputCorrectionLevel(.m)
// ... more configs
```

> Tip: Learn more about the [anatomy of QRCode](https://www.qr-code-generator.com/qr-code-marketing/qr-codes-basics/#anatomy-of-qr-code) to understand the available customizations. 

Once done, use one of the `generate` methods to get the finalized QRCode image:

```swift
let qrCodeImage = generator.generate()
```

## Topics

### Generic Configuration

- ``with(_:_:)``

### Setup Contents

- ``EFQRCode/EFQRCodeGenerator/init(content:encoding:size:)-631up``
- ``EFQRCode/EFQRCodeGenerator/init(content:encoding:size:)-1jtir``
- ``content``
- ``setContent(content:)``
- ``contentEncoding``
- ``withContentEncoding(_:)``
- ``setContentEncoding(encoding:)``
- ``withContent(_:encoding:)-8tc7u``
- ``withContent(_:encoding:)-535gl``

### Input Correction Level

- ``inputCorrectionLevel``
- ``withInputCorrectionLevel(_:)``
- ``setInputCorrectionLevel(inputCorrectionLevel:)``

### Size and Magnification

- ``size``
- ``withSize(_:)``
- ``setSize(size:)``
- ``magnification``
- ``withMagnification(_:)``
- ``setMagnification(magnification:)``
- ``maxMagnification(lessThanOrEqualTo:)``
- ``maxMagnificationLessThanOrEqualTo(size:)``
- ``minMagnification(greaterThanOrEqualTo:)``
- ``minMagnificationGreaterThanOrEqualTo(size:)``

### Generate QRCode

- ``generate()``
- ``clearCache()``

### Generate Animated QRCode

- ``generateGIF(watermarkGIF:delay:loopCount:useMultipleThreads:)``
- ``generateGIF(watermarkGIF:)``

### Icon Image

- ``icon``
- ``iconSize``
- ``withIcon(_:size:)``
- ``setIcon(icon:size:)``

### Watermark Image

- ``watermark``
- ``watermarkMode``
- ``withWatermark(_:mode:)-85xnk``
- ``withWatermark(_:mode:)-945v1``
- ``setWatermark(watermark:mode:)``
- ``isWatermarkOpaque``
- ``withOpaqueWatermark(_:)``
- ``withTransparentWatermark(_:)``
- ``setAllowTransparent(allowTransparent:)``

### Coloring

- ``backgroundColor``
- ``foregroundColor``
- ``withColors(backgroundColor:foregroundColor:)-6qo9v``
- ``setColors(backgroundColor:foregroundColor:)-1qtwp``
- ``withColors(backgroundColor:foregroundColor:)-n3if``
- ``setColors(backgroundColor:foregroundColor:)-7hmx5``
- ``mode``
- ``withMode(_:)``
- ``withNormalMode()``
- ``withGrayscaleMode()``
- ``withBinarizationMode(threshold:)``
- ``setMode(mode:)``

### Foreground Points

- ``pointShape``
- ``withPointShape(_:)``
- ``setPointShape(pointShape:)``
- ``isTimingPointStatic``
- ``withStaticTimingPoint(_:)``
- ``withStyledTimingPoint(_:)``
- ``setIgnoreTiming(ignoreTiming:)``
- ``pointOffset``
- ``withPointOffset(_:)``
- ``setForegroundPointOffset(foregroundPointOffset:)``
