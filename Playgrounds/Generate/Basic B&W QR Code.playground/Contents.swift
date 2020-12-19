/*:
 ## Generate - Basic B&W QR code
 
 Generates a 600 x 600 black&white QR code
 
 contentEncoding: utf8,
 size: 600 x 600,
  */
import EFQRCode

let content = "https://github.com/EFPrefix/EFQRCode"

if let tryImage = EFQRCode.generate(for: content) {
    print("Create QRCode image success")
    tryImage
} else {
    print("Create QRCode image failed!")
}
