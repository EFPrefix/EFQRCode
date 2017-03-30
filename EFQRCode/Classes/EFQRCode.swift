//
//  EFQRCode.swift
//  Pods
//
//  Created by EyreFree on 2017/3/28.
//
//

import Foundation

public class EFQRCode {

    // MARK:- Recognizer
    public static func recognize(image: UIImage) -> [String]? {

        return EFQRCodeRecognizer(image: image).contents
    }

    public static func generate(
        content: String,
        inputCorrectionLevel: EFInputCorrectionLevel = .h,
        size: CGFloat = 256,
        magnification: UInt? = nil,
        backgroundColor: UIColor = UIColor.white,
        foregroundColor: UIColor = UIColor.black,
        icon: UIImage? = nil,
        iconSize: CGFloat? = nil,
        isIconColorful: Bool = true,
        watermark: UIImage? = nil,
        watermarkMode: EFWatermarkMode = .scaleToFill,
        isWatermarkColorful: Bool = true
        ) -> UIImage? {

        return EFQRCodeGenerator(
            content: content,
            inputCorrectionLevel: inputCorrectionLevel,
            size: size,
            magnification: magnification,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            icon: icon,
            iconSize: iconSize,
            isIconColorful: isIconColorful,
            watermark: watermark,
            watermarkMode: watermarkMode,
            isWatermarkColorful: isWatermarkColorful
            ).image
    }
}
