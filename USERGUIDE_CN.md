## 用户指南

### 1. 二维码识别

```swift
EFQRCode.recognize(image: CGImage)
```

或

```swift
EFQRCodeRecognizer(image: CGImage).contents
```

以上两种写法是完全相等的，因为传入的图片中可能包好多个二维码，所以返回值为 `[String]?`，若返回 nil 则表示传入数据有误或为空，若返回数组为空则表示图片上未识别到二维码。

### 2. 二维码生成

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

或

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

// 最终生成的二维码
generator.image
```

以上两种写法是完全相等的，返回值为 `CGImage?`，若返回 nil 则表示生成失败。

#### 参数说明

* **content: String?**

二维码内容，必填，有容量限制，最大为 424 个汉字（或 1273 个英文字母），二维码点阵越密集程度随内容增加而提高。不同容量对比如下：

10 个字母 | 250 个字母
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareContent1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareContent2.jpg)

* **inputCorrectionLevel: EFInputCorrectionLevel**

容错率，可选值，有四个等级，L：7%／M 15%／Q 25%／H 30%，默认值为最高容错等级 H，枚举类型 EFInputCorrectionLevel 定义如下：

```swift
// EFInputCorrectionLevel
public enum EFInputCorrectionLevel: Int {
    case l = 0;     // L 7%
    case m = 1;     // M 15%
    case q = 2;     // Q 25%
    case h = 3;     // H 30%
}
```

同一内容不同容错率对比如下：

L | M | Q | H
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareInputCorrectionLevel1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareInputCorrectionLevel2.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareInputCorrectionLevel3.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareInputCorrectionLevel4.jpg)

* **size: EFIntSize**

生成的二维码边长，可选值，默认为 (256, 256)（PS：如果 magnification 不为空，将会忽略 size 参数），结构体 EFIntSize 定义如下：

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

放大倍数，可选值，默认为 nil。

因为按照 size 缩放二维码存在清晰度不高的问题，如果希望得到比较清晰的二维码，可以使用 magnification 来设定最终生成的二维码大小。这里的倍数是相对于最小的二维码点阵而言的，如果已有一个想要的 size 但是希望通过使用 magnification 获得一个清晰且大小和自己所要 size 近似的二维码，可以通过 `maxMagnificationLessThanOrEqualTo(size: CGFloat)` 和 `minMagnificationGreaterThanOrEqualTo(size: CGFloat)` 这两个函数来获得想要的 magnification 具体值，具体使用方法如下：

```swift
let generator = EFQRCodeGenerator(
    content: String,
    inputCorrectionLevel: EFInputCorrectionLevel,
    size: EFIntSize,
    magnification: EFIntSize?,
    backgroundColor: CIColor,
    foregroundColor: CIColor
)

// 希望获得最终 size 小于等于 600 的最大倍率
if let magnification = generator.maxMagnificationLessThanOrEqualTo(size: 600) {
    generator.magnification = EFIntSize(width: magnification, height: magnification)
}

// 或

// 希望获得最终 size 的宽大于等于 600 的最小倍率和高大于等于 800 的最小倍率
// if let magnificationWidth = generator.minMagnificationGreaterThanOrEqualTo(size: 600),
//     let magnificationHeight = generator.minMagnificationGreaterThanOrEqualTo(size: 600) {
//     generator.magnification = EFIntSize(width: magnificationWidth, height: magnificationHeight)
// }

// 最终生成的二维码
generator.image
```

size 300 | magnification 9
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareMagnification1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareMagnification2.jpg)

* **backgroundColor: CIColor**

背景色，可选值，默认为白色。

* **foregroundColor: CIColor**

前景色，可选值，二维码码点的颜色，默认为黑色。

  前景设为红色 | 背景设为灰色  
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareForegroundcolor.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareBackgroundcolor.jpg)

* **icon: CGImage?**

二维码中心图标，可选值，默认为空。

* **iconSize: CGFloat?**

二维码中心图标变长，可选值，默认为最终二维码边长的 20%，这里设为 64，可以和上一个二维码对比：

  外边长的 20% | 设为固定值  
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareIcon.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareIconSize.jpg)

* **isIconColorful: Bool**

二维码中心图标是否为彩色，可选值，默认为彩色。

* **watermark: CGImage?**

水印图，可选值，默认为 nil，示例如下：

  1 | 2  
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareWatermark1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareWatermark2.jpg)

* **watermarkMode: EFWatermarkMode**

水印图放置于最终生成二维码的位置，可选值，默认为 scaleAspectFill，可参考 UIViewContentMode，将生成的二维码当作 UIImageView 理解即可，枚举类型 EFWatermarkMode 定义如下：

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

水印图是否为彩色，可选值，默认为彩色。

* **foregroundPointOffset: CGFloat**

二维码码点偏移量，可选值，默认为 0，不建议使用，易造成二维码无法识别，对比如下：

0 | 0.5 
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareForegroundPointOffset1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareForegroundPointOffset2.jpg)

* **allowTransparent: Bool**

水印图穿透允许，可选值，默认为 true，对比如下：

true | false
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareAllowTransparent1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareAllowTransparent2.jpg)

* 其它

EFIcon 是 icon，iconSize，isIconColorful 的集合，定义如下：

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

EFWatermark 是 watermark，watermarkMode，isWatermarkColorful 的集合，定义如下：

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

EFExtra 是 foregroundPointOffset，allowTransparent 的集合，定义如下：

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
