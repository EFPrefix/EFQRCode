//
//  NSImage+.swift
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

#if !canImport(UIKit)
import AppKit
import CoreImage

/**
 * Extensions for NSImage to support QR code generation and processing on macOS.
 *
 * This extension provides utility methods for NSImage that enable conversion
 * to other image formats used throughout the EFQRCode library.
 *
 * ## Features
 *
 * - Conversion to CIImage for Core Image processing
 * - Conversion to CGImage for Core Graphics operations
 * - Cross-platform compatibility with UIKit-based systems
 *
 * ## Usage
 *
 * ```swift
 * let nsImage = NSImage(named: "QRCode")
 * 
 * // Convert to CIImage for processing
 * if let ciImage = nsImage.ciImage() {
 *     // Use with Core Image filters
 * }
 * 
 * // Convert to CGImage for graphics operations
 * if let cgImage = nsImage.cgImage() {
 *     // Use with Core Graphics
 * }
 * ```
 *
 * ## Platform Support
 *
 * This extension is only available on macOS and other platforms that don't support UIKit.
 * On iOS, tvOS, and watchOS, use the UIImage extensions instead.
 */
extension NSImage {
    /**
     * Converts the NSImage to a CIImage.
     *
     * This method creates a CIImage from the NSImage using TIFF representation.
     * The resulting CIImage can be used with Core Image filters and processing.
     *
     * - Returns: A CIImage representation of the NSImage, or nil if conversion fails.
     */
    func ciImage() -> CIImage? {
        return self.tiffRepresentation(using: .none, factor: 0).flatMap(CIImage.init)
    }

    /**
     * Converts the NSImage to a CGImage.
     *
     * This method attempts to get the CGImage directly from the NSImage.
     * If that fails, it falls back to converting through CIImage.
     *
     * - Returns: A CGImage representation of the NSImage, or nil if conversion fails.
     */
    func cgImage() -> CGImage? {
        return self.cgImage(forProposedRect: nil, context: nil, hints: nil) ?? ciImage()?.cgImage()
    }
}
#endif
