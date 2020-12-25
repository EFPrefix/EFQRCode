/*:
 #### 2.1. Parameters Explained
 [2. Generation](@previous) | [3. Generation from GIF](@next)
 */
import EFQRCode
import UIKit
/*:
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
let urlForEFQRCode = "https://github.com/EyreFree/EFQRCode"
let background = #imageLiteral(resourceName: "eyrefree.png").cgImage
//: - Experiment: Normal mode (`nil`)
EFQRCodeGenerator(content: urlForEFQRCode)
    .withWatermark(background)
    .withMode(nil)
    .generate()
//: - Experiment: Grayscale mode
EFQRCodeGenerator(content: urlForEFQRCode)
    .withWatermark(background)
    .withMode(.grayscale)
    .generate()
//: - Experiment: Binarization mode, try change the threshold
let threshold: CGFloat = 0.1
EFQRCodeGenerator(content: urlForEFQRCode)
    .withWatermark(background)
    .with(\.backgroundColor, #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor)
    .withMode(.binarization(threshold: threshold))
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
//: - Experiment: M: 15%
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
 ##### size: EFIntSize

 The width and height of QR code, defaults to 256 x 256.

 - Important: If magnification is not nil, size will be ignored.
 */
//: - Note: `EFIntSize` is just like `CGSize`, but `width` and `height` are `Int` instead of `CGFloat`.
let size234 = EFIntSize(width: 234, height: 234)
//: - Experiment: Generate a QRCode of size 234 by 234:
EFQRCodeGenerator(content: urlForEFQRCode, size: size234)
    .generate()
//: - Experiment: Generate a QRCode of size 312 by 234:
EFQRCodeGenerator(content: urlForEFQRCode)
    .withSize(EFIntSize(width: 312, height: 234))
    .generate()

/*:
 ##### magnification: EFIntSize?

 Magnification is defined as the ratio of actual size to the smallest possible size, and defaults to `nil`.
 */
//: - Experiment: Directly setting the `size` parameter results in low resolution QR code images,
EFQRCode.generate(for: urlForEFQRCode,
                  size: EFIntSize(width: 351, height: 351))
//: so setting the `magnification` is recommended instead:
EFQRCode.generate(for: urlForEFQRCode,
                  magnification: EFIntSize(width: 9, height: 9))
//: If you already have a desired size in mind, we have two helpers methods at your disposal to calculate the magnification that results in the closet dimension.
let desiredSize: CGFloat = 520
let generatorForMagnification = EFQRCodeGenerator(content: urlForEFQRCode)
//: - Experiment: We want to get max magnification where size ≤ desired size
if let maxMagnification = generatorForMagnification
    .maxMagnification(lessThanOrEqualTo: desiredSize) {
    maxMagnification
    generatorForMagnification.magnification = EFIntSize(
        width: maxMagnification,
        height: maxMagnification
    )
    generatorForMagnification.generate()
}
//: - Experiment: We want to get min magnification where size ≥ desired size
if let minMagnification = generatorForMagnification
    .minMagnification(greaterThanOrEqualTo: desiredSize) {
    minMagnification
    generatorForMagnification.magnification = EFIntSize(
        width: minMagnification,
        height: minMagnification
    )
    generatorForMagnification.generate()
}

/*:
 #### foreground/backgroundColor: CIColor/CGColor

 Background color defaults to white, foreground color (for code points) defaults to black.
 */
EFQRCode.generate(for: urlForEFQRCode, foregroundColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor)
EFQRCode.generate(for: urlForEFQRCode, backgroundColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor)
//: - Experiment: Design a high-contrast color theme:
EFQRCodeGenerator(content: urlForEFQRCode)
    .withColors(backgroundColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1).cgColor,
                foregroundColor: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).cgColor)
    .generate()

/*:
 ##### icon: CGImage?

 Icon image in the center of QR code image, defaults to `nil`.
 */
let icon = #imageLiteral(resourceName: "eyrefree.png").cgImage

EFQRCodeGenerator(content: urlForEFQRCode)
    .withIcon(icon, size: nil)
    .generate()

/*:
 ##### iconSize: CGFloat?

 Size of icon image, defaults to 20% of QR code size if `nil`.

 - Experiment: Change the icon size to see how it changes.
 */
EFQRCodeGenerator(content: urlForEFQRCode)
    .withIcon(icon, size: EFIntSize(width: 64, height: 64))
    .generate()

/*:
 ##### watermark: CGImage?

 Background watermark image, defaults to `nil`.
 */
EFQRCode.generate(for: urlForEFQRCode)
// - Experiment: Setting a background watermark image:
let watermark = #imageLiteral(resourceName: "eyrefree.png").cgImage
EFQRCodeGenerator(content: urlForEFQRCode)
    .withWatermark(watermark)
    .generate()
/*:
 ##### watermarkMode: EFWatermarkMode

 Position of watermark in the QR code, defaults to `scaleAspectFill`.

 - Note: Think of the generated QR code like `UIImageView` and `EFWatermarkMode` as `UIView.ContentMode`.
 */
//: - Experiment: Change the watermark mode and see how the background changes.
EFQRCodeGenerator(content: urlForEFQRCode)
    .withWatermark(watermark, mode: .center)
    .generate()
/*:
 ##### isWatermarkOpaque: Bool

 Treat watermark image as opaque, defaults to `false` (use transparency).
 */
//: - Experiment: Use a watermark image with alpha channel:
let transparentWatermark = #imageLiteral(resourceName: "transparent.png").cgImage
EFQRCode.generate(
    for: urlForEFQRCode,
    backgroundColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1).cgColor, foregroundColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1).cgColor,
    watermark: transparentWatermark /*, watermarkIsTransparent: true */
)
//: - Experiment: See how opaque watermark looks instead:
EFQRCodeGenerator(content: urlForEFQRCode)
    .withWatermark(transparentWatermark)
    // .withTransparentWatermark() // default
    .withOpaqueWatermark() // explicitly use opaque watermark
    .withColors(backgroundColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1).cgColor, foregroundColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1).cgColor)
    .generate()

/*:
 ##### pointOffset: CGFloat

 Foreground point offset, defaults to 0.

 - Important: Caution! Generated QR code might be hard to recognize with this parameter.
 */
//: - Experiment: See how this parameter affects the recognition.
EFQRCodeGenerator(content: urlForEFQRCode)
    .withPointOffset(0.5)
    .generate()

/*:
 ##### pointShape: EFPointShape

 Shape of foreground code points, defaults to `square`.

 - Experiment: See how different point shapes look like.
 */
//: - Example: Circle
EFQRCode.generate(for: urlForEFQRCode, pointShape: .circle)
//: - Example: Diamond
EFQRCode.generate(for: urlForEFQRCode, pointShape: .diamond)
//: - Example: Diamond everything!
EFQRCode.generate(for: urlForEFQRCode,
                  pointShape: .diamond, isTimingPointStyled: true)

//: [2. Generation](@previous) | [3. Generation from GIF](@next)
