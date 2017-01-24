//
//  UIImage+.swift
//  Pods
//
//  Created by EyreFree on 17/1/24.
//
//

import Foundation

// InputCorrectionLevel
// L 7%
// M 15%
// Q 25%
// H 30%
public enum InputCorrectionLevel: Int {
    case l = 0;
    case m = 1;
    case q = 2;
    case h = 3;
}

public extension UIImage {

    // Get QRCodes from image
    public func toQRCodeString() -> [String] {
        var result = [String]()
        let detector = CIDetector(
            ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh]
        )
        if let tryCGImage = self.cgImage {
            if let features = detector?.features(in: CIImage(cgImage: tryCGImage)) {
                for feature in features {
                    if let tryString = (feature as? CIQRCodeFeature)?.messageString {
                        result.append(tryString)
                    }
                }
            }
        }
        return result
    }

    // Create image from QRCode string
    public convenience init?(
        QRCodeString: String,
        size: CGFloat = 160,
        inputCorrectionLevel: InputCorrectionLevel = .m,
        iconImage: UIImage? = nil,
        iconImageSize: CGFloat? = nil
        ) {
        if let ciimage = UIImage.createCIImage(With: QRCodeString, inputCorrectionLevel: inputCorrectionLevel) {
            if let tryCGImage = UIImage.createUIImageFrom(
                image: ciimage , with: size, iconImage: iconImage, iconImageSize: iconImageSize
                )?.cgImage {
                self.init(cgImage: tryCGImage)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    private static func createCIImage(
        With QRString: String,
        inputCorrectionLevel: InputCorrectionLevel = .m
        ) -> CIImage? {
        let stringData = QRString.data(using: String.Encoding.utf8)
        if let qrFilter = CIFilter(name: "CIQRCodeGenerator") {
            qrFilter.setValue(stringData, forKey: "inputMessage")
            qrFilter.setValue(["L", "M", "Q", "H"][inputCorrectionLevel.rawValue], forKey: "inputCorrectionLevel")
            return qrFilter.outputImage
        }
        return nil
    }

    private static func createUIImageFrom(
        image: CIImage,
        with size: CGFloat,
        iconImage: UIImage?,
        iconImageSize: CGFloat?
        ) -> UIImage? {
        let extent = image.extent.integral
        let scale: CGFloat = min(size / extent.width, size / extent.height)

        // Create bitmap
        let width  = size_t(extent.width.multiplied(by: scale))
        let height = size_t(extent.height.multiplied(by: scale))

        if let bitmapRef = CGContext(
            data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
            ) {
            let context = CIContext(options: nil)
            if let bitmapImage = context.createCGImage(image, from: extent) {
                bitmapRef.interpolationQuality = CGInterpolationQuality.none
                bitmapRef.scaleBy(x: scale, y: scale)
                bitmapRef.draw(bitmapImage, in: extent)

                // Save bitmap to image
                if let scaledImage = bitmapRef.makeImage() {
                    // Ori image
                    let outputImage = UIImage(cgImage: scaledImage)
                    UIGraphicsBeginImageContextWithOptions(outputImage.size, false, UIScreen.main.scale)
                    outputImage.draw(in: CGRect(x: 0, y: 0, width: size, height: size))

                    // Water image
                    if let waterimage = iconImage {
                        let waterImagesize: CGFloat = iconImageSize ?? (0.06 * size)
                        waterimage.draw(
                            in: CGRect(
                                x: (size - waterImagesize) / 2.0,
                                y: (size - waterImagesize) / 2.0,
                                width: waterImagesize,
                                height: waterImagesize
                            )
                        )
                    }

                    // Final Image
                    let newPic = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    return newPic
                }
            }
        }
        return nil
    }
}
