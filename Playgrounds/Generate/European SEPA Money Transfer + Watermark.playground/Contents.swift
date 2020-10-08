import EFQRCode
import UIKit

/*:
 # European Credit Transfer code + Watermark
 
 The code below generates a EPC QR code to initiate a SEPA credit transfer. Almost any European banking
 app can be used to scan this code and execute a money transfer.
 
 All settings are according to the [official spec](https://www.europeanpaymentscouncil.eu/sites/default/files/kb/file/2018-05/EPC069-12%20v2.1%20Quick%20Response%20Code%20-%20Guidelines%20to%20Enable%20the%20Data%20Capture%20for%20the%20Initiation%20of%20a%20SCT.pdf). See also [Wikipedia EPC QR Code](https://en.wikipedia.org/wiki/EPC_QR_code).
 
 Thie examples below create money transfer codes of €1 to the Belgian Red Cross.
 
  ***
 */

/*: Set up de content of the QR code - this can be any string.
 
Note: In production code, you should abstract this data to a struct with some basic checks. For example - limit the size of the Remittance fields in order to not generate large QR codes (According to spec: "Maximum QR code version 13, equivalent to module size 69 or 331 byte payload")
*/
let belgianRedCrossEPC = """
BCD
002
1
SCT

Red Cross of Belgium
BE72000000001616
EUR1
https://github.com/EFPrefix/EFQRCode
"""

//: Generate a basic QR code. Scan this with a European banking app.
if let tryImage = EFQRCode.generate(
    content: belgianRedCrossEPC,
    inputCorrectionLevel: .m // medium - 15% ECC
) {
    _ = tryImage // Click quickview or enable 'show result' on the right →
}

//: Make it fancy - add a **watermark** image. Mind that, while looking very cool, this may not be recognized as a QR code by some people. Also, these kinds of codes are more difficult to recognize by readers. Use with caution!
let redcross = UIImage(named: "red-cross-logo.png")?.cgImage
if let tryImage = EFQRCode.generate(
    content: belgianRedCrossEPC,
    watermark: redcross,
    inputCorrectionLevel: .m // medium - 15% ECC
) {
    _ = tryImage // Click quickview or enable 'show result' on the right →
}

//: Set `allowTransparent` to `false` in order to get a different style.
if let tryImage = EFQRCode.generate(
    content: belgianRedCrossEPC,
    watermark: redcross,
    inputCorrectionLevel: .m, // medium - 15% ECC
    allowTransparent: false
) {
    _ = tryImage // Click quickview or enable 'show result' on the right →
}
