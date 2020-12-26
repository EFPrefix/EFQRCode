/*:
 ## Generate - Basic B&W QR code

 - Example: Generates a 600 × 600 black & white QR code with default content encoding (UTF-8):
 */
import EFQRCode

let content = "https://github.com/EFPrefix/EFQRCode"

if let tryImage = EFQRCode.generate(for: content) {
    print("Create QRCode image success")
    tryImage
} else {
    print("Create QRCode image failed!")
}
