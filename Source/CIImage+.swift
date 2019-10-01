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

public extension CIImage {
    
    /// Convert CIImage To CGImage
    /// http://wiki.hawkguide.com/wiki/Swift:_Convert_between_CGImage,_CIImage_and_UIImage
    func toCGImage() -> CGImage? {
        if #available(iOS 10, macOS 10.12, tvOS 10, *) {
            if let cgImage = cgImage {
                return cgImage
            }
        }
        return CIContext().createCGImage(self, from: extent)
    }
    
    /// Size
    func size() -> CGSize {
        return extent.size
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
    static func generateQRCode(string: String, inputCorrectionLevel: EFInputCorrectionLevel = .m) -> CIImage? {
        let stringData = string.data(using: .utf8)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        qrFilter.setValue(stringData, forKey: "inputMessage")
        qrFilter.setValue(["L", "M", "Q", "H"][inputCorrectionLevel.rawValue], forKey: "inputCorrectionLevel")
        return qrFilter.outputImage
    }
}
#endif
