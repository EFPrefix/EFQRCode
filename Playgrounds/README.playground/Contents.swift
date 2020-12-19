import UIKit
//: ## Quick Start
//: #### 1. Import EFQRCode
//: Import EFQRCode module where you want to use it:
import EFQRCode
/*: #### 2. Recognition
 - Important: There may be several codes in an image, so the API returns an array.
*/
//: - Experiment: Add your own QR code image to Resources folder, and try reading the contents out of it:
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

/*:
#### 3. Generation

 Here are few basic parameters that you might want to change/provide when creating a QR code image:

 - content: ***REQUIRED*** (otherwise what are you generating for?
 - size: Width and height of image
 - backgroundColor: Background color of QRCode
 - foregroundColor: Foreground color of QRCode
 - watermark: Background image of QRCode
*/
//: - Experiment: Generate your own QR code image:
EFQRCode.generate(for: "Hello World")
//: - Experiment: Add a background image to Resources folder and generate with it:
if let image = EFQRCode.generate(
    for: "https://github.com/EFPrefix/EFQRCode",
    watermark: UIImage(named: "background")?.cgImage
) {
    print("Create QRCode image success")
    image
} else {
    print("Create QRCode image failed!")
}

/*: #### 4. Generation from GIF
 - generator: ***REQUIRED***, an instance of EFQRCodeGenerator providing other settings|
 - data: ***REQUIRED***, encoded input GIF|
 - pathToSave: Where to save the output GIF, default to some temporary path|
 - delay: Output QRCode GIF delay, emitted means no change|
 - loopCount: Times looped in GIF, emitted means no change|
 */
//: - Experiment: Add a GIF to Resouces folder and try generating an animated QRCode:
let gif = Data() // TODO: replace with actual gif data
let generator = EFQRCodeGenerator(content: "OwO")
EFQRCode.generateGIF(using: generator, withWatermarkGIF: gif)

//: #### 5. Next
//: Learn more from "`User Guide.playground`" in the same folder.
