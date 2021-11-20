/*:
 ### 2. Generation
 What you'll see in this page might be overwhelming, but no worries. We'll explain everything in [2.1. Parameters Explained](@next).
 */
import EFQRCode
import UIKit
//: The return value is of type `CGImage?`
EFQRCode.generate(for: "Hello World")
//:  because if something went wrong during generation, let's say content length exceeded capacity constraint, for example, then `nil` will be returned.
EFQRCode.generate(for: "Hello World" * 200)
/*:
 Again, there are two equivalent ways of doing this:

 ---

 #### Method 1: with EFQRCode.generate
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
*/
EFQRCode.generate(
    for: "https://github.com/EyreFree/EFQRCode", encoding: .utf8,
    inputCorrectionLevel: .l,
    size: EFIntSize(width: 350, height: 350), magnification: nil,
    backgroundColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).cgColor, foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor,
    watermark: #imageLiteral(resourceName: "eyrefree.png").cgImage, watermarkMode: .left, watermarkIsTransparent: false,
    icon: #imageLiteral(resourceName: "eyrefree.png").cgImage, iconSize: EFIntSize(width: 30, height: 30),
    pointStyle: .circle, pointOffset: 3, isTimingPointStyled: true,
    mode: .binarization(threshold: 0.1)
)
//: ---
/*:
 #### Method 2: with an EFQRCodeGenerator

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
 generator.withPointStyle(EFPointStyle)
 // Lastly, get the final two-dimensional code image
 generator.generate()
 ```
*/
let generator = EFQRCodeGenerator(
    content: "https://github.com/EyreFree/EFQRCode", encoding: .utf8,
    size: EFIntSize(width: 350, height: 350)
)
.withInputCorrectionLevel(.l)
.withColors(backgroundColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).cgColor, foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor)
.withWatermark(#imageLiteral(resourceName: "eyrefree.png").cgImage, mode: .left)
.withIcon(#imageLiteral(resourceName: "eyrefree.png").cgImage, size: EFIntSize(width: 30, height: 30))
.withPointStyle(.circle)
.withPointOffset(3)
.withStyledTimingPoint()
.withMode(.binarization(threshold: 0.1))
//: Remember to generate the image after configuring a generator!
generator.generate()
//: [1. Recognition](@previous) | [2.1 Parameters Explained](@next)
