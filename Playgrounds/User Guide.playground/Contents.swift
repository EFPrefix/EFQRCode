//: ## User Guide
import EFQRCode
import UIKit
/*: ### 1. Recognition

 There are two equivalent ways:

 ```swift
 EFQRCode.recognize(CGImage)
 ```
*/

/*:
 ```
 EFQRCodeRecognizer(image: CGImage).recognize()
 ```
*/

//: Because of the possibility that more than one QR code exist in the same image, the return value is `[String]`. If the returned array is empty, we could not recognize/didn't find any QR code in the image.

/*:---
 ### 2. Generation

 Again, there are two equivalent ways of doing this:

 ```swift
 EFQRCode.generate(
     for: String, encoding: String.Encoding,
     inputCorrectionLevel: EFInputCorrectionLevel,
     size: EFIntSize, magnification: EFIntSize?,
     backgroundColor: CGColor, foregroundColor: CGColor,
     watermark: CGImage?, watermarkMode: EFWatermarkMode,
     watermarkIsTransparent: Bool,
     icon: CGImage?, iconSize: EFIntSize?,
     pointShape: EFPointShape, pointOffset: CGFloat,
     isTimingPointStyled: Bool,
     mode: EFQRCodeMode?
 )
 ```
*/

/*:
 ```swift
 let generator = EFQRCodeGenerator(
     content: String, encoding: String.Encoding,
     size: EFIntSize
 )
 generator.withMode(EFQRCodeMode)
 generator.withInputCorrectionLevel(EFInputCorrectionLevel)
 generator.withSize(EFIntSize)
 generator.withMagnification(EFIntSize?)
 generator.withColors(backgroundColor: CGColor, foregroundColor: CGColor)
 generator.withIcon(CGImage?, size: EFIntSize?)
 generator.withWatermark(CGImage?, mode: EFWatermarkMode?)
 generator.withPointOffset(CGFloat)
 generator.withTransparentWatermark(Bool)
 generator.withPointShape(EFPointShape)
 // Lastly, get the final two-dimensional code image
 generator.generate()
 ```
*/

//: The return value is of type `CGImage?`. If it is `nil`, something went wrong during generation.

/*:
 #### Parameters Explained
 ##### content: String?

 Content is a required parameter, with its capacity limited at 1273 characters. The density of the QR-lattice increases with the increases of the content length. Here's an example of 10 vs. 250 characters:
*/
EFQRCodeGenerator(content: "abcdefghij").generate()

let longString = "abcdefghij" * 25
EFQRCodeGenerator(content: longString).generate()

/*:
##### mode: EFQRCodeMode
Let's see a few examples
*/
let content = "https://github.com/EyreFree/EFQRCode"
let watermark = #imageLiteral(resourceName: "eyrefree.png").cgImage
//: - Experiment: mode none (`nil`)
EFQRCodeGenerator(content: content)
    .withWatermark(watermark)
    .withMode(nil)
    .generate()
//: - Experiment: grayscale mode
EFQRCodeGenerator(content: content)
    .withWatermark(watermark)
    .withMode(.grayscale)
    .generate()
//: - Experiment: binarization mode
EFQRCodeGenerator(content: content)
    .withWatermark(watermark)
    .with(\.backgroundColor, #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor)
    .withMode(.binarization(threshold: 0.1))
    .generate()

/*:
 ##### inputCorrectionLevel: EFInputCorrectionLevel

 Percent of tolerance has 4 different levels:

 - L: 7%
 - M: 15%
 - Q: 25%
 - H: 30%

 and the default is `EFInputCorrectionLevel.h`.
*/
//: - Experiment: L: 7%
EFQRCodeGenerator(content: longString)
    .withInputCorrectionLevel(.l)
    .generate()
//: - Experiment: M 15%
EFQRCodeGenerator(content: longString)
    .withInputCorrectionLevel(.m)
    .generate()
//: - Experiment: Q: 25%
EFQRCodeGenerator(content: longString)
    .withInputCorrectionLevel(.q)
    .generate()
//: - Experiment: H: 30%
EFQRCodeGenerator(content: longString)
    .withInputCorrectionLevel(.h)
    .generate()

/*:
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
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/size1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/size2.jpg)

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
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareMagnification1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareMagnification2.jpg)

* **backgroundColor: CIColor**

BackgroundColor, optional, default is white.

* **foregroundColor: CIColor**

ForegroundColor, optional, color of code point, default is black.

  ForegroundColor set to red | BackgroundColor set to gray
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareForegroundcolor.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareBackgroundcolor.jpg)

* **icon: CGImage?**

Icon image in the center of code image, optional, default is nil.

* **iconSize: CGFloat?**

Size of icon image, optional, default is 20% of size:

  Default 20% size | Set to 64
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareIcon.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareIconSize.jpg)

* **watermark: CGImage?**

Watermark image, optional, default is nil, for example:

  1 | 2
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareWatermark1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareWatermark2.jpg)

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

* **foregroundPointOffset: CGFloat**

Foreground point offset, optional, default is 0, is not recommended to use, may make the two-dimensional code broken:

0 | 0.5
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareForegroundPointOffset1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareForegroundPointOffset2.jpg)

* **allowTransparent: Bool**

Allow watermark image transparent, optional, default is `true`:

true | false
:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareAllowTransparent1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareAllowTransparent2.jpg)

* **pointShape: EFPointShape**

Shape of foreground point, default is `.square`, the definition of UIViewContentMode:

```swift
public enum EFPointShape: Int {
    case square         = 0;
    case circle         = 1;
    case diamond        = 2;
}
```

square | circle | diamond
:-------------------------:|:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/compareAllowTransparent1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/pointShape.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/pointDiamond.jpg)

* **binarizationThreshold: CGFloat**

Threshold for binarization (Only for mode binarization).

Origin | 0.3 | 0.5 | 0.8
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/binarizationThreshold0.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/binarizationThreshold1.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/binarizationThreshold2.jpg)|![](https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/binarizationThreshold3.jpg)

### 3. Generation from GIF

1. First you should get the complete data of a GIF file, type is `Data`, can not get from `UIImage` or you will only get the first frame;
2. Then you can create GIF QRCode with function `generateWithGIF` of class `EFQRCode`, for example:

```swift
//                  data: Data of input GIF
//             generator: An object of EFQRCodeGenerator, use for setting
// pathToSave (Optional): Path to save the output GIF, default is temp path
//      delay (Optional): Output QRCode GIF delay, default is same as input GIF
//  loopCount (Optional): Output QRCode GIF loopCount, default is same as input GIF
```

The `generator` here is an object of class `EFQRCodeGenerator`, to process each frame in GIF, you can find the use of it above.

```swift
if let qrcodeData = EFQRCode.generateWithGIF(data: data, generator: generator) {
    print("Create QRCode image success.")
} else {
    print("Create QRCode image failed!")
}
```

You can get more information from the demo, result will like this:

<img src="https://raw.githubusercontent.com/EFPrefix/EFQRCode/assets/QRCodeGIF6.gif" width = "42%"/>

3. Now you can get the complete data of output QRCode GIF, next we can save it to local path / system photo library / upload to server or some other things you want to do;
4. Emmmmmm, note that the `tempResultPath` of `EFQRcode` is the path of data of GIF of last generation.
*/
