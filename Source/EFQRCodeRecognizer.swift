//
//  EFQRCodeRecognizer.swift
//  EFQRCode
//
//  Created by EyreFree on 2017/3/28.
//
//  Copyright (c) 2017-2021 EyreFree <eyrefree@eyrefree.org>
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

/// Class for recognizing QR code contents from images.
@objcMembers
public class EFQRCodeRecognizer: NSObject {
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
#endif
