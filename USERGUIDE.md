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
