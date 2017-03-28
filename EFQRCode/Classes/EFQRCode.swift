//
//  EFQRCode.swift
//  Pods
//
//  Created by EyreFree on 2017/3/28.
//
//

import Foundation

public class EFQRCode {

    // Grey
    static func greyScale(image: UIImage?) -> UIImage? {
        // http://stackoverflow.com/questions/40178846/convert-uiimage-to-grayscale-keeping-image-quality
        if let tryImage = image {
            let context = CIContext(options: nil)
            if let currentFilter = CIFilter(name: "CIPhotoEffectNoir") {
                currentFilter.setValue(CIImage(image: tryImage), forKey: kCIInputImageKey)
                if let output = currentFilter.outputImage {
                    if let cgimg = context.createCGImage(output,from: output.extent) {
                        let processedImage = UIImage(cgImage: cgimg)
                        return processedImage
                    }
                }
            }
        }
        return nil
    }

    // MARK:- Recognizer
    public static func getQRString(From image: UIImage) -> [String] {
        return EFQRCodeRecognizer(image: image).contents
    }

    // MARK:- Generator
    public static func createQRImage(string: String, inputCorrectionLevel: EFInputCorrectionLevel = .m) -> UIImage? {
        return EFQRCodeGenerator.createQRImage(string: string, inputCorrectionLevel: inputCorrectionLevel)
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
