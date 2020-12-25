/*:
 ### 3. Generation from GIF

 [2.1. Parameters Explained](@previous) | [4. Final Remarks](@next)
*/
import EFQRCode
/*:
1. First, you should get the complete `Data` of a GIF file.

 - Important: You shall not get `Data` from `UIImage` as it only provides the first frame.

 */
let data = Data() // TODO: get actual GIF data
//: 2. Then, configure however you like just like before.
let generator = EFQRCodeGenerator(content: "https://github.com/EyreFree/EFQRCode")
//: 3. Now you can create GIF QR code with `EFQRCode.generateWithGIF` and get its data:
let qrcodeData = EFQRCode.generateGIF(using: generator, withWatermarkGIF: data)
//: 4. Next we can save it to local path / system photo library / upload to server or some other things you want to do;

//:  [2.1. Parameters Explained](@previous) | [4. Final Remarks](@next)
