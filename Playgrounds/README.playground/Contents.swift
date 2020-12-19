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
