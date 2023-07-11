//
//  CIImage+.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/11.
//  Copyright © 2023 EyreFree. All rights reserved.
//

#if canImport(CoreImage)
import CoreImage
import CoreImage.CIFilterBuiltins

extension CIImage {
    /// Get QRCode from image
    func recognizeQRCode(options: [String : Any]? = nil) -> [String] {
        var result = [String]()
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options)
        guard let features = detector?.features(in: self) else {
            return result
        }
        result = features.compactMap { feature in
            (feature as? CIQRCodeFeature)?.messageString
        }
        return result
    }
}
#endif
