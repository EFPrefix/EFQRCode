# 用户指南

## 1. 二维码识别

```swift
EFQRCode.recognize(CGImage)
```

或

```swift
EFQRCodeRecognizer(image: CGImage).recognize()
```

以上两种写法是完全相等的。因为传入的图片中可能包好多个二维码，所以返回值为 `[String]`，若返回数组为空则表示未识别到图片上的二维码。

## 2. 二维码生成

```swift
EFQRCode.generate(
    for: String, encoding: String.Encoding,
    inputCorrectionLevel: EFInputCorrectionLevel,
    size: EFIntSize, magnification: EFIntSize?,
    backgroundColor: CGColor, foregroundColor: CGColor,
    watermark: CGImage?, watermarkMode: EFWatermarkMode,
    watermarkIsTransparent: Bool,
    icon: CGImage?, iconSize: EFIntSize?,
    pointStyle: EFPointStyle, pointOffset: CGFloat,
    isTimingPointStyled: Bool,
    mode: EFQRCodeMode?
)
```

或

```swift
let generator = EFQRCodeGenerator(
    content: String, encoding: String.Encoding,
    size: EFIntSize
)
generator.withMode(EFQRCodeMode)
generator.withInputCorrectionLevel(EFInputCorrectionLevel)
generator.withSize(EFIntSize)
generator.withMagnification(EFIntSize?)
generator.withColors(backgroundColor: CGColor, 
                     foregroundColor: CGColor)
generator.withIcon(CGImage?, size: EFIntSize?)
generator.withWatermark(CGImage?, mode: EFWatermarkMode?)
generator.withPointOffset(CGFloat)
generator.withTransparentWatermark(Bool)
generator.withPointStyle(EFPointStyle)

// 最终生成的二维码
generator.generate()
```

以上两种写法是完全相等的，返回值为 `CGImage?`。若返回 `nil` 则表示生成失败。

### 参数说明

#### content: String?

二维码内容，必填。有容量限制，最大为 424 个汉字（或 1273 个英文字母）。二维码点阵密集程度随内容增加而提高。不同容量对比如下：

10 个字母 | 250 个字母
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareContent1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareContent2.jpg)

#### mode: EFQRCodeMode

二维码样式。`EFQRCodeMode` 定义如下：

```swift
public enum EFQRCodeMode {
    // case none        // 使用 `nil` 表示
    case grayscale
    case binarization(threshold: CGFloat)
}
```

`nil` | grayscale | binarization
:-------------------------:|:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/mode1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/mode2.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/mode3.jpg)

`binarization` 二值化的阈值：

原图 | 0.3 | 0.5 | 0.8
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/binarizationThreshold0.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/binarizationThreshold1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/binarizationThreshold2.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/binarizationThreshold3.jpg)

#### inputCorrectionLevel: EFInputCorrectionLevel

容错率定义如下，共有四个等级：L 7%／M 15%／Q 25%／H 30%，默认值为最高容错等级 H。

```swift
public enum EFInputCorrectionLevel: Int {
    case l = 0      // L 7%
    case m = 1      // M 15%
    case q = 2      // Q 25%
    case h = 3      // H 30%
}
```

同一内容不同容错率对比如下：

L | M | Q | H
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareInputCorrectionLevel1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareInputCorrectionLevel2.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareInputCorrectionLevel3.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareInputCorrectionLevel4.jpg)

#### size: EFIntSize

> **注意**：如果 `magnification` 不为空，将会忽略 `size` 参数。

生成的二维码边长，默认为 (256, 256)。

```swift
final public class EFIntSize : NSObject {
    public let width: Int
    public let height: Int

    public init(width: Int = 0, height: Int = 0)
    public convenience init(size: CGSize)

    public var cgSize: CGSize { get }
}
```

234 * 234 | 312 * 234
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/size1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/size2.jpg)

#### magnification: EFIntSize?

放大倍数，默认为 `nil`。

因为按照 size 缩放二维码存在清晰度不高的问题，如果希望得到比较清晰的二维码，可以使用 magnification 来设定最终生成的二维码大小。这里的倍数是相对于最小的二维码点阵而言的，如果已有一个想要的 size 但是希望通过使用 magnification 获得一个清晰且大小和自己所要 size 近似的二维码，可以通过 `maxMagnification(lessThanOrEqualTo: CGFloat)` 和 `minMagnification(greaterThanOrEqualTo: CGFloat)` 这两个函数来获得想要的 magnification 具体值。使用方法如下：

