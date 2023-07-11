//
//  EFQRCode+Recognizer.swift
//  EFQRCode
//
//  Created by EyreFree on 2023/7/11.
//  Copyright © 2023 EyreFree. All rights reserved.
//

#if canImport(CoreImage)
import CoreImage

public extension EFQRCode {
    
    /// Class for recognizing QR code contents from images.
    @objcMembers
    class Recognizer: NSObject {
        /// The QR code to recognize.
        public var image: CGImage {
            didSet {
                contentArray = nil
            }
        }
        
        /// Recognized QR code content cache.
        private var contentArray: [String]?
        
        /// Initialize a QR code recognizer to recognize the specified `image`.
        /// - Parameter image: a QR code to recognize.
        public init(image: CGImage) {
            self.image = image
        }
        
        /// Recognizes and returns the contents of the current QR code `image`.
        /// - Returns: an array of contents recognized from `image`.
        /// - Note: If the returned array is empty, there's no recognizable content in the QR code `image`.
        public func recognize() -> [String] {
            if nil == contentArray {
                contentArray = getQRString()
            }
            return contentArray!
        }
        
        /// Get QRCodes from image
        private func getQRString() -> [String] {
            let result = image.ciImage().recognizeQRCode(
                options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            )
            if result.isEmpty, let grayscaleImage = image.grayscale {
                return grayscaleImage.ciImage().recognizeQRCode(
                    options: [CIDetectorAccuracy: CIDetectorAccuracyLow]
                )
            }
            return result
        }
    }
}
#endif
