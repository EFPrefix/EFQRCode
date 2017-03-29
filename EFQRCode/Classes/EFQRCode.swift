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
    public static func getQRString(From image: UIImage) -> [String]? {
        return EFQRCodeRecognizer(image: image).contents()
    }

    // MARK:- Generator
    public static func createQRImage(string: String, inputCorrectionLevel: EFInputCorrectionLevel = .m, size: CGSize? = nil) -> UIImage? {
        return EFQRCodeGenerator(content: string, inputCorrectionLevel: inputCorrectionLevel, size: size).image
    }

    public static func createQRImage(
        string: String,
        inputCorrectionLevel: EFInputCorrectionLevel = .m,
        size: CGFloat? = nil,
        quality :EFQuality = EFQuality.middle,
        backColor: UIColor = UIColor.white,
        frontColor: UIColor = UIColor.black,
        icon: UIImage? = nil,
        iconSize: CGFloat? = nil,
        iconColorful: Bool = true,
        watermark: UIImage? = nil,
        watermarkMode: EFWatermarkMode = .scaleToFill,
        watermarkColorful: Bool = true
        ) -> UIImage? {
        return EFQRCodeGenerator.createQRImage(
            string: string,
            inputCorrectionLevel: inputCorrectionLevel,
            size: size,
            quality: quality,
            backColor: backColor,
            frontColor: frontColor,
            icon: icon,
            iconSize: iconSize,
            iconColorful: iconColorful,
            watermark: watermark,
            watermarkMode: watermarkMode,
            watermarkColorful: watermarkColorful
        )
    }
}
