//
//  EFQRCodeRecognizer.swift
//  Pods
//
//  Created by EyreFree on 2017/3/28.
//
//

import Foundation

class EFQRCodeRecognizer {

    public var image: UIImage? {
        didSet {
            contentArray = nil
        }
    }
    var contents: [String]? {
        get {
            if nil == contentArray {
                contentArray = getQRString()
            }
            return contentArray
        }
    }

    private var contentArray: [String]?

    init(image: UIImage) {
        self.image = image
    }

    // Get QRCodes from image
    private func getQRString() -> [String]? {

        guard let finalImage = self.image else {
            return nil
        }
        let result = scanFrom(image: finalImage, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        if (result?.count ?? 0) <= 0 {
            return scanFrom(
                image: finalImage.greyScale(), options: [CIDetectorAccuracy : CIDetectorAccuracyLow]
            )
        }
        return result
    }

    private func scanFrom(image: UIImage?, options: [String : Any]? = nil) -> [String]? {
        if let tryCGImage = image?.cgImage {
            var result = [String]()
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options)
            if let features = detector?.features(in: CIImage(cgImage: tryCGImage)) {
                for feature in features {
                    if let tryString = (feature as? CIQRCodeFeature)?.messageString {
                        result.append(tryString)
                    }
                }
            }
            return result
        }
        return nil
    }
}
