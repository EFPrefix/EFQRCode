//
//  EFQRCode.swift
//  Pods
//
//  Created by EyreFree on 17/1/24.
//
//

import Foundation

public class EFQRCode {

    private init() {
        
    }

    // Get QRCodes from image
    public static func GetQRCodeString(From image: UIImage) -> [String] {
        return image.toQRCodeString()
    }

    // Create image from QRCode string
    public static func CreateQRCodeImage(
        With QRCodeString: String,
        size: CGFloat = 160,
        inputCorrectionLevel: InputCorrectionLevel = .m,
        iconImage: UIImage? = nil,
        iconImageSize: CGFloat? = nil
        ) -> UIImage? {
        return UIImage(
            QRCodeString: QRCodeString,
            size: size,
            inputCorrectionLevel:
            inputCorrectionLevel,
            iconImage: iconImage,
            iconImageSize: iconImageSize
        )
    }
}
