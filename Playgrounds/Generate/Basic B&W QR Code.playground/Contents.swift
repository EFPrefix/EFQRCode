import EFQRCode
import CoreImage
import UIKit
import PlaygroundSupport

/*:
 ## Generate - Basic B&W QR code
 
 Generates a 600 x 600 black&white QR code
 
 contentEncoding: utf8,
 size: 600 x 600,
  */

if let tryImage = EFQRCode.generate(
    content: "https://github.com/EFPrefix/EFQRCode"
) {
    print("Create QRCode image success: \(tryImage)")
    _ = tryImage
} else {
    print("Create QRCode image failed!")
}

