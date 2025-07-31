//
//  EFQRCode+Recognizer.swift
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

public extension EFQRCode {
    
    /**
     * A QR code recognizer that extracts QR code content from images.
     *
     * The `Recognizer` class provides functionality to detect and decode QR codes
     * from images. It uses Core Image's QR code detection capabilities with
     * high accuracy settings and fallback to low accuracy if needed.
     *
     * ## Basic Usage
     *
     * ```swift
     * // Create a recognizer with an image
     * let recognizer = EFQRCode.Recognizer(image: qrCodeImage)
     * 
     * // Recognize QR code content
     * let contents = recognizer.recognize()
     * 
     * // Check if any QR codes were found
     * if !contents.isEmpty {
     *     print("Found QR code: \(contents[0])")
     * }
     * ```
     *
     * ## Features
     *
     * - **High Accuracy**: Uses high accuracy detection by default
     * - **Fallback Detection**: Automatically falls back to low accuracy if no QR codes are found
     * - **Multiple QR Codes**: Can detect multiple QR codes in a single image
     * - **Caching**: Results are cached for performance
     * - **Image Updates**: Automatically clears cache when image is updated
     *
     * ## Requirements
     *
     * - Core Image framework must be available
     * - Image must contain recognizable QR code content
     */
    class Recognizer {
        /**
         * The image containing the QR code to recognize.
         *
         * When this property is set, the cached recognition results are cleared
         * to ensure fresh recognition on the new image.
         */
        public var image: CGImage {
            didSet {
                contentArray = nil
            }
        }
        
        /**
         * Cached array of recognized QR code contents.
         *
         * This cache is used to avoid re-recognizing the same image multiple times.
         * It's automatically cleared when the image is updated.
         */
        private var contentArray: [String]?
        
        /**
         * Creates a QR code recognizer for the specified image.
         *
         * - Parameter image: The CGImage containing the QR code to recognize.
         */
        public init(image: CGImage) {
            self.image = image
        }
        
        /**
         * Recognizes and returns the contents of QR codes in the current image.
         *
         * This method performs QR code detection on the current image and returns
         * an array of strings containing the decoded content from all detected QR codes.
         * The results are cached for subsequent calls until the image is changed.
         *
         * - Returns: An array of strings containing the recognized QR code contents.
         *   If no QR codes are found, the array will be empty.
         * - Note: The method uses high accuracy detection first, then falls back to
         *   low accuracy if no QR codes are detected with high accuracy.
         */
        public func recognize() -> [String] {
            if nil == contentArray {
                contentArray = getQRString()
            }
            return contentArray!
        }
        
        /**
         * Performs QR code detection on the current image.
         *
         * This method uses Core Image's QR code detector with high accuracy settings.
         * If no QR codes are found with high accuracy, it attempts detection with
         * low accuracy settings on a grayscale version of the image.
         *
         * - Returns: An array of strings containing the recognized QR code contents.
         */
        private func getQRString() -> [String] {
            let result = image.ciImage().recognizeQRCode(
                options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            )
            if result.isEmpty, let grayscaleImage = try? image.grayscale() {
                return grayscaleImage.ciImage().recognizeQRCode(
                    options: [CIDetectorAccuracy: CIDetectorAccuracyLow]
                )
            }
            return result
        }
    }
}
#endif
