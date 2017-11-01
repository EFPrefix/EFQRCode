## 用户指南

### 1. 二维码识别

```swift
EFQRCode.recognize(image: CGImage)
```

或

```swift
EFQRCodeRecognizer(image: CGImage).recognize()
```

以上两种写法是完全相等的，因为传入的图片中可能包好多个二维码，所以返回值为 `[String]?`，若返回 nil 则表示传入数据有误或为空，若返回数组为空则表示图片上未识别到二维码。

### 2. 二维码生成

```swift
EFQRCode.generate(
    content: String,
    size: EFIntSize,
    backgroundColor: CIColor,
    foregroundColor: CIColor,
    watermark: CGImage?
)
```

或

```swift
let generator = EFQRCodeGenerator(content: String, size: EFIntSize)
generator.setContent(content: String)
generator.setMode(mode: EFQRCodeMode)
generator.setInputCorrectionLevel(inputCorrectionLevel: EFInputCorrectionLevel)
generator.setSize(size: EFIntSize)
generator.setMagnification(magnification: EFIntSize?)
generator.setColors(backgroundColor: CIColor, foregroundColor: CIColor)
generator.setIcon(icon: CGImage?, size: EFIntSize?)
generator.setWatermark(watermark: CGImage?, mode: EFWatermarkMode)
generator.setForegroundPointOffset(foregroundPointOffset: CGFloat)
generator.setAllowTransparent(allowTransparent: Bool)
generator.setPointShape(pointShape: EFPointShape)
generator.setBinarizationThreshold(binarizationThreshold: CGFloat)

// 最终生成的二维码
generator.generate()
```

以上两种写法是完全相等的，返回值为 `CGImage?`，若返回 nil 则表示生成失败。

#### 参数说明

* **content: String?**

二维码内容，必填，有容量限制，最大为 424 个汉字（或 1273 个英文字母），二维码点阵越密集程度随内容增加而提高。不同容量对比如下：

10 个字母 | 250 个字母
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareContent1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareContent2.jpg)

* **mode: EFQRCodeMode**

二维码样式，EFQRCodeMode 定义如下：

```swift
public enum EFQRCodeMode: Int {
    case none           = 0;
    case grayscale      = 1;
    case binarization   = 2;
}
```

none | grayscale | binarization
:-------------------------:|:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/mode1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/mode2.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/mode3.jpg)

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

* **pointShape: EFPointShape**

二维码码点形状，默认是方形 `.square`，UIViewContentMode 定义如下：

```swift
public enum EFPointShape: Int {
    case square         = 0;
    case circle         = 1;
}
```

square | circle
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/compareAllowTransparent1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/pointShape.jpg)

* **binarizationThreshold: CGFloat**

二值化的阈值 (仅在 `binarization` 模式下有效)。

Origin | 0.3 | 0.5 | 0.8
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/binarizationThreshold0.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/binarizationThreshold1.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/binarizationThreshold2.jpg)|![](https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/binarizationThreshold3.jpg)

### 3. 动态二维码

1. 首先需要从网络/本地/相册等来源获取输入的 GIF 文件的完整数据，要 Data 类型，不能通过 UIImage 来获取，不然的话只能取到 GIF 的第一帧；
2. 然后可以通过 EFQRCode 的类方法 generateWithGIF 来创建 GIF 二维码，使用方式如下：

```swift
//                  data: 输入的 GIF 图片的数据
//             generator: 一个用来获取设置的 EFQRCodeGenerator 对象
// pathToSave (Optional): 用来存储 GIF 的路径，默认不填的话会存储在临时路径
//      delay (Optional): 输出的动态 QRCode 的帧间延时，默认不填的话从输入的 GIF 图片获取
//  loopCount (Optional): 输出的动态 QRCode 的循环次数，默认不填的话从输入的 GIF 图片获取
```

这里的 generator 是一个 EFQRCodeGenerator 类型的对象，用来对 GIF 中的每一帧进行处理，详细用法参考上文。

```swift
if let qrcodeData = EFQRCode.generateWithGIF(data: data, generator: generator) {
    print("Create QRCode image success.")
} else {
    print("Create QRCode image failed!")
}
```

你可以通过查看 Demo 代码的方式来获取更多信息，结果预览：

<img src="https://raw.githubusercontent.com/EyreFree/EFQRCode/assets/QRCodeGIF6.gif" width = "42%"/>

3. 到这里我们已经获取了生成的 GIF 文件的完整数据，接下来可以进行将返回的 Data 类型的数据直接保存到本地/系统相册/上传到服务器等你想做的操作；
4. 唔，这里有一个隐藏设定，最近一次生成的 GIF 二维码是保存在 EFQRcode 类的 tempResultPath 所在的位置的。
