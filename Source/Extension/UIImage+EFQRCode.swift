//
//  UIImage+.swift
//  EFQRCode
//
//  Created by EyreFree on 2024/7/27.
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

import CoreGraphics
import ImageIO
#if canImport(UIKit)
import UIKit
#if canImport(CoreImage)
import CoreImage
#endif

/**
 * Extensions for UIImage to support QR code generation and processing on iOS/tvOS/watchOS.
 *
 * This extension provides utility methods for UIImage that enable conversion
 * to other image formats used throughout the EFQRCode library.
 *
 * ## Features
 *
 * - Conversion to CIImage for Core Image processing
 * - Conversion to CGImage for Core Graphics operations
 * - Cross-platform compatibility with AppKit-based systems
 *
 * ## Usage
 *
 * ```swift
 * let uiImage = UIImage(named: "QRCode")
 * 
 * // Convert to CIImage for processing
 * if let ciImage = uiImage.ciImage() {
 *     // Use with Core Image filters
 * }
 * 
 * // Convert to CGImage for graphics operations
 * if let cgImage = uiImage.cgImage() {
 *     // Use with Core Graphics
 * }
 * ```
 *
 * ## Platform Support
 *
 * This extension is only available on iOS, tvOS, and watchOS platforms.
 * On macOS, use the NSImage extensions instead.
 */
extension UIImage {
    #if canImport(CoreImage)
    /**
     * Converts the UIImage to a CIImage.
     *
     * This method creates a CIImage from the UIImage. It first tries to use
     * the built-in ciImage property, then falls back to creating a new CIImage
     * from the UIImage if needed.
     *
     * - Returns: A CIImage representation of the UIImage, or nil if conversion fails.
     */
    func ciImage() -> CIImage? {
        return self.ciImage ?? CIImage(image: self)
    }
    #endif

    /**
     * Converts the UIImage to a CGImage.
     *
     * This method attempts to get the CGImage directly from the UIImage.
     * If that fails and Core Image is available, it falls back to converting
     * through CIImage.
     *
     * - Returns: A CGImage representation of the UIImage, or nil if conversion fails.
     */
    func cgImage() -> CGImage? {
        let rtnValue = self.cgImage
        #if canImport(CoreImage)
        return rtnValue ?? ciImage()?.cgImage()
        #else
        return rtnValue
        #endif
    }
}
#endif
