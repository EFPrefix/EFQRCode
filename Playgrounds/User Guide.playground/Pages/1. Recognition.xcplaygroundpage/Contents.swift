/*:
 ## 1. Recognition
 [Welcome](@previous) | [2. Generation](@next)
*/
import EFQRCode
import UIKit
guard let cgImage = EFQRCode.generate(for: "Hello World") else {
    fatalError("Something went wrong. Goodbye.")
}
/*:

 There are two equivalent ways:

 ```swift
 EFQRCode.recognize(CGImage)
 ```
*/
EFQRCode.recognize(cgImage)
/*:
 ```
 EFQRCodeRecognizer(image: CGImage).recognize()
 ```
*/
EFQRCodeRecognizer(image: cgImage).recognize()
//: Because of the possibility that more than one QR code exist in the same image, the return value is `[String]`. If the returned array is empty, we could not recognize/didn't find any QR code in the image.

//: [Welcome](@previous) | [2. Generation](@next)
