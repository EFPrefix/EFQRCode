//
//  CIImage+.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/3/29.
//
//  Copyright (c) 2017 EyreFree <eyrefree@eyrefree.org>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if canImport(CoreImage)
import CoreImage
import CoreImage.CIFilterBuiltins

#if canImport(UIKit)
import UIKit
#endif

extension CIImage {
    func cgImage() -> CGImage? {
        if #available(iOS 10, macOS 10.12, tvOS 10, watchOS 2, *) {
            if let cgImage = self.cgImage {
                return cgImage
            }
        }
        return CIContext().createCGImage(self, from: self.extent)
    }

    #if canImport(UIKit)
    func uiImage() -> UIImage {
        return UIImage(ciImage: self)
    }
    #endif
    
    var size: CGSize {
        return self.extent.size
    }
    
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
    
    /// Create QR CIImage
    static func generateQRCode(_ string: String, using contentEncoding: String.Encoding = .utf8, inputCorrectionLevel: EFInputCorrectionLevel = .m) -> CIImage? {
        guard let stringData = string.data(using: contentEncoding) else {
            return nil
        }
        let correctionLevel = ["L", "M", "Q", "H"][inputCorrectionLevel.rawValue]
        
        if #available(iOS 13.0, tvOS 13.0, macOS 10.15, *) {
            let qrFilter = CIFilter.qrCodeGenerator()
            qrFilter.message = stringData
            qrFilter.correctionLevel = correctionLevel
            return qrFilter.outputImage
        } else {
            guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
                return nil
            }
            qrFilter.setDefaults()
            qrFilter.setValue(stringData, forKey: "inputMessage")
            qrFilter.setValue(correctionLevel, forKey: "inputCorrectionLevel")
            return qrFilter.outputImage
        }
    }
}
#endif