```swift
let generator = EFQRCodeGenerator(...)

// 希望获得最终 size 小于等于 desiredSize 的最大倍率
if let maxMagnification = generator
    .maxMagnification(lessThanOrEqualTo: desiredSize) {
    generator.magnification = EFIntSize(
        width: maxMagnification, 
        height: maxMagnification
    )
}
// 或获得最终 size 大于等于 desiredSize 的最小倍率
if let minMagnification = generator
    .minMagnification(greaterThanOrEqualTo: desiredSize) {
    generator.magnification = EFIntSize(
        width: minMagnification, 
        height: minMagnification
    )
    
}

// 最终生成的二维码
generator.generate()
```

size 300 | magnification 9
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareMagnification1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareMagnification2.jpg)

#### backgroundColor: CIColor/CGColor

背景色，默认为白色。

#### foregroundColor: CIColor/CGColor

前景色，二维码码点的颜色，默认为黑色。

  前景设为红色 | 背景设为灰色  
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareForegroundcolor.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareBackgroundcolor.jpg)

#### icon: CGImage?

二维码中心图标，默认为空。

#### iconSize: CGFloat?

二维码中心图标变长，`nil` 默认为最终二维码边长的 20%。对比：

  默认外边长的 20% | 设为固定值 64
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareIcon.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareIconSize.jpg)

#### watermark: CGImage?

水印图，默认为 `nil`，示例如下：

|   |   |
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareWatermark1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareWatermark2.jpg)

#### watermarkMode: EFWatermarkMode

水印图放置于最终生成二维码的位置，默认为 `scaleAspectFill`。可参考 `UIView.ContentMode`（将生成的二维码当作 `UIImageView` 理解即可）。

```swift
public enum EFWatermarkMode: Int {
    case scaleToFill        = 0
    case scaleAspectFit     = 1
    case scaleAspectFill    = 2
    case center             = 3
    case top                = 4
    case bottom             = 5
    case left               = 6
    case right              = 7
    case topLeft            = 8
    case topRight           = 9
    case bottomLeft         = 10
    case bottomRight        = 11
}
```

#### isWatermarkOpaque: Bool

使用不透明的水印图，默认为 `false`（允许穿透），对比如下：

`false` | `true`
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareAllowTransparent1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareAllowTransparent2.jpg)

#### pointOffset: CGFloat

> **注意**：不建议使用，易造成二维码无法识别。

二维码码点偏移量，默认为 0，对比如下：

0 | 0.5 
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareForegroundPointOffset1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareForegroundPointOffset2.jpg)

#### pointStyle: EFPointStyle

二维码码点形状，默认是方形 `square`，并提供了 `circle` 和 `diamond` 共三种内置样式。

如果想要绘制自定义图形，可以编写实现 `EFPointStyle` 协议的新类型作为 pointStyle。

```swift
public protocol EFPointStyle {
    func fillRect(context: CGContext, rect: CGRect, isStatic: Bool)
}
```

> 详情可参考 Example 中的 `StarPointStyle`。

square | circle | diamond
:-------------------------:|:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareAllowTransparent1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/pointShape.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/pointDiamond.jpg)

### 3. 动态二维码

首先需要从网络/本地/相册等来源获取输入的 GIF 文件的完整数据（要 `Data` 类型）；

> **注意**：不能通过 `UIImage` 来获取，不然的话只能取到 GIF 的第一帧。

然后可以通过 EFQRCode 的类方法 `generateGIF` 来创建 GIF 二维码，使用方式如下：

|参数|作用描述|
|-:|:-|
|`generator`|[**必填**] 一个用来获取设置的 `EFQRCodeGenerator` 对象|
|`data`|[**必填**] 输入的 GIF 图片的数据|
|`delay`|输出的动态 QRCode 的帧间延时，默认从输入的 GIF 图片获取|
|`loopCount`|输出的动态 QRCode 的循环次数，默认从输入的 GIF 图片获取|

```swift
if let qrcodeData = EFQRCode.generateGIF(using: generator, withWatermarkGIF: data) {
    print("Create QRCode image success.")
} else {
    print("Create QRCode image failed!")
}
```

这里的 generator 是一个 `EFQRCodeGenerator` 类型的对象，用来对 GIF 中的每一帧进行处理，详细用法参考上文。你也可以通过查看 Demo 代码的方式来获取更多信息。结果预览：

<img src="https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF6.gif" width = "42%"/>

到这里我们已经获取了生成的 GIF 文件的完整数据，接下来可以进行将返回的 `Data` 类型的数据直接保存到本地/系统相册/上传到服务器等你想做的操作；
