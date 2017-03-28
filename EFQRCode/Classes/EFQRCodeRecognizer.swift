//
//  EFQRCodeRecognizer.swift
//  Pods
//
//  Created by EyreFree on 2017/3/28.
//
//

import Foundation

class EFQRCodeRecognizer {

    var contents = [String]()

    init(image: UIImage) {
        contents = getQRString(From: image)
    }

    // Get QRCodes from image
    private func getQRString(From image: UIImage) -> [String] {
        // 原图
        let result = scanFrom(image: image, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        // 灰度图
        if result.count <= 0 {
            return scanFrom(
                image: EFQRCode.greyScale(image: image), options: [CIDetectorAccuracy : CIDetectorAccuracyLow]
            )
        }
        return result
    }

    private func scanFrom(image: UIImage?, options: [String : Any]? = nil) -> [String] {
        var result = [String]()
        if let tryImage = image {
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options)
            if let tryCGImage = tryImage.cgImage {
                if let features = detector?.features(in: CIImage(cgImage: tryCGImage)) {
                    for feature in features {
                        if let tryString = (feature as? CIQRCodeFeature)?.messageString {
                            result.append(tryString)
                        }
                    }
                }
            }
        }
        return result
    }
}
