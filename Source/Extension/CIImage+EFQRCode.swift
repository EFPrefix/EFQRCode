//
//  CIImage+.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/11.
//
//  Copyright (c) 2017-2024 EyreFree <eyrefree@eyrefree.org>
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

/**
 * Extensions for CIImage to support QR code recognition and image processing.
 *
 * This extension provides utility methods for CIImage that enable QR code detection
 * and conversion to other image formats used throughout the EFQRCode library.
 *
 * ## Features
 *
 * - QR code recognition from images
 * - Conversion to CGImage for Core Graphics operations
 * - Conversion to UIImage for UIKit-based platforms
 * - High-performance image processing with Core Image
 *
 * ## Usage
 *
 * ```swift
 * let ciImage = CIImage(image: qrCodeImage)
 * 
 * // Recognize QR codes
 * let qrCodes = ciImage.recognizeQRCode()
 * 
 * // Convert to CGImage
 * if let cgImage = ciImage.cgImage() {
 *     // Use with Core Graphics
 * }
 * 
 * // Convert to UIImage (iOS/tvOS/watchOS only)
 * let uiImage = ciImage.uiImage()
 * ```
 *
 * ## Platform Support
 *
 * - **QR Code Recognition**: Available on all platforms with Core Image
 * - **CGImage Conversion**: Available on all platforms with Core Image
 * - **UIImage Conversion**: Only available on iOS, tvOS, and watchOS
 */
extension CIImage {
    /**
     * Converts the CIImage to a CGImage.
     *
     * This method attempts to get the CGImage directly from the CIImage if available.
     * If that fails, it creates a new CGImage using a CIContext.
     *
     * - Returns: A CGImage representation of the CIImage, or nil if conversion fails.
     */
    func cgImage() -> CGImage? {
        if #available(iOS 10, macOS 10.12, tvOS 10, watchOS 2, *) {
            if let cgImage = self.cgImage {
                return cgImage
            }
        }
        return CIContext().createCGImage(self, from: self.extent)
    }

    #if canImport(UIKit)
    /**
     * Converts the CIImage to a UIImage.
     *
     * This method creates a UIImage from the CIImage for use in UIKit-based applications.
     *
     * - Returns: A UIImage representation of the CIImage.
     */
    func uiImage() -> UIImage {
        return UIImage(ciImage: self)
    }
    #endif
    
    /**
     * Recognizes QR codes in the CIImage.
     *
     * This method uses Core Image's QR code detector to find and decode QR codes
     * within the image. It returns an array of strings containing the decoded content
     * from all detected QR codes.
     *
     * - Parameter options: Optional detection options for the QR code detector.
     *   Common options include `CIDetectorAccuracy` for controlling detection accuracy.
     * - Returns: An array of strings containing the recognized QR code contents.
     *   If no QR codes are found, the array will be empty.
     *
     * ## Example
     *
     * ```swift
     * let ciImage = CIImage(image: qrCodeImage)
 * 
     * // High accuracy detection
     * let highAccuracyResults = ciImage.recognizeQRCode(
     *     options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]
     * )
     * 
     * // Low accuracy detection (faster but less accurate)
     * let lowAccuracyResults = ciImage.recognizeQRCode(
     *     options: [CIDetectorAccuracy: CIDetectorAccuracyLow]
     * )
     * ```
     */
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
